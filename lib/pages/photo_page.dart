import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/utils/photos_list.dart';
import 'package:photo_gallery/widgets/gallery_main_widget.dart';
import 'package:photo_gallery/widgets/loading_widget.dart';
import 'package:photo_gallery/widgets/map_main_widget.dart';
import 'package:photo_gallery/widgets/photo_bottom_navigation_widget.dart';
import 'package:photo_gallery/widgets/photo_main_widget.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({required this.photoList, Key? key}) : super(key: key);

  final PhotosList photoList;

  @override
  State<StatefulWidget> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late PhotosList _photoList;
  bool _isInit = false;
  int _navActionIdx = 0;

  @override
  void initState() {
    super.initState();
    _photoList = widget.photoList;
    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? Scaffold(
            appBar: AppBar(
              title: const Text(Strings.MAIN_TITLE),
            ),
            body: _getWidget(_navActionIdx),
            bottomNavigationBar:
                PhotoBottomNavigationWidget(callback: _onSetNavAction),
          )
        : const LoadingWidget();
  }

  void _onSetNavAction(int index) {
    setState(() {
      _navActionIdx = index;
    });
  }

  Widget _getWidget(int index) {
    switch (index) {
      case 0:
        return PhotoMainWidget(photoList: _photoList);
      case 1:
        return GalleryMainWidgetStateful();
      case 2:
        return MapMainStatefulWidget(photoList: _photoList);
      default:
        return PhotoMainWidget(photoList: _photoList);
    }
  }
}
