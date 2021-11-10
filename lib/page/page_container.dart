import 'package:flutter/material.dart';
import 'package:photo_gallery/page/main_page.dart';
import 'package:photo_gallery/page/take_photo_page.dart';
import 'package:photo_gallery/strings.dart';
import 'package:photo_gallery/styles.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  @override
  Widget build(BuildContext context) {
    return MainPage(
      takePhotos: TextButton(
        style: CustomButtonStyle.getFlatButtonStyle(context),
        onPressed: _showTakePhotoPage,
        child: Column(
          children: const [
            Icon(Icons.add_a_photo_outlined),
            Text(Strings.TAKE_PHOTO_BTN),
          ],
        ),
      ),
      showPhotos: TextButton(
        style: CustomButtonStyle.getFlatButtonStyle(context),
        onPressed: _showShowPhotosPage,
        child: Column(
          children: const [
            Icon(Icons.remove_red_eye_outlined),
            Text(Strings.SHOW_PHOTOS_BTN),
          ],
        ),
      ),
      sendExistPhotos: TextButton(
        style: CustomButtonStyle.getFlatButtonStyle(context),
        onPressed: _showSendPhotosPage,
        child: Column(
          children: const [
            Icon(Icons.wb_cloudy_outlined),
            Text(Strings.SEND_PHOTOS_BTN),
          ],
        ),
      ),
      login: TextButton(
        style: CustomButtonStyle.getFlatButtonStyle(context),
        onPressed: _showLoginPage,
        child: Column(
          children: const [
            Icon(Icons.login_outlined),
            Text(Strings.LOGIN_BTN),
          ],
        ),
      ),
    );
  }

  void _showTakePhotoPage() {
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => const TakePhotoPage(),
       fullscreenDialog: true,
     ),
   );
  }

  void _showShowPhotosPage() {
    // TODO:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("_showShowPhotosPage")));
  }

  void _showSendPhotosPage() {
    // TODO:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("_showSendPhotosPage")));
  }

  void _showLoginPage() {
    // TODO:
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("_showLoginPage")));
  }
}