import 'package:flutter/material.dart';

class MyTextStyles {
  MyTextStyles._();
  static TextStyle titrTextStyle() =>
      const TextStyle(fontFamily: 'titr', fontSize: 25);
  static TextStyle titleTextStyle() => const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        wordSpacing: -2,
      );

  static TextStyle descriptionsTextStyle() => const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 15,
        color: Colors.grey,
      );
}
