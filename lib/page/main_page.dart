import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';

class MainPage extends StatefulWidget {
  final Widget takePhotos;
  final Widget showPhotos;
  final Widget sendExistPhotos;
  final Widget login;

  const MainPage({
    Key? key,
    required this.takePhotos,
    required this.showPhotos,
    required this.sendExistPhotos,
    required this.login,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    const SPACE_ELEM = SizedBox(height: 8);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:  [
            widget.takePhotos,
            SPACE_ELEM,
            widget.showPhotos,
            SPACE_ELEM,
            widget.sendExistPhotos,
            SPACE_ELEM,
            widget.login,
            SPACE_ELEM,
          ],
        ),
      ),
    );
  }

}