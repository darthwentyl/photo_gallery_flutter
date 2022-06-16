import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_gallery/datas/location_position.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/utils/photos_list.dart';
import 'package:photo_gallery/strings.dart';

class MapMainStatefulWidget extends StatefulWidget {
  MapMainStatefulWidget({Key? key, required this.photoList}) : super(key: key);
  PhotosList photoList;

  @override
  State<StatefulWidget> createState() => _MapMainStateWidget();
}

class _MapMainStateWidget extends State<MapMainStatefulWidget> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  bool _isInit = false;
  late PhotosList _photoList;

  @override
  void initState() {
    _photoList = widget.photoList;
    setState(() {
      _isInit = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: it is dangerous, you promise that the photo exist
    LocationPosition position = _photoList.selectedPhoto()!.locationPosition;
    XFile photo = _photoList.selectedPhoto()!.photo;
    return _isInit
        ? Scaffold(
            body: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _googleMapController.complete(controller);
              },
            ),
            floatingActionButton: InkWell(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: AppColor.googleMapfloatingActionButton,
                      width: 1.25),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(File(photo.path)),
                  ),
                ),
              ),
              onTap: () => _goToPlace(),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Text(Strings.LOADING),
              ],
            ),
          );
  }

  Future<void> _goToPlace() async {
    final GoogleMapController controller = await _googleMapController.future;
    // TODO: it is dangerous, you promise that the photo exist
    LocationPosition position = _photoList.selectedPhoto()!.locationPosition;
    CameraPosition _place = CameraPosition(
        bearing: 190.0,
        target: LatLng(position.latitude, position.longitude),
        tilt: 60.0,
        zoom: 20.0);
    controller.animateCamera(CameraUpdate.newCameraPosition(_place));
  }
}
