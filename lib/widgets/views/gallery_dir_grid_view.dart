import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/styles.dart';

class GalleryDirGridViewStateful extends StatefulWidget {
  GalleryDirGridViewStateful(
      {Key? key,
      required this.file,
      required this.index,
      required this.callback})
      : super(key: key);

  File file;
  int index;
  void Function(int) callback;
  @override
  State<StatefulWidget> createState() => _GalleryDirGridViewState();
}

class _GalleryDirGridViewState extends State<GalleryDirGridViewStateful> {
  final double _fontSize = 15;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback(widget.index);
      },
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColor.galleryDirsCardViewBorder, width: 2),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(widget.file),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Text(
                _getDate(),
                style: TextStyle(
                    fontSize: _fontSize,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = AppColor.galleryDirGridViewStrokeFont),
              ),
              Text(
                _getDate(),
                style: TextStyle(
                  fontSize: _fontSize,
                  color: AppColor.galleryDirGridViewFont,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDate() {
    List<String> dateItem = widget.file.path.split('/').last.split('_');
    return ' ${dateItem[2]}-${dateItem[1]}-${dateItem[0]}';
  }
}
