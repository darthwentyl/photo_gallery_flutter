import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/utils/cameras_list.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _hasCamInit = false;
  CameraController? _controller;
  late Future<void> _initializationCameraFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
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
    if (!_hasCamInit) {
      _onNewCameraSelected(CamerasList.cameras[0]);
      _hasCamInit = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cameraModeControlWidget(),
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: FutureBuilder<void>(
                future: _initializationCameraFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _cameraPreview();
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // TODO: color to the style
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.grey,
                width: 3,
              ),
            ),
          ),
        ),
        _cameraControlWidget(),
      ],
    );
  }

  Widget _cameraPreview() {
    final CameraController cameraControl = _controller!;
    return CameraPreview(cameraControl);
  }

  Widget _cameraModeControlWidget() {
    final CameraController cameraController = _controller!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        CameraIconButton.button(Icons.flash_on, _onFlashModeClick),
        CameraIconButton.button(Icons.exposure, _onExposureClick),
        CameraIconButton.button(Icons.filter_center_focus, _onFilterFocusClick),
        CameraIconButton.button(
            cameraController.value.isCaptureOrientationLocked
                ? Icons.screen_lock_rotation
                : Icons.screen_rotation,
            _onCaptureOrientationClick),
      ],
    );
  }

  Widget _cameraControlWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        CameraIconButton.button(Icons.add_circle_outlined, _onTakePictureClick),
        CameraIconButton.button(
            Icons.flip_camera_android_outlined, _onFlipCameraClick),
      ],
    );
  }

  void _onNewCameraSelected(CameraDescription description) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = cameraController;
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });
    _initializationCameraFuture = cameraController.initialize();
  }

  void _onTakePictureClick() {}

  void _onFlipCameraClick() {}

  void _onFlashModeClick() {}

  void _onExposureClick() {}

  void _onFilterFocusClick() {}

  void _onCaptureOrientationClick() {}
}
