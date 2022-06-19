import 'package:camera/camera.dart';
import 'package:photo_gallery/controllers/file_controllers.dart';
import 'package:photo_gallery/datas/address_information.dart';
import 'package:photo_gallery/datas/location_position.dart';
import 'package:photo_gallery/datas/photo_information.dart';

class PhotosList {
  final List<PhotoInformation> _photos = <PhotoInformation>[];
  PhotoInformation? _selectedPhoto;
  final FileController _fileController = FileController();

  void addPhoto(XFile photo, LocationPosition locationPosition,
      AddressInformation address) {
    _photos.add(
        PhotoInformation(photo: photo, locationPosition: locationPosition));
    try {
      _fileController.writeToExternalStorage(_photos.last, address);
    } on Exception catch (e) {
      // ignore exception
    }
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

  void selectPhoto(int index) {
    _selectedPhoto = _photos[index];
  }

  PhotoInformation? selectedPhoto() {
    if (_selectedPhoto == null && _photos.isNotEmpty) {
      _selectedPhoto = _photos.first;
    }
    return _selectedPhoto;
  }

  PhotoInformation operator [](int index) {
    return _photos[index];
  }
}
