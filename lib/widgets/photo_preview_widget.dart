import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/styles.dart';

class PhotoPreviewWidget extends StatelessWidget {
  const PhotoPreviewWidget({required this.image});

  final FileImage image;

  @override
  Widget build(BuildContext context) {
    // TODO: zoom or scrolling
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.cameraBackground,
          image: DecorationImage(image: image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
