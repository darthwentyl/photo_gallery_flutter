import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';

import 'gallery_bottom_navigation_stateful_widget.dart';
import 'gallery_image_preview_stateful_widget.dart';
import 'gallery_map_view_stateful_widget.dart';

class GalleryImageViewStatefulWidget extends StatefulWidget {
  GalleryImageViewStatefulWidget(
      {Key? key, required this.fileList, required this.selectIndex})
      : super(key: key);

  List<File> fileList;
  int selectIndex;

  @override
  State<StatefulWidget> createState() => _GalleryImageViewState();
}

class _GalleryImageViewState extends State<GalleryImageViewStatefulWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: _getWidget(_currentIndex),
      backgroundColor: AppColor.galleryDirsCardViewBackground,
      bottomNavigationBar: GalleryBottomNavigationWidget(
        callback: _onSetNavAction,
      ),
    );
  }

  void _onSetNavAction(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getWidget(int index) {
    switch (index) {
      case 0:
        return GalleryImagePreviewStatefulWidget(
          fileList: widget.fileList,
          selectIndex: widget.selectIndex,
        );
      case 1:
        return GalleryMapViewStatefulWidget();
      default:
        return GalleryImagePreviewStatefulWidget(
          fileList: widget.fileList,
          selectIndex: widget.selectIndex,
        );
    }
  }
}
