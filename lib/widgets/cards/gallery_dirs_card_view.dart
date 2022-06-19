import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_gallery/controllers/file_controllers.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/strings.dart';

class GalleryDirsCardViewStateful extends StatefulWidget {
  GalleryDirsCardViewStateful(
      {Key? key,
      required this.directoryPath,
      required this.index,
      required this.callback})
      : super(key: key);

  String directoryPath;
  int index;
  void Function(int) callback;

  @override
  State<StatefulWidget> createState() => _GalleryDirsCardViewState();
}

class _GalleryDirsCardViewState extends State<GalleryDirsCardViewStateful> {
  bool _isInit = false;
  List<File> _fileList = <File>[];
  String _city = '';
  String _directoryPath = '';

  @override
  void initState() {
    super.initState();
    _directoryPath = widget.directoryPath;
    _city = _getCity();
    // It should be always last!!!
    _getFileList();
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? GestureDetector(
            onTap: () {
              widget.callback(widget.index);
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 80,
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.galleryDirsCardViewBorder,
                            width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                              Strings.gallery_dirs_card_view_city, _city, 20),
                          _buildPadding(
                              Strings.gallery_dirs_card_last_item_date,
                              _getLastDate(),
                              16),
                          _buildPadding(Strings.gallery_dirs_card_item_count,
                              '${_fileList.length}', 12),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Padding _buildPadding(String name, String description, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$name: $description',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getCity() {
    String city = _directoryPath.split('/').last;
    city = city.substring(0, city.length - 1);
    return city;
  }

  Future<void> _getFileList() async {
    FileController fileController = FileController();
    String path = _directoryPath.substring(0, _directoryPath.length - 1);
    _fileList = await fileController.getFileList(path);

    setState(() {
      _isInit = true;
    });
  }

  String _getLastDate() {
    if (_fileList.isEmpty) {
      return '';
    }
    List<String> dateItem = _fileList.first.path.split('/').last.split('_');
    return '${dateItem[2]}-${dateItem[1]}-${dateItem[0]}';
  }

  File _getRandomImagePath() {
    final random = Random();
    return _fileList[random.nextInt(_fileList.length)];
  }
}
