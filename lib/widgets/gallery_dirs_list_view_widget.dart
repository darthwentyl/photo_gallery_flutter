import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/controllers/file_controllers.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/widgets/gallery_dir_widget.dart';

import 'cards/gallery_dirs_card_view.dart';
import 'loading_widget.dart';

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
                        directoryPath: _directoryList[index].toString(),
                        index: index,
                        callback: onTapCallback);
                  },
                ),
              ),
            ],
          ))
        : const LoadingWidget();
  }

  void onTapCallback(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GalleryDirWidgetStateful(directory: _directoryList[idx]),
        fullscreenDialog: true,
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
