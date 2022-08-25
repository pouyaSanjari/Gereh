import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late SharedPreferences sharedPreferences;
  final controller = Get.put(JobsListController());

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
              backgroundColor: Colors.grey[50],
              centerTitle: true,
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
                  uiDesign.dropdownSearch(
                    items: const [
                      'ساخت و ساز',
                      'کشاورزی',
                      'تاسیسات',
                      'خدماتی',
                      'سایر'
                    ],
                    selectedItem: workGroup == ''
                        ? 'یکی از گروه های شغلی را انتخاب کنید'
                        : workGroup,
                    onChange: (value) {
                      if (value != null) {
                        setState(() {
                          sharedPreferences.setString('workGroupfilter', value);
                          workGroupDropDownEnabled = true;
                          workGroup = value.toString();
                          getJobGroups();
                        });
                      } else {
                        setState(() {
                          workGroupDropDownEnabled = false;
                        });
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('شغل مورد نظر', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 10),
                  uiDesign.dropdownSearch(
                    selectedItem:
                        job == '' ? 'شغل مورد نظر خود را انتخاب کنید' : job,
                    onChange: (value) {
                      sharedPreferences.setString('selectedJobFilter', value!);
                      job = value.toString();
                    },
                    items: jobTitles,
                    enabled: workGroupDropDownEnabled,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.redAccent,
                        onPressed: () {
                          setState(() {
                            job = '';
                            workGroup = '';
                            sharedPreferences.setString('workGroupfilter', '');
                            sharedPreferences.setString(
                                'selectedJobFilter', '');
                            workGroupDropDownEnabled = false;
                          });
                        },
                        child: const Icon(Iconsax.clipboard_close, size: 30),
                      ),
                      FloatingActionButton(
                        heroTag: '',
                        backgroundColor: Colors.green,
                        onPressed: () {
                          // printInfo(info: controller.jobsList.value.toString());
                          var filterdList =
                              controller.jobsList.where((element) {
                            return element['category'] == job;
                          }).toList();
                          job.isEmpty
                              ? Get.back()
                              : Get.back(result: filterdList);
                        },
                        child: const Icon(Iconsax.clipboard_export, size: 30),
                      )
                    ],
                  )
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
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      workGroup = sharedPreferences.getString('workGroupfilter') ?? '';
      job = sharedPreferences.getString('selectedJobFilter') ?? '';
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
