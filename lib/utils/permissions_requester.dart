import 'package:permission_handler/permission_handler.dart';

// TODO: It needs refactor. The propositions is creating panel to choise which
// TODO: can be allowed. Maybe it needs divide to two section. First required,
// TODO: second optional
class PermissionsRequester {
  Future<void> check() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.storage,
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
