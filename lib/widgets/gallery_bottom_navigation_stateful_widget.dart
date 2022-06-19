import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';

class GalleryBottomNavigationWidget extends StatefulWidget {
  GalleryBottomNavigationWidget({Key? key, required this.callback})
      : super(key: key);

  void Function(int) callback;

  @override
  State<StatefulWidget> createState() => _GalleryBottomNavigationState();
}

class _GalleryBottomNavigationState
    extends State<GalleryBottomNavigationWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: AppColor.iconBottomNavigationSelect,
      unselectedItemColor: AppColor.iconBottomNavigationUnselect,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.image_outlined),
          label: Strings.galery_nav_bar,
          backgroundColor: AppColor.iconBottomNavigationBackground,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: Strings.map_nav_bar,
          backgroundColor: AppColor.iconBottomNavigationBackground,
        )
      ],
      onTap: _onTap,
    );
  }

  void _onTap(int value) {
    setState(() {
      _currentIndex = value;
      widget.callback(_currentIndex);
    });
  }
}
