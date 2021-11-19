import 'package:location/location.dart';

class LocationPosition {
  double latitude;
  double longitude;

  LocationPosition(
      {this.latitude = double.infinity, this.longitude = double.infinity});

  void setPosition(LocationData locationData) {
    final LocationData data = locationData;
    latitude = data.latitude!;
    longitude = data.longitude!;
  }

  String formatString() {
    return "${latitude}_${longitude}_";
  }

  @override
  String toString() {
    return "[lat: $latitude; long: $longitude]";
  }
}
