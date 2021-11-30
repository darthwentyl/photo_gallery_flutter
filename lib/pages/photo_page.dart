import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/utils/photos_list.dart';
import 'package:photo_gallery/widgets/photo_bottom_navigation_widget.dart';
import 'package:photo_gallery/widgets/photo_main_widget.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({required this.photoList, Key? key}) : super(key: key);

  final PhotosList photoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: PhotoMainWidget(photoList: photoList),
      bottomNavigationBar: const PhotoBottomNavigationWidget(),
    );
  }
}
