import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gereh/pages/chat/chat_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/pages/profile_page/view/profile_page.dart';
import 'package:gereh/pages/jobsList/view/jobs_list.dart';
import 'package:gereh/pages/map/view/jobs_list_on_map.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:gereh/pages/sabt_agahi/mainPage/view/main_request_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currIndex = 3;
  int logInType = 1;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: UiDesign.cTheme(),
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
        return const ChatPage();
      case 2:
        return const MainRequestPage();
      case 3:
        return JobsListTest();
      case 4:
        return const JobsListOnMap();
      default:
        return ProfilePage();
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return UiDesign.buildBottomNavigationBar(
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
