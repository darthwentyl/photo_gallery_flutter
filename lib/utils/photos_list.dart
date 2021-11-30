import 'package:camera/camera.dart';
import 'package:photo_gallery/datas/location_position.dart';
import 'package:photo_gallery/datas/photo_information.dart';

class PhotosList {
  final List<PhotoInformation> _photos = <PhotoInformation>[];

  void addPhoto(XFile photo, LocationPosition locationPosition) {
    _photos.add(
        PhotoInformation(photo: photo, locationPosition: locationPosition));
  }

  bool isNotEmpty() {
    return _photos.isNotEmpty;
  }

  String getLastPath() {
    return _photos.last.photo.path;
  }

  int length() {
    return _photos.length;
  }

  PhotoInformation operator [](int index) {
    return _photos[index];
  }
}
