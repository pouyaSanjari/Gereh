import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/generalPages/main_page.dart';
import 'package:sarkargar/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetLocation extends StatefulWidget {
  final bool isFirstTime;
  GetLocation({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final controller = Get.put(JobsListController());
  final box = GetStorage();
  UiDesign uiDesign = UiDesign();
  AppDataBase database = AppDataBase();

  @override
  Widget build(BuildContext context) {
    // controller.initialData();

    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (widget.isFirstTime == true) {
                  controller.city.isEmpty
                      ? Fluttertoast.showToast(msg: 'لطفا یک شهر انتخاب کنید')
                      : Get.to(const MainPage());
                } else {
                  controller.city.isEmpty
                      ? Fluttertoast.showToast(msg: 'لطفا یک شهر انتخاب کنید')
                      : Get.back();
                }
              },
              backgroundColor: Colors.green,
              child: const Icon(Iconsax.clipboard_export, size: 25),
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.grey[50],
              centerTitle: true,
              title: const Text('انتخاب موقعیت مکانی'),
              actions: [
                widget.isFirstTime
                    ? Container()
                    : IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: Colors.black,
                        ))
              ],
            ),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: SvgPicture.asset('assets/SVG/map.svg',
                        height: 200, width: 200),
                  ),
                  const Text(
                    'انتخاب دستی موقعیت مکانی:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => uiDesign.dropdownSearch(
                        selectedItem: controller.provience.value == ''
                            ? 'استان'
                            : controller.provience.value,
                        onChange: (value) {
                          //وقتی مقدار استان تغییر میکند
                          //اول مقدار شهر خالی میشود
                          controller.city.value = '';
                          box.write('city', '');
                          //مقدار استان ذخیره میشود
                          controller.provience.value = value.toString();
                          box.write('provience', value.toString());
                          //شهر های آن استان را دریافت و ذخیره میکند
                          getCities(value.toString());
                          controller.cityNamesEnabled.value = true;
                          box.write('cityNamesEnabled', true);
                        },
                        items: controller.provienceList),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => uiDesign.dropdownSearch(
                        enabled: controller.cityNamesEnabled.value,
                        selectedItem: controller.city.value == ''
                            ? 'شهرستان'
                            : controller.city.value,
                        onChange: (value) {
                          controller.city.value = value.toString();
                          box.write('city', value.toString());
                        },
                        items: controller.citiesList),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue)),
                        onPressed: () {
                          getCityNameByLocation();
                        },
                        icon: const Icon(
                          Iconsax.location,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "دریافت خودکار موقعیت مکانی",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Center(
                        child: Text(
                            controller.city.isEmpty
                                ? 'یک شهر انتخاب کنید'
                                : 'موقعیت انتخاب شده شما: ${controller.city.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                  )
                ],
              ),
            ))),
      ),
    );
  }

  //این متد استانهای کشور را از دیتابیس دریافت میکند
  getProvinces() async {
    var response = await database.getProvinces();

    if (controller.provienceList.isEmpty) {
      for (int i = 0; i < 31; i++) {
        controller.provienceList.add(response[i]['title']);
      }
    }
  }

  //این متد شهر های استان انتخاب شده را بر می گرداند
  getCities(String ostan) async {
    List response = await database.getCitis(ostan);
    controller.citiesList.clear();
    for (int i = 0; i < response.length; i++) {
      controller.citiesList.add(response[i]['title']);
    }
  }

  //این متد مقدار lat و lon موقعیت کاربر را دریافت میکند
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

  //این متد با توجه به موقعیت کاربر نام شهر کاربر را بر میگرداند
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
      controller.city.value = city.trim();
      box.write('city', city.trim());
    } else if (county.trim().isNotEmpty) {
      controller.city.value = county.trim();
      box.write('city', county.trim());
    } else {
      controller.city.value = state.trim();
      box.write('city', state.trim());
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    controller.initialData();
    getProvinces();
    controller.provience.isNotEmpty
        ? getCities(controller.provience.value)
        : null;
  }
}
