import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/controllers/file_controllers.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/widgets/loading_widget.dart';

import 'gallery_image_view.dart';
import 'views/gallery_dir_grid_view.dart';

class GalleryDirWidgetStateful extends StatefulWidget {
  GalleryDirWidgetStateful({Key? key, required this.directory})
      : super(key: key);

  Directory directory;

  @override
  State<StatefulWidget> createState() => _GalleryDirWidgetState();
}

class _GalleryDirWidgetState extends State<GalleryDirWidgetStateful> {
  bool _isInit = false;
  List<File> _fileList = <File>[];

  @override
  void initState() {
    super.initState();
    // It should be always last!!!
    _getFileList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: _isInit
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: _fileList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GalleryDirGridViewStateful(
                          file: _fileList[index],
                          index: index,
                          callback: onTapItem,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const LoadingWidget(),
      backgroundColor: AppColor.galleryDirsCardViewBackground,
    );
  }

  void onTapItem(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewStatefulWidget(
          fileList: _fileList,
          selectIndex: index,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _getFileList() async {
    FileController fileController = FileController();
    String path = widget.directory.path;
    _fileList = await fileController.getFileList(path);

    setState(() {
      _isInit = true;
    });
  }
}
