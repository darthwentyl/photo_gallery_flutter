import 'package:camera/camera.dart';
import 'package:photo_gallery/datas/location_position.dart';
import 'package:intl/intl.dart';

class PhotoInformation {
  PhotoInformation({
    required this.photo,
    required this.locationPosition,
  });

  XFile photo;
  LocationPosition locationPosition;

  String formatString() {
    DateTime now = new DateTime.now();
    DateFormat formatter = DateFormat('yyyy_MM_dd_hh_mm_ss');
    String formattedDate = formatter.format(now);
    return '${locationPosition.formatString()}$formattedDate';
  }
}
