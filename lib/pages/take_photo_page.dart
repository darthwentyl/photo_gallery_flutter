import 'package:flutter/material.dart';
import 'package:photo_gallery/utils/permissions_requester.dart';
import 'package:photo_gallery/widgets/camera_main_widget.dart';
import 'package:photo_gallery/strings.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _isInit = false;
    _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.MAIN_TITLE),
      ),
      body: _isInit ? const CameraMainWidget() : null,
    );
  }

  void _checkPermissions() async {
    final PermissionsRequester permissionsRequester = PermissionsRequester();
    permissionsRequester.check().then((value) {
      setState(() {
        _isInit = true;
      });
    });
  }
}
