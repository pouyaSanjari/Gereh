import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/services/database.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final box = GetStorage();
  UiDesign uiDesign = UiDesign();
  AppDataBase dataBase = AppDataBase();
  bool workGroupDropDownEnabled = false;
// لیست عناوین شغلی
  List<String> jobTitles = [];
  int parentnumber = 0;
  String workGroup = '';
  String job = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: const Text('انتخاب شغل',
                  style: TextStyle(color: Colors.black)),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context, ''),
                    icon: const Icon(
                      Iconsax.arrow_left,
                      color: Colors.black,
                    ))
              ]),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset('assets/SVG/filter.svg',
                        width: 200, height: 200),
                  ),
                  const SizedBox(height: 20),
                  const Text('انتخاب دسته بندی',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('شغل مورد نظر', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//لیست مشاغل را از دیتابیس دریافت می کند.
  getJobGroups() async {
    switch (workGroup) {
      case 'ساخت و ساز':
        {
          parentnumber = 1;
        }
        break;
      case 'تاسیسات':
        {
          parentnumber = 2;
        }
        break;
      case 'کشاورزی':
        {
          parentnumber = 3;
        }
        break;
      case 'خدماتی':
        {
          parentnumber = 4;
        }
        break;
    }
    jobTitles.clear();
    job = '';
    List response = await dataBase.getJobs();
    for (int i = 0; i < response.length; i++) {
      jobTitles.add(response[i]['title']);
    }
    return response[0]['title'];
  }

//اینیشال کردن پرفرنسز ها و گرفتن اطلاعات هنگام ورود به صفحه
  sharedInitial() async {
    setState(() {
      workGroup = box.read('workGroupfilter') ?? '';
      job = box.read('selectedJobFilter') ?? '';
      job == ''
          ? workGroupDropDownEnabled = false
          : workGroupDropDownEnabled = true;
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    sharedInitial();
  }
}
