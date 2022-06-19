import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/utils/photos_list.dart';

class PhotoListWidget extends StatefulWidget {
  PhotoListWidget({required this.photoList, required this.callback, Key? key})
      : super(key: key);

  PhotosList photoList;
  void Function(int) callback;

  @override
  State<PhotoListWidget> createState() => _PhotoListWidgetState();
}

class _PhotoListWidgetState extends State<PhotoListWidget> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    double itemSize = calcItemSize(context);
    return Container(
      height: itemSize,
      color: AppColor.cameraBackground,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int idx = widget.photoList.length() - index - 1;
            return InkWell(
              child: Container(
                width: itemSize,
                height: itemSize,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 2,
                    color: _index != idx
                        ? AppColor.cameraBackground
                        : AppColor.cameraBackgroundSelectImage,
                  ),
                  image: widget.photoList.isNotEmpty()
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              FileImage(File(widget.photoList[idx].photo.path)),
                        )
                      : null,
                ),
              ),
              onTap: () {
                _index = idx;
                widget.callback(idx);
              },
            );
          },
          itemCount: widget.photoList.length(),
        ),
      ),
    );
  }

  double calcItemSize(BuildContext context) {
    double itemSize = MediaQuery.of(context).size.height / 10;
    if (itemSize < 50.0) {
      itemSize = 50.0;
    } else if (itemSize > 80.0) {
      itemSize = 80.0;
    }
    return itemSize;
  }
}
