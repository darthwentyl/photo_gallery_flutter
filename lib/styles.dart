import 'package:flutter/material.dart';

class AppColor extends Color {
  AppColor(int value) : super(value);

  static const primaryColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color(0xFF2196F3);

  static const textColorDark = Color(0xFF3A3B3C);
  static const textColorLight = Color(0xFFFFFFFF);

  static const cameraIconColor = Color(0xFF000000);
}

class CustomButtonStyle {
  static ButtonStyle getFlatButtonStyle(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 16;
    return TextButton.styleFrom(
      fixedSize: Size(width, 56),
      primary: AppColor.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      backgroundColor: AppColor.backgroundColor,
    );
  }
}

class CameraIconButton {
  static IconButton button(IconData iconData, VoidCallback callback) {
    return IconButton(
      icon: Icon(iconData),
      color: AppColor.cameraIconColor,
      onPressed: callback,
    );
  }
}
