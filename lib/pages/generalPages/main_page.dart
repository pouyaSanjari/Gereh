import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/pages/profile_page/profile_page.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/jobsList/jobs_list.dart';
import 'package:sarkargar/pages/my_ads/k_my_requests_page.dart';
import 'package:sarkargar/pages/adv_request/MainRequestPage/main_request_page.dart';

import '../chat/Views/chats.dart';

class MainPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MainPage();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
}
