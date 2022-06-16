import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/datas/photo_information.dart';
import 'package:photo_gallery/exceptions/file_exception.dart';
import 'package:photo_gallery/strings.dart';

class FileController {
  Future<void> writeToExternalStorage(PhotoInformation image) async {
    String path = await _getFilePath(image);
    File xFile = File(image.photo.path);
    File file = File(path);
    print('[mw]: path: $path');
    file.writeAsBytes(xFile.readAsBytesSync());
  }

  Future<String> _getFilePath(PhotoInformation image) async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw FileException(
          code: FileExceptionCodes.external_storage_directory_does_not_exist,
          description: Strings.external_storage_directory_not_exist);
    }
    return '${directory.path}/${image.formatString()}';
  }
}
