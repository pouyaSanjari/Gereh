import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:sarkargar/constants/colors.dart';

class UiDesign {
  ///تم نرمافزار
  static ThemeData cTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'sans',
      appBarTheme: AppBarTheme(
          titleSpacing: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontFamily: 'sans',
            color: Colors.black,
            fontSize: 20,
          ),
          backgroundColor: Colors.grey[50]),
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

  /// فاصله بین زمان حال و زمان دریافت شده رو به فارسی مینویسه
  static String timeFunction(String time) {
    var adTime = DateTime.parse(time);
    var now = DateTime.now();
    var difference = now.difference(adTime);

    var mins = difference.inMinutes;
    var hours = difference.inHours;
    var days = difference.inDays;
    if (days > 30) {
      return 'خیلی وقت پیش';
    } else if (days > 14 && days <= 30) {
      return 'بیش از دو هفته پیش';
    } else if (days > 7 && days <= 14) {
      return 'هفته پیش';
    } else if (days > 3 && days <= 7) {
      return 'همین هفته';
    } else if (days == 3) {
      return 'سه روز پیش';
    } else if (days == 2) {
      return 'دو روز پیش';
    } else if (days == 1) {
      return 'دیروز';
    } else if (hours >= 5) {
      return '$hours ساعت پیش';
    } else if (hours == 4) {
      return 'چهار ساعت پیش';
    } else if (hours == 3) {
      return 'سه ساعت پیش';
    } else if (hours == 2) {
      return 'دو ساعت پیش';
    } else if (mins > 45 && mins <= 59 || hours == 1) {
      return 'یک ساعت پیش';
    } else if (mins > 30 && mins < 45) {
      return 'نیم ساعت پیش';
    } else if (mins > 15 && mins < 30) {
      return 'ربع ساعت پیش';
    } else if (mins > 1 && mins < 15) {
      return 'چند دقیقه پیش';
    } else {
      return 'چند لحظه پیش';
    }
  }

  /// عدد دریافتی رو به فارسی می نویسه
  static String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  static TextStyle titleTextStyle() => const TextStyle(fontSize: 20);
  static TextStyle descriptionsTextStyle() =>
      const TextStyle(color: Colors.grey, fontSize: 12);
}
