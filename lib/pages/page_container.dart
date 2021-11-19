import 'package:flutter/material.dart';
import 'package:photo_gallery/pages/take_photo_page.dart';

import 'package:photo_gallery/styles.dart';

TextButton PageTextButton(BuildContext context, VoidCallback callback,
    IconData iconData, String name) {
  double fontSize = 14.0;
  double iconSize = 24.0;
  double width = MediaQuery.of(context).size.width - 16;
  double? height = iconSize + fontSize + 16;

  Icon icon = Icon(iconData, size: iconSize);
  Text text = Text(
    name,
    style: const TextStyle(height: 1.0),
  );

  final style = TextButton.styleFrom(
    fixedSize: Size(width, height),
    primary: AppColor.primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    backgroundColor: AppColor.backgroundColor,
  );
  return TextButton(
    style: style,
    onPressed: callback,
    child: Column(
      children: [
        icon,
        text,
      ],
    ),
  );
}

class PageContainer extends StatefulWidget {
  const PageContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  @override
  Widget build(BuildContext context) {
    return const TakePhotoPage();
  }
}
