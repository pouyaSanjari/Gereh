import 'package:flutter/material.dart';
import 'package:gereh/constants/my_colors.dart';

class UiDesign {
  ///تم نرمافزار
  static ThemeData cTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'sans',
      appBarTheme: const AppBarTheme(
          titleSpacing: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'sans',
            color: Colors.black,
            fontSize: 20,
          ),
          backgroundColor: MyColors.backgroundColor),
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: MyColors.red,
            secondary: MyColors.black,
            error: MyColors.red,
          ),
    );
  }

  ///نویگیشن بار صفحه اصلی
  static BottomNavigationBar buildBottomNavigationBar(
      {required ValueChanged<int?> onTap,
      required int currentIndex,
      required List<BottomNavigationBarItem> items}) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      selectedFontSize: 14,
      unselectedFontSize: 11,
      backgroundColor: const Color(0xfff2f5fc),
      selectedItemColor: MyColors.red,
      unselectedItemColor: Colors.black87,
      selectedIconTheme: const IconThemeData(color: MyColors.red, size: 30),
      onTap: onTap,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }

  static TextStyle titleTextStyle() => const TextStyle(fontSize: 20);
  static TextStyle descriptionsTextStyle() =>
      const TextStyle(color: Colors.grey, fontSize: 12);
}
