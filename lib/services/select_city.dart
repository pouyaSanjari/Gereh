import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/controllers/request_controller.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  final controller = Get.put(RequestController());
  AppDataBase appDataBase = AppDataBase();
  UiDesign uiDesign = UiDesign();
  final box = GetStorage();

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
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (controller.selectedCity.isEmpty ||
                controller.selectedCity.value == 'یک شهر انتخاب کنید.' ||
                controller.selectedCity.value == 'لطفا صبر کنید...') {
              Fluttertoast.showToast(msg: 'یک شهر انتخاب کنید.');
            } else {
              Get.back(result: controller.selectedCity.value);
            }
          },
          backgroundColor: uiDesign.secounadryColor(),
          child: const Icon(
            Icons.check_rounded,
            size: 35,
            color: Colors.white,
          ),
        ),
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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 15),
                const Icon(Iconsax.building_3),
                const SizedBox(width: 10),
                Obx(
                  () => Text(
                    controller.selectedCity.value,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => searchTEC.text.isEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
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
                            childrenPadding: const EdgeInsets.only(right: 20),
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
                            },
                            child: ListTile(
                              title: Text(searched[index]),
                            ),
                          );
                        },
                      ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: uiDesign.mainColor(),
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(uiDesign.mainColor())),
                onPressed: () {
                  controller.selectedCity.value = 'لطفا صبر کنید...';
                  getCityNameByLocation();
                },
                icon: const Icon(
                  Iconsax.location,
                  color: Colors.white,
                ),
                label: const Text(
                  "دریافت خودکار موقعیت مکانی",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
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
        items.add(InkWell(
          onTap: () {
            controller.selectedCity.value = controller.cities[i]['title'];
            controller.categoryError.value = '';
          },
          child: ListTile(
            title: Text(controller.cities[i]['title']),
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

  getCityNameByLocation() async {
    var currentLocation = await _determinePosition();
    var url = Uri.parse(
        'https://map.ir/fast-reverse?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}');
    var response = await http.get(url, headers: {
      "x-api-key":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A"
    });

    var json = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

    String city = json['city'].toString().trim();
    String county = json['county'].toString().trim();
    String state = json['province'].toString().trim();

    if (city.trim().isNotEmpty) {
      controller.selectedCity.value = city.trim();
      box.write('city', city.trim());
    } else if (county.trim().isNotEmpty) {
      controller.selectedCity.value = county.trim();
      box.write('city', county.trim());
    } else {
      controller.selectedCity.value = state.trim();
      box.write('city', state.trim());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    controller.selectedCity.value = 'یک شهر انتخاب کنید.';
    getCitiesList();
    super.initState();
  }
}
