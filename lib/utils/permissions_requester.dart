import 'package:permission_handler/permission_handler.dart';

class PermissionsRequester {
  Future<void> check() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.sms,
    ].request();

    statuses.forEach((key, status) async {
      switch (status) {
        case PermissionStatus.permanentlyDenied:
        case PermissionStatus.denied:
          await openAppSettings();
          break;
      }
    });
  }
}
