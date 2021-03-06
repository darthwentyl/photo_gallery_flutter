import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/widgets/gallery_dirs_list_view_widget.dart';

class GalleryMainWidgetStateful extends StatefulWidget {
  const GalleryMainWidgetStateful({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryMainWidgetState();
}

class _GalleryMainWidgetState extends State<GalleryMainWidgetStateful> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GalleryDirsListViewWidgetStateful(),
      backgroundColor: AppColor.galleryBackground,
    );
  }
}
