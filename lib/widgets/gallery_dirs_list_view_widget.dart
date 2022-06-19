import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/controllers/file_controllers.dart';
import 'package:photo_gallery/strings.dart';

import 'cards/gallery_dirs_card_view.dart';

class GalleryDirsListViewWidgetStateful extends StatefulWidget {
  const GalleryDirsListViewWidgetStateful({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryDirsListViewWidgetState();
}

class _GalleryDirsListViewWidgetState
    extends State<GalleryDirsListViewWidgetStateful> {
  final FileController _fileController = FileController();
  List<Directory> _directoryList = [];
  bool _isInit = false;

  @override
  void initState() {
    _getTreeDirectories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? Container(
            child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _directoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GalleryDirsCardViewStateful(
                          info: _directoryList[index].toString());
                    }),
              )
            ],
          ))
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

  Future<void> _getTreeDirectories() async {
    _directoryList = await _fileController.getDirectoriesList();
    setState(() {
      _isInit = true;
    });
  }
}
