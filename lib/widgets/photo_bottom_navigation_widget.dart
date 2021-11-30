import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';

class PhotoBottomNavigationWidget extends StatefulWidget {
  const PhotoBottomNavigationWidget({Key? key}) : super(key: key);

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
          icon: Icon(Icons.send_outlined),
          label: Strings.send_photo_nav_bar,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image_outlined),
          label: Strings.galery_nav_bar,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: Strings.map_nav_bar,
        )
      ],
      onTap: _onTap,
    );
  }

  void _onTap(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
