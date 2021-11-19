import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';

class PhotoBottomNavigationWidget extends StatelessWidget {
  const PhotoBottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
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
    );
  }
}
