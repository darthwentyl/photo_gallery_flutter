import 'package:photo_gallery/datas/location_position.dart';
import 'package:geocoding/geocoding.dart';

class AddressInformation {
  Placemark? _placemark;

  void setAddress(LocationPosition locationPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        locationPosition.latitude, locationPosition.longitude);

    if (placemarks.isNotEmpty) {
      _placemark = placemarks.first;
    }
  }

  Placemark? getAddress() {
    if (_placemark != null) {
      return _placemark;
    }
    return Placemark();
  }

  @override
  String toString() {
    if (_placemark != null) {
      return "Address:\n${_placemark}";
    } else {
      return "Address:\nN/A";
    }
  }
}
