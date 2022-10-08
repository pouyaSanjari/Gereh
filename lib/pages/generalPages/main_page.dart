import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/pages/chat/main.chat.page.dart';
import 'package:sarkargar/pages/profile_page/main.profile.page.dart';
import 'package:sarkargar/pages/test/test.map.dart';
import 'package:sarkargar/services/ui_design.dart';
import 'package:sarkargar/pages/jobsList/jobs_list.dart';
import 'package:sarkargar/pages/sabt_agahi/p0.main.page.dart';

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
        return const MainChatPage();
      case 2:
        return const MainRequestPage();
      case 3:
        return const JobsList();
      case 4:
        return const TestMap();
      default:
        return const ProfilePage();
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return uiDesign.buildBottomNavigationBar(
      currentIndex: currIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(currIndex == 0
                ? Iconsax.profile_circle5
                : Iconsax.profile_circle),
            label: 'پروفایل'),
        BottomNavigationBarItem(
            icon: Icon(
              currIndex == 1 ? Iconsax.sms5 : Iconsax.sms,
            ),
            label: 'گفتگو'),
        BottomNavigationBarItem(
            icon:
                Icon(currIndex == 2 ? Iconsax.add_circle5 : Iconsax.add_circle),
            label: 'ثبت آگهی'),
        BottomNavigationBarItem(
            icon: Icon(currIndex == 3 ? Iconsax.category_25 : Iconsax.category),
            label: 'آگهی ها'),
        const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.earthAmericas), label: 'نقشه')
      ],
      onTap: (value) {
        setState(() {
          currIndex = value!;
        });
      },
    );
  }
}
