import 'package:flutter/material.dart';

class MyTextStyles {
  MyTextStyles._();
  static TextStyle titrTextStyle() =>
      const TextStyle(fontFamily: 'titr', fontSize: 25);
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
