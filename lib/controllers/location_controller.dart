import 'package:location/location.dart';
import 'package:photo_gallery/datas/address_information.dart';
import 'package:photo_gallery/datas/location_position.dart';

class LocationController {
  final Location _location = Location();
  final LocationPosition _position = LocationPosition();
  final AddressInformation _addressInformation = AddressInformation();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  Future<void> initialize() async {
    await _location.changeSettings(interval: 60000);
    _location.onLocationChanged.listen((locationData) {
      print('[mw] ${_position.toString()}');
      _position.setPosition(locationData);
      _addressInformation.setAddress(_position);
    });
  }

  LocationPosition getLocation() {
    return _position;
  }

  AddressInformation getAddress() {
    return _addressInformation;
  }

  Future<void> _checkServiceEnabled() async {
    final Location location = _location;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future<void> _checkPermissionGranted() async {
    final Location location = _location;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
