import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/controllers/request_controller.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/services/uiDesign.dart';

class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  final controller = Get.put(RequestController());
  AppDataBase appDataBase = AppDataBase();
  UiDesign uiDesign = UiDesign();

  TextEditingController searchTEC = TextEditingController();

  List ostan = [];
  List<Widget> item = [];
  List title = [];
  List<String> searched = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: 0,
            elevation: 0,
            centerTitle: true,
            title: uiDesign.cTextField(
              labeltext: 'جستجو',
              control: searchTEC,
              icon: const Icon(Iconsax.search_normal),
              onChange: (value) {
                setState(() {
                  search(value);
                });
              },
            ),
          ),
          body: Obx(
            () => searchTEC.text.isEmpty
                ? ListView.builder(
                    itemCount: controller.cities
                        .where((p0) => p0['parent'] == '0')
                        .toList()
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      title = controller.cities
                          .where((item) => item['parent'] == '0')
                          .toList();
                      item = cities(ostan[index]['id']);
                      return ExpansionTile(
                        title: Text(title[index]['title']),
                        childrenPadding: EdgeInsets.zero,
                        children: item,
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: searched.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          controller.selectedCity.value = searched[index];
                          controller.categoryError.value = '';
                          Get.back();
                        },
                        child: ListTile(
                          title: Text(searched[index]),
                        ),
                      );
                    },
                  ),
          )),
    );
  }

  getCitiesList() async {
    if (controller.cities.isEmpty) {
      controller.cities.value = await appDataBase.getCitiesAndProvinces();
    }
    for (var i = 0; i < controller.cities.length; i++) {
      if (controller.cities[i]['parent'] == '0') {
        ostan.add(controller.cities[i]);
      }
    }
  }

  List<Widget> cities(String parent) {
    List<Widget> items = [];
    for (var i = 0; i < controller.cities.length; i++) {
      if (controller.cities[i]['parent'] == parent) {
        items.add(ListTile(
          title: InkWell(
            onTap: () {
              controller.selectedCity.value = controller.cities[i]['title'];
              controller.categoryError.value = '';
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text(controller.cities[i]['title']),
            ),
          ),
        ));
      }
    }

    return items;
  }

  search(String value) {
    searched.clear();
    for (var i = 0; i < controller.cities.length; i++) {
      if (controller.cities[i]['title'].toString().contains(value) &&
          controller.cities[i]['parent'] != '0') {
        searched.add(controller.cities[i]['title']);
      }
    }
  }

  @override
  void initState() {
    getCitiesList();
    super.initState();
  }
}
