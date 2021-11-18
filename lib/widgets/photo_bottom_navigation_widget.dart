import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoBottomNavigationWidget extends StatelessWidget {
  const PhotoBottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "dom",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          label: "mail",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "osoba",
        )
      ],
    );
  }
}
