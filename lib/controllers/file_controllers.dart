import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/datas/address_information.dart';
import 'package:photo_gallery/datas/photo_information.dart';
import 'package:photo_gallery/exceptions/file_exception.dart';
import 'package:photo_gallery/strings.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class FileController {
  bool _permissionGranted = false;

  Future<void> writeToExternalStorage(
      PhotoInformation image, AddressInformation address) async {
    if (!_permissionGranted) {
      await _getStoragePermission();
    }

    String path = await _getFilePath(image, address);

    File xFile = File(image.photo.path);
    File file = File(path);

    file.createSync(recursive: true);
    file.writeAsBytes(xFile.readAsBytesSync());
  }

  Future<List<File>> getFileList(String path) async {
    if (!_permissionGranted) {
      await _getStoragePermission();
    }
    // It needs remove additional text from path
    String directory = 'Directory: \'';
    path = path.substring(directory.length, path.length);
    List<File> listFile = await FileManager.listFiles(path);
    return listFile;
  }

  Future<List<Directory>> getDirectoriesList() async {
    if (!_permissionGranted) {
      await _getStoragePermission();
    }

    Directory directory = await _getDirectory();
    FileManager fileManager = FileManager(root: directory);

    List<Directory> directoryList = await fileManager.dirsTree();
    return directoryList;
  }

  Future<String> _getFilePath(
      PhotoInformation image, AddressInformation address) async {
    Directory directory = await _getDirectory();

    String? city = address.getAddress()?.locality;
    if (city == null) {
      return '${directory.path}/Not Known/${image.formatString()}';
    }

    return '${directory.path}/$city/${image.formatString()}.jpeg';
  }

  Future<Directory> _getDirectory() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw FileException(
          code: FileExceptionCodes.external_storage_directory_does_not_exist,
          description: Strings.external_storage_directory_not_exist);
    }
    return directory;
  }

  Future<void> _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      _permissionGranted = true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      _permissionGranted = false;
    }
  }
}
