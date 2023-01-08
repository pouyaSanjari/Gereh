import 'package:flutter/material.dart';
import 'package:gereh/constants/my_colors.dart';

class MyTextStyles {
  MyTextStyles._();
  static TextStyle titrTextStyle({Color? color}) => TextStyle(
      fontFamily: 'titr', fontSize: 25, color: color ?? MyColors.black);
  static TextStyle titleTextStyle(Color? color) => TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        wordSpacing: -2,
        color: color ?? Colors.black,
      );

  static TextStyle descriptionsTextStyle(Color? color) => TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 13,
        color: color ?? Colors.grey,
      );
}
