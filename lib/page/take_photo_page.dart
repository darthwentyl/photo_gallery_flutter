import 'package:flutter/material.dart';
import 'package:photo_gallery/widgets/camera_main_widget.dart';
import 'package:photo_gallery/strings.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: const CameraMainWidget(),
    );
  }
}
