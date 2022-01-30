import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreviewWidget extends StatelessWidget {
  const PhotoPreviewWidget({required this.image});

  final FileImage image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        children: [
          PhotoView(
            imageProvider: image,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}
