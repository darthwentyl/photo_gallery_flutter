import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';

class PhotoBottomNavigationWidget extends StatefulWidget {
  PhotoBottomNavigationWidget({Key? key, required this.callback})
      : super(key: key);

  void Function(int) callback;

  @override
  State<StatefulWidget> createState() => PhotoBottomNavigationState();
}

class PhotoBottomNavigationState extends State<PhotoBottomNavigationWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.enhance_photo_translate_outlined),
          label: Strings.current_session,
          backgroundColor: AppColor.iconBottomNavigationBackground,
        ),
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
