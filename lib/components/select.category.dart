import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/services/ui_design.dart';

import '../controllers/request_controller.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final controller = Get.put(RequestController());

  double cardheight = 200;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('انتخاب دسته بندی'),
          elevation: 0,
        ),
        body: Obx(
          () => controller.jobGroups.isEmpty
              ? Center(
                  child: Lottie.asset('assets/lottie/loading.json',
                      width: 80, height: 80),
                )
              : ListView.separated(
                  itemCount: controller.jobGroups.length,
                  itemBuilder: (BuildContext context, int index) {
                    int icon = int.parse(controller.jobGroups[index]['icon']);
                    String title = controller.jobGroups[index]['title'];
                    return ExpansionTile(
                      leading: Icon(IconData(icon,
                          fontFamily: 'iconsax', fontPackage: 'iconsax')),
                      title: Text(title, style: UiDesign().titleTextStyle()),
                      children:
                          selectJob('${controller.jobGroups[index]['groupid']}')
                              .toList(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                    );
                  },
                ),
        ),
      ),
    );
  }

  List<Widget> selectJob(String jobParent) {
    List selected = controller.jobs
        .where((element) => element['parent'] == jobParent)
        .toList();

    List<Widget> items = [];
    for (var i = 0; i < selected.length; i++) {
      items.add(InkWell(
        onTap: () {
          controller.categoryError.value = '';
          Get.back(result: selected[i]['title']);
        },
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(selected[i]['title']),
          ),
        ),
      ));
    }

    return items;
  }

  @override
  void initState() {
    controller.getAllJobs();
    super.initState();
  }
}
