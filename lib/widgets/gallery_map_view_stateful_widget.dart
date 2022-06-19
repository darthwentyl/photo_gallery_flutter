import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_gallery/datas/location_position.dart';
import 'package:photo_gallery/styles.dart';

class GalleryMapViewStatefulWidget extends StatefulWidget {
  GalleryMapViewStatefulWidget({Key? key, required this.image})
      : super(key: key);

  File image;

  @override
  State<StatefulWidget> createState() => _GalleryMapViewState();
}

class _GalleryMapViewState extends State<GalleryMapViewStatefulWidget> {
  final Completer<GoogleMapController> _googleMapController = Completer();

  @override
  Widget build(BuildContext context) {
    LocationPosition position = _getLocationPosition();
    return Scaffold(
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
                color: AppColor.googleMapfloatingActionButton, width: 1.25),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: FileImage(File(widget.image.path)),
            ),
          ),
        ),
        onTap: () => _goToPlace(),
      ),
    );
  }

  Future<void> _goToPlace() async {
    final GoogleMapController controller = await _googleMapController.future;
    // TODO: it is dangerous, you promise that the photo exist
    LocationPosition position = _getLocationPosition();
    CameraPosition _place = CameraPosition(
        bearing: 190.0,
        target: LatLng(position.latitude, position.longitude),
        tilt: 60.0,
        zoom: 20.0);
    controller.animateCamera(CameraUpdate.newCameraPosition(_place));
  }

  LocationPosition _getLocationPosition() {
    final File image = widget.image;
    const String jpeg = '.jpeg';
    List<String> items = image.path.split('/').last.split('_');
    double lat = double.parse(items[6]);

    double long =
        double.parse(items[7].substring(0, items[7].length - jpeg.length));
    return LocationPosition(latitude: lat, longitude: long);
  }
}
