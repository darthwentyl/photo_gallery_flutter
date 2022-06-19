import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/styles.dart';

class GalleryDirGridViewStateful extends StatefulWidget {
  GalleryDirGridViewStateful(
      {Key? key, required this.file, required this.index})
      : super(key: key);

  File file;
  int index;

  @override
  State<StatefulWidget> createState() => _GalleryDirGridViewState();
}

class _GalleryDirGridViewState extends State<GalleryDirGridViewStateful> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                    fontSize: 10,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = AppColor.galleryDirGridViewStrokeFont),
              ),
              Text(
                _getDate(),
                style: const TextStyle(
                  fontSize: 10,
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
