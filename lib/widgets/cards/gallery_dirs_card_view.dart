import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_gallery/controllers/file_controllers.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/strings.dart';

class GalleryDirsCardViewStateful extends StatefulWidget {
  GalleryDirsCardViewStateful({Key? key, required this.info}) : super(key: key);

  String info;

  @override
  State<StatefulWidget> createState() => _GalleryDirsCardViewState();
}

class _GalleryDirsCardViewState extends State<GalleryDirsCardViewStateful> {
  bool _isInit = false;
  List<File> _fileList = <File>[];
  String _city = '';
  String _info = '';

  @override
  void initState() {
    super.initState();
    _info = widget.info;
    _city = _getCity();
    // It should be always last!!!
    _getFileList();
  }

  @override
  Widget build(BuildContext context) {
    // String randomImagePath = _getRandomImagePath();
    return _isInit
        ? Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 65,
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.galleryDirsCardViewBorder, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(_getRandomImagePath()),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildPadding(
                            Strings.gallery_dirs_card_view_city, _city),
                        _buildPadding(Strings.gallery_dirs_card_item_count,
                            '${_fileList.length}'),
                        _buildPadding(Strings.gallery_dirs_card_last_item_date,
                            _getLastDate()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Text(Strings.LOADING),
              ],
            ),
          );
  }

  Padding _buildPadding(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$name: $description',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getCity() {
    String city = _info.split('/').last;
    city = city.substring(0, city.length - 1);
    return city;
  }

  Future<void> _getFileList() async {
    FileController fileController = FileController();
    String path = _info.substring(0, _info.length - 1);
    _fileList = await fileController.getFileList(path);

    setState(() {
      _isInit = true;
    });
  }

  String _getLastDate() {
    if (_fileList.isEmpty) {
      return '';
    }
    List<String> dateItem = _fileList.last.path.split('/').last.split('_');
    return '${dateItem[2]}-${dateItem[1]}-${dateItem[0]}';
  }

  File _getRandomImagePath() {
    final random = Random();
    return _fileList[random.nextInt(_fileList.length)];
  }
}
