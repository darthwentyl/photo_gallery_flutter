import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';

class MainPage extends StatefulWidget {
  final Widget login;

  const MainPage({
    Key? key,
    required this.login,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.login,
          ],
        ),
      ),
    );
  }
}
