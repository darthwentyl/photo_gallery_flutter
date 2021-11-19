import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/pages/page_container.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';
import 'package:photo_gallery/utils/cameras_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CamerasList.cameras = await availableCameras();

  runApp(const PhotoGalleryApp());
}

class PhotoGalleryApp extends StatelessWidget {
  const PhotoGalleryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      fontFamily: "Cabin",
      primaryColor: AppColor.primaryColor,
      primaryTextTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColor.textColorDark,
            displayColor: AppColor.textColorDark,
          ),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColor.textColorDark,
            displayColor: AppColor.textColorDark,
          ),
    );

    return MaterialApp(
      title: Strings.MAIN_TITLE,
      theme: theme,
      home: const PageContainer(),
    );
  }
}
