import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/utils/photos_list.dart';
import 'package:photo_gallery/widgets/photo_list_widget.dart';
import 'package:photo_gallery/widgets/photo_preview_widget.dart';

import 'loading_widget.dart';

class PhotoMainWidget extends StatefulWidget {
  final PhotosList photoList;

  const PhotoMainWidget({
    required this.photoList,
  });

  @override
  State<StatefulWidget> createState() => _PhotoMainWidget();
}

class _PhotoMainWidget extends State<PhotoMainWidget> {
  bool _isInit = false;
  late PhotosList _photoList;
  int _photoIndex = 0;

  @override
  void initState() {
    super.initState();
    _isInit = false;
    _photoList = widget.photoList;
    _photoIndex = _photoList.length() - 1;
    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhotoListWidget(
                photoList: _photoList,
                callback: onSetImage,
              ),
              PhotoPreviewWidget(
                  image: FileImage(File(_photoList[_photoIndex].photo.path))),
            ],
          )
        : const LoadingWidget();
  }

  void onSetImage(int index) {
    setState(() {
      _photoIndex = index;
      _photoList.selectPhoto(index);
    });
  }
}
