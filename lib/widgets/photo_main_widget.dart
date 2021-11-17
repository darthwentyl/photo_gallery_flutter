import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/widgets/photo_list_widget.dart';
import 'package:photo_gallery/widgets/photo_preview_widget.dart';

class PhotoMainWidget extends StatefulWidget {
  final List<XFile> photoList;

  const PhotoMainWidget({
    required this.photoList,
  });

  @override
  State<StatefulWidget> createState() {
    return _PhotoMainWidget();
  }
}

class _PhotoMainWidget extends State<PhotoMainWidget> {
  bool _isInit = false;
  late List<XFile> _photoList;
  int _photoIndex = 0;

  @override
  void initState() {
    super.initState();
    _isInit = false;
    _photoList = widget.photoList;
    _photoIndex = _photoList.length - 1;
    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PhotoListWidget(
                photoList: _photoList,
                callback: onSetImage,
              ),
              PhotoPreviewWidget(
                  image: FileImage(File(_photoList[_photoIndex].path))),
            ],
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

  void onSetImage(int index) {
    setState(() {
      _photoIndex = index;
    });
  }
}
