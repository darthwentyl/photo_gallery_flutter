import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_gallery/widgets/photo_preview_widget.dart';

class GalleryImagePreviewStatefulWidget extends StatefulWidget {
  GalleryImagePreviewStatefulWidget(
      {Key? key, required this.fileList, required this.selectIndex})
      : super(key: key);

  List<File> fileList;
  int selectIndex;

  @override
  State<StatefulWidget> createState() => _GalleryImagePreviewState();
}

class _GalleryImagePreviewState
    extends State<GalleryImagePreviewStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PhotoPreviewWidget(
            image: FileImage(File(widget.fileList[widget.selectIndex].path))),
      ],
    );
  }
}
