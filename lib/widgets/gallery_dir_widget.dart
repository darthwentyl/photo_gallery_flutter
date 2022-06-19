import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';

class GalleryDirWidgetStateful extends StatefulWidget {
  GalleryDirWidgetStateful({Key? key, required this.directory})
      : super(key: key);

  Directory directory;

  @override
  State<StatefulWidget> createState() => _GalleryDirWidgetState();
}

class _GalleryDirWidgetState extends State<GalleryDirWidgetStateful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: Center(
        child: Text('TBD'),
      ),
    );
  }
}
