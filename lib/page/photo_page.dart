import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({required this.path, Key? key}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.TAKE_PHOTO_TITLE),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(
              File(path),
              alignment: Alignment.center,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ],
        ),
      ),
    );
  }
}
