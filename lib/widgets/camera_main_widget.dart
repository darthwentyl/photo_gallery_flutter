import 'dart:io';
import 'dart:core';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_gallery/datas/address_information.dart';
import 'package:photo_gallery/datas/location_position.dart';
import 'package:photo_gallery/controllers/location_controller.dart';
import 'package:photo_gallery/pages/photo_page.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/utils/cameras_list.dart';
import 'package:photo_gallery/utils/photos_list.dart';

import 'loading_widget.dart';

class CameraMainWidget extends StatefulWidget {
  const CameraMainWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraMainWidgetState();
}

class _CameraMainWidgetState extends State<CameraMainWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _isCameraInit = false;
  CameraController? _cameraController;
  final LocationController _locationController = LocationController();
  final PhotosList _photos = PhotosList();

  late ResolutionPreset _currResolutionPreset = ResolutionPreset.high;

  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  late AnimationController _resolutionPresetModeRowAnimationController;
  late Animation<double> _resolutionPresetModeRowAnimation;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  int _pointers = 0; // count fingers

  ExposureMode _exposureMode = ExposureMode.auto;

  static IconButton cameraIconButton(IconData iconData, VoidCallback? callback,
      {Color color = AppColor.cameraIconColor, double size = 24.0}) {
    return IconButton(
      icon: Icon(
        iconData,
        color: color,
        size: size,
      ),
      color: AppColor.cameraIconColor,
      onPressed: callback,
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance!.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _resolutionPresetModeRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resolutionPresetModeRowAnimation = CurvedAnimation(
      parent: _resolutionPresetModeRowAnimationController,
      curve: Curves.easeInCubic,
    );

    _locationController.initialize();
    _onNewCameraSelected(CamerasList.cameras[0]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    _resolutionPresetModeRowAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _cameraController!;
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraController cameraController = _cameraController!;
    return _isCameraInit
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _cameraModeControlWidget(),
              Expanded(
                child: Container(
                  color: AppColor.cameraBackground,
                  child: Stack(
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: 1 / cameraController.value.aspectRatio,
                          child: _cameraPreviewWidget(),
                        ),
                      ),
                      _flashModeControlWidget(),
                      _exposureModeControlWidget(),
                      _filterFocusModeWidget(),
                      _resolutionPresetModeWidget(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _cameraZoomWidget(),
                          _cameraControlWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const LoadingWidget();
  }

  Widget _cameraPreviewWidget() {
    final CameraController cameraController = _cameraController!;

    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: CameraPreview(
        cameraController,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onTapDown: (details) => onViewFinderTap(details, constraints),
          );
        }),
      ),
    );
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
    setState(() {});
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    final CameraController cameraController = _cameraController!;
    if (_pointers != 2) {
      return;
    }
    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await cameraController.setZoomLevel(_currentScale);
    setState(() {});
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final CameraController cameraController = _cameraController!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Widget _cameraZoomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.cameraZoomBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _currentScale.toStringAsFixed(1) + 'x',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cameraModeControlWidget() {
    final CameraController cameraController = _cameraController!;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          cameraIconButton(Icons.flash_on, _onFlashModeClick),
          cameraIconButton(Icons.exposure, _onExposureClick),
          cameraIconButton(Icons.filter_center_focus, _onFilterFocusClick),
          cameraIconButton(
              cameraController.value.isCaptureOrientationLocked
                  ? Icons.screen_lock_rotation
                  : Icons.screen_rotation,
              _onCaptureOrientationClick),
          cameraIconButton(
              Icons.aspect_ratio_outlined, _onPresetResolutionClick),
        ],
      ),
    );
  }

  Widget _cameraControlWidget() {
    return Container(
      color: const Color(0x2F000000),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _onFlipCameraClick(),
              child: const Icon(Icons.flip_camera_android_outlined,
                  color: AppColor.cameraControlColor, size: 45),
            ),
            InkWell(
              onTap: () => _onTakePictureClick(),
              child: const Icon(Icons.circle,
                  color: AppColor.cameraControlColor, size: 60),
            ),
            InkWell(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColor.cameraBoxDecorationBorder, width: 1.25),
                  image: _photos.isNotEmpty()
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(_photos.getLastPath())),
                        )
                      : null,
                ),
              ),
              onTap: () => _onShowPictures(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initCamera(CameraController controller) async {
    await controller.initialize();
    await Future.wait([
      controller
          .getMinExposureOffset()
          .then((value) => _minAvailableExposureOffset = value),
      controller
          .getMaxExposureOffset()
          .then((value) => _maxAvailableExposureOffset = value),
      controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
      controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
    ]);
  }

  Future<void> _onNewCameraSelected(CameraDescription description) async {
    _isCameraInit = false;
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    final CameraController cameraController = CameraController(
        description, _currResolutionPreset,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);

    _cameraController = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    await initCamera(cameraController);

    if (mounted) {
      setState(() {
        _isCameraInit = cameraController.value.isInitialized;
      });
    }
  }

  Future<XFile?> takePhoto() async {
    final CameraController cameraController = _cameraController!;

    if (cameraController.value.isTakingPicture) {
      return null;
    }
    XFile photo = await cameraController.takePicture();
    return photo;
  }

  void _onTakePictureClick() async {
    final LocationController locationController = _locationController;

    LocationPosition pos = locationController.getLocation();
    AddressInformation address = locationController.getAddress();

    takePhoto().then((XFile? file) {
      if (mounted) {
        setState(() {
          if (file != null) {
            _photos.addPhoto(file, pos, address);
          }
        });
      }
    });
  }

  void _onFlipCameraClick() {
    final CameraController cameraController = _cameraController!;
    for (var element in CamerasList.cameras) {
      if (cameraController.description.lensDirection != element.lensDirection) {
        _onNewCameraSelected(element);
        break;
      }
    }
  }

  void _onCaptureOrientationClick() async {
    final CameraController cameraController = _cameraController!;
    if (cameraController.value.isCaptureOrientationLocked) {
      await cameraController.unlockCaptureOrientation();
    } else {
      await cameraController.lockCaptureOrientation();
    }
  }

  Widget _flashModeControlWidget() {
    final CameraController cameraController = _cameraController!;

    Widget iconButton(IconData iconData, FlashMode flashMode) {
      return IconButton(
          icon: Icon(iconData),
          color: cameraController.value.flashMode == flashMode
              ? AppColor.cameraSelectMode
              : AppColor.cameraUnselectMode,
          onPressed: () => onSetFlashModeButtonPressed(flashMode));
    }

    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: Container(
        color: AppColor.cameraModeBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            iconButton(Icons.flash_off, FlashMode.off),
            iconButton(Icons.flash_auto, FlashMode.auto),
            iconButton(Icons.flash_on, FlashMode.always),
            iconButton(Icons.highlight, FlashMode.torch),
          ],
        ),
      ),
    );
  }

  void onSetFlashModeButtonPressed(FlashMode flashMode) {
    setFlashMode(flashMode).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> setFlashMode(flashMode) async {
    final CameraController cameraController = _cameraController!;
    await cameraController.setFlashMode(flashMode);
  }

  Widget _exposureModeControlWidget() {
    final CameraController cameraController = _cameraController!;

    TextButton buttonText(String text, ExposureMode exposureMode,
        VoidCallback? pressCallback, VoidCallback? longCallback) {
      return TextButton(
          child: Text(text),
          style: TextButton.styleFrom(
            primary: cameraController.value.exposureMode == exposureMode
                ? AppColor.cameraSelectMode
                : AppColor.cameraUnselectMode,
          ),
          onPressed: pressCallback ??
              () => onSetExposureModeButtonPressed(exposureMode),
          onLongPress: longCallback);
    }

    int sliderDivision = 10 *
        (_minAvailableExposureOffset.abs().toInt() +
            _maxAvailableExposureOffset.abs().toInt());

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: Container(
        color: AppColor.cameraModeBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(Strings.EXPOSURE_MODE),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                buttonText(Strings.AUTO_EXPOSURE_MODE, ExposureMode.auto, null,
                    () => cameraController.setExposurePoint(null)),
                buttonText(Strings.LOCKED_EXPOSURE_MODE, ExposureMode.locked,
                    null, null),
                buttonText(Strings.RESET_EXPOSURE_MODE, ExposureMode.locked,
                    () => setExposureOffset(0.0), null),
              ],
            ),
            const Center(
              child: Text(Strings.EXPOSURE_OFFSET),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_minAvailableExposureOffset.toString()),
                Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toStringAsFixed(2),
                    divisions: sliderDivision > 0 ? sliderDivision : null,
                    onChanged: (_minAvailableExposureOffset ==
                                _maxAvailableExposureOffset ||
                            _exposureMode == ExposureMode.auto)
                        ? null
                        : setExposureOffset),
                Text(_maxAvailableExposureOffset.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted)
        setState(() {
          _exposureMode = mode;
        });
    });
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    final CameraController cameraController = _cameraController!;
    await cameraController.setExposureMode(mode);
  }

  Future<void> setExposureOffset(double offset) async {
    final CameraController cameraController = _cameraController!;
    setState(() {
      _currentExposureOffset = offset;
    });
    // TODO: setExposureOffset throw nullable exception but if it ignores that
    // TODO: all work fine
    try {
      offset = await cameraController.setExposureOffset(offset);
    } on CameraException catch (e) {
      print('Ignore exception!!!');
    }
  }

  Widget _filterFocusModeWidget() {
    final CameraController cameraController = _cameraController!;

    TextButton buttonText(
        String text, FocusMode focusMode, VoidCallback? longCallback) {
      return TextButton(
          child: Text(text),
          style: TextButton.styleFrom(
            primary: cameraController.value.focusMode == focusMode
                ? AppColor.cameraSelectMode
                : AppColor.cameraUnselectMode,
          ),
          onPressed: () => onSetFocusModeButtonPressed(focusMode),
          onLongPress: longCallback);
    }

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: Container(
        color: AppColor.cameraModeBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(Strings.FOCUS_MODE),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                buttonText(Strings.FOCUS_AUTO, FocusMode.auto,
                    () => cameraController.setFocusPoint(null)),
                buttonText(Strings.FOCUS_LOCKED, FocusMode.locked, null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setFocusMode(FocusMode mode) async {
    final CameraController cameraController = _cameraController!;
    await cameraController.setFocusMode(mode);
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) setState(() {});
    });
  }

  Widget _resolutionPresetModeWidget() {
    TextButton buttonText(String text, ResolutionPreset resolutionPreset) {
      return TextButton(
        child: Text(text),
        style: TextButton.styleFrom(
          primary: resolutionPreset == _currResolutionPreset
              ? AppColor.cameraSelectMode
              : AppColor.cameraUnselectMode,
        ),
        onPressed: () => onSetResolutionPreset(resolutionPreset),
      );
    }

    return SizeTransition(
      sizeFactor: _resolutionPresetModeRowAnimation,
      child: Container(
        color: AppColor.cameraModeBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            buttonText(ResolutionPreset.low.toString().split('.')[1],
                ResolutionPreset.low),
            buttonText(ResolutionPreset.medium.toString().split('.')[1],
                ResolutionPreset.medium),
            buttonText(ResolutionPreset.high.toString().split('.')[1],
                ResolutionPreset.high),
            buttonText(ResolutionPreset.max.toString().split('.')[1],
                ResolutionPreset.max),
          ],
        ),
      ),
    );
  }

  Future<void> setResolutionPreset(ResolutionPreset resolutionPreset) async {
    final CameraController cameraController = _cameraController!;
    _currResolutionPreset = resolutionPreset;
    await _onNewCameraSelected(cameraController.description);
  }

  void onSetResolutionPreset(ResolutionPreset resolutionPreset) {
    setResolutionPreset(resolutionPreset).then((_) {
      if (mounted) {
        setState(() {
          _currResolutionPreset = resolutionPreset;
        });
      }
    });
  }

  void _onPresetResolutionClick() {
    if (_resolutionPresetModeRowAnimationController.value == 1) {
      _resolutionPresetModeRowAnimationController.reverse();
    } else {
      _resolutionPresetModeRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void _onExposureClick() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
      _resolutionPresetModeRowAnimationController.reverse();
    }
  }

  void _onFilterFocusClick() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
      _resolutionPresetModeRowAnimationController.reverse();
    }
  }

  void _onFlashModeClick() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
      _resolutionPresetModeRowAnimationController.reverse();
    }
  }

  _onShowPictures() {
    if (_photos.isNotEmpty()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoPage(photoList: _photos),
          fullscreenDialog: true,
        ),
      );
    }
  }
}
