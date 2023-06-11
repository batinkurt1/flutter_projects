import 'package:flutter/material.dart';

class TextStyles {

  static const mainColor = Colors.teal;

  static TextStyle mainStyle({double fontSize, FontWeight fontWeight}){
    return TextStyle(
      fontSize: fontSize == null ? 12.0 : fontSize,
      color: mainColor,
      fontWeight: fontWeight == null ? FontWeight.w400 : fontWeight,
    );
  }

}