import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/datas/contact_information.dart';
import 'package:photo_gallery/datas/photo_information.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/widgets/contact_widget.dart';

import 'loading_widget.dart';

class MmsWidget extends StatefulWidget {
  MmsWidget({Key? key, required this.photo}) : super(key: key);

  PhotoInformation photo;

  @override
  State<StatefulWidget> createState() => MmsState();
}

class MmsState extends State<MmsWidget> {
  late PhotoInformation _photo;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();

    _photo = widget.photo;
    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      return Column(
        children: [
          ContactWidget(photo: _photo),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}
