import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../pages/generalPages/settings.dart';

class UiDesign {
  AppBar buildAppBar({required BuildContext context, required String title}) {
    return AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: const FaIcon(
              Iconsax.alarm,
              color: Colors.black,
              size: 21,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ));
              },
              icon: const Icon(
                Iconsax.setting,
                color: Colors.black,
              ))
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.grey,
            statusBarBrightness: Brightness.dark),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent);
  }

  ///تم نرمافزار
  ThemeData cTheme() {
    return ThemeData(
        cardTheme: const CardTheme(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        fontFamily: 'sans',
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'sans',
              color: Colors.black,
              fontSize: 20,
            ),
            backgroundColor: Color.fromARGB(255, 250, 250, 250)),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.black,
              secondary: Colors.black,
            ));
  }

  ///دکمه های سفارشی
  RawMaterialButton cRawMaterialButton(
      {String? text,
      VoidCallback? onClick,
      Color? fillColor,
      Widget? icon,
      Color? borderColor}) {
    return RawMaterialButton(
      onPressed: onClick,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      fillColor: fillColor ?? Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          side: BorderSide(color: borderColor ?? Colors.transparent)),
      child: icon ??
          Text(
            text!,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
    );
  }

  TextField cTextField(
      {required String labeltext,
      Icon? icon,
      required TextEditingController control,
      String? hint,
      int? minLine,
      String? error,
      int? length,
      TextInputType? textInputType,
      int? maxLine,
      bool? enabled,
      Widget? suffix,
      ValueChanged<String>? onSubmit,
      TextInputAction? textInputAction,
      ValueChanged<String>? onChange}) {
    return TextField(
      textInputAction: textInputAction,
      onSubmitted: onSubmit,
      onChanged: onChange,
      enabled: enabled,
      controller: control,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      onTap: () {
        if (control.selection ==
            TextSelection.fromPosition(
                TextPosition(offset: control.text.length - 1))) {
          control.selection = TextSelection.fromPosition(
              TextPosition(offset: control.text.length));
        }
      },
      maxLength: length ?? 30,
      keyboardType: textInputType ?? TextInputType.text,
      minLines: minLine,
      maxLines: maxLine ?? 1,
      decoration: InputDecoration(
        errorText: error,
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        suffixIcon: control.text.isEmpty ? null : suffix,
        counterText: '',
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: hint,
        prefixIcon: icon,
        labelText: labeltext,
        labelStyle: const TextStyle(
          color: Colors.black38,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }

  //تکست فیلد انتخاب دسته بندی
  TextField cCategorySelection({
    required String labeltext,
    required GestureTapCallback? onClick,
    TextEditingController? control,
    Icon? icon,
    String? error,
    String? hint,
  }) {
    return TextField(
      readOnly: true,
      controller: control,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.start,
      onTap: onClick,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorText: error,
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        counterText: '',
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: hint,
        prefixIcon: icon,
        labelText: labeltext,
        labelStyle: const TextStyle(
          color: Colors.black38,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }

  TextField chatTextField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      textDirection: TextDirection.rtl,
      onTap: () {
        if (controller.selection ==
            TextSelection.fromPosition(
                TextPosition(offset: controller.text.length - 1))) {
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        }
      },
      decoration: const InputDecoration(
        hintTextDirection: TextDirection.rtl,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        filled: true,
        fillColor: Color.fromARGB(31, 99, 99, 99),
        hintText: 'پیامی بنویسید ...',
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(80))),
      ),
    );
  }

//آیکان های گرد با تکست
  Widget roundedIconWithText(
      {required Widget icon,
      required Color backColor,
      required String text,
      required VoidCallback onClick}) {
    return Column(
      children: [
        RawMaterialButton(
          elevation: 0,
          fillColor: backColor,
          padding: const EdgeInsets.all(15),
          shape: const CircleBorder(),
          onPressed: onClick,
          child: icon,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

  DropdownSearch<String> dropdownSearch(
      {required String selectedItem,
      required ValueChanged<String?> onChange,
      required List<String> items,
      bool? enabled}) {
    return DropdownSearch(
      mode: Mode.DIALOG,
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              hintText: 'جستجو',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  )),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  )))),
      items: items,
      enabled: enabled ?? true,
      showSelectedItems: true,
      selectedItem: selectedItem,
      dropdownSearchDecoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blueGrey)),
      ),
      onChanged: onChange,
    );
  }

//نویگیشن بار صفحه اصلی
  BottomNavigationBar buildBottomNavigationBar(
      {required ValueChanged<int?> onTap,
      required int currentIndex,
      required List<BottomNavigationBarItem> items}) {
    return BottomNavigationBar(
      selectedFontSize: 15,
      unselectedFontSize: 11,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color.fromARGB(255, 184, 184, 184),
      selectedIconTheme: const IconThemeData(color: Colors.black),
      onTap: onTap,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }

  Center errorWidget(VoidCallback? referesh) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Iconsax.info_circle,
          size: 150,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        const Text(
          'اتصال اینترنت خود را بررسی کنید...',
        ),
        TextButton(onPressed: referesh, child: const Text('تلاش مجدد'))
      ],
    ));
  }

  FlutterSwitch cSwitch(bool val, ValueChanged<bool> onChange) {
    return FlutterSwitch(
        padding: 2,
        activeColor: Colors.green,
        height: 28,
        width: 55,
        value: val,
        onToggle: onChange);
  }

  String timeFunction(String time) {
    var adTime = DateTime.parse(time);
    var now = DateTime.now();
    var difference = now.difference(adTime);
    var mins = difference.inMinutes;
    var hours = difference.inHours;
    var days = difference.inDays;
    if (days > 30) {
      return 'خیلی وقت پیش';
    } else if (days > 14 && days < 30) {
      return 'بیش از دو هفته پیش';
    } else if (days > 7 && days < 14) {
      return 'هفته پیش';
    } else if (days > 3 && days < 7) {
      return 'همین هفته';
    } else if (days == 3) {
      return 'سه روز پیش';
    } else if (days == 2) {
      return 'دو روز پیش';
    } else if (days == 1) {
      return 'دیروز';
    } else if (hours > 4) {
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

  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  TextStyle titleTextStyle() => const TextStyle(fontSize: 20);
  TextStyle descriptionsTextStyle() =>
      const TextStyle(color: Colors.grey, fontSize: 12);
}
