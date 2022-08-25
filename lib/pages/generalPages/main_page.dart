import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/pages/profile_page/profile_page.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/jobsList/jobs_list.dart';
import 'package:sarkargar/pages/my_ads/k_my_requests_page.dart';
import 'package:sarkargar/pages/adv_request/MainRequestPage/main_request_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat/Views/chats.dart';

class MainPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MainPage();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SharedPreferences sharedPreferences;
  int currIndex = 3;
  int logInType = 1;
  UiDesign uiDesign = UiDesign();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: uiDesign.cTheme(),
        home: Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(),
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    switch (currIndex) {
      case 1:
        return const Chats();
      case 2:
        return const MainRequestPage();
      case 3:
        return const JobsList();
      case 4:
        return const MyRequests();
      default:
        return const ProfilePage();
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return uiDesign.buildBottomNavigationBar(
      currentIndex: currIndex,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle), label: 'پروفایل'),
        BottomNavigationBarItem(
            icon: Icon(
              Iconsax.sms,
            ),
            label: 'گفتگو'),
        BottomNavigationBarItem(
            icon: Icon(Iconsax.add_circle), label: 'ثبت آگهی'),
        BottomNavigationBarItem(icon: Icon(Iconsax.category), label: 'آگهی ها'),
        BottomNavigationBarItem(
            icon: Icon(Iconsax.wallet), label: 'آگهی های من')
      ],
      onTap: (value) {
        setState(() {
          currIndex = value!;
        });
      },
    );
  }

  initialShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      logInType = sharedPreferences.getInt('logInType') ?? 1;
    });
    //خارج کردن مقادیر شیرید پرفرنسز برای اولین بار از حالت نال
    sharedPreferences.getString('malePrice') ??
        sharedPreferences.setString('malePrice', '');
    sharedPreferences.getBool('malePriceVisibility') ??
        sharedPreferences.setBool('malePriceVisibility', true);
    sharedPreferences.getBool('ghimatTavafoghiMardBL') ??
        sharedPreferences.setBool('ghimatTavafoghiMardBL', false);
    sharedPreferences.getString('femalePrice') ??
        sharedPreferences.setString('femalePrice', '');
    sharedPreferences.getBool('femalePriceVisibility') ??
        sharedPreferences.setBool('femalePriceVisibility', true);
    sharedPreferences.getBool('ghimatTavafoghiZanBL') ??
        sharedPreferences.setBool('ghimatTavafoghiZanBL', false);
    sharedPreferences.getString('selectedProvince') ??
        sharedPreferences.setString('selectedProvince', '');
    sharedPreferences.getString('selectedCity') ??
        sharedPreferences.setString('selectedCity', '');
    sharedPreferences.getString('addressDetails') ??
        sharedPreferences.setString('addressDetails', '');
    sharedPreferences.getInt('adType') ?? sharedPreferences.setInt('adType', 0);
  }

  @override
  // ignore: must_call_super
  void initState() {
    initialShared();
  }
}
