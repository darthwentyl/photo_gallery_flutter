import 'package:camera/camera.dart';
import 'package:photo_gallery/datas/location_position.dart';

class PhotoInformation {
  PhotoInformation({
    required this.photo,
    required this.locationPosition,
  });

  XFile photo;
  LocationPosition locationPosition;
}
