import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gereh/components/switchs/my_switch.dart';
import 'package:gereh/pages/sabt_agahi/5_otherFeautures/controller/other_feautures_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:gereh/components/other/animated_widget.dart';
import 'package:gereh/components/buttons/my_button.dart';
import 'package:gereh/pages/sabt_agahi/5_otherFeautures/view/map.dart';
import 'package:gereh/services/ui_design.dart';
import '../../../../components/errorPage/error_page.dart';
import '../../../../constants/my_colors.dart';
import '../../../../services/database.dart';

class OtherFutures extends GetView<OtherFeauturesController> {
  const OtherFutures({super.key});

  @override
  Widget build(BuildContext context) {
    String address = '';
    List snap = [];
    final database = AppDataBase();
    List<String> uploadedImages = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'سایر ویژگی ها',
            style: TextStyle(fontFamily: 'titr', fontSize: 30),
          ),
        ),
        const Divider(
            height: 30, color: Colors.black, indent: 50, endIndent: 50),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Iconsax.gallery),
              const SizedBox(width: 15),
              Text(
                'تصاویر آگهی',
                style: UiDesign.titleTextStyle(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => FutureBuilder(
                  future: database.paidFeautersImages(uploadedImages),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Lottie.asset('assets/lottie/loading.json',
                            width: 80, height: 80),
                      );
                    }
                    if (snapshot.hasData) {
                      snap = snapshot.data;
                    }
                    if (snapshot.data == null) {
                      return ErrorPage(onReferesh: () {
                        database.paidFeautersImages(uploadedImages);
                      });
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, int index) {
                        if (snap.length < index + 1) {
                          return InkResponse(
                            onTap: () => database.uploadImage(),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Iconsax.gallery_add,
                                  size: 35,
                                )),
                          );
                        } else {
                          return InkResponse(
                            onLongPress: () {
                              //حذف تصویر انتخاب شده
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Center(
                                      child: Text('تصویر حذف شود؟')),
                                  content: const Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      'آیا مطمئن هستید که میخواهید این تصویر را حذف کنید؟ در صورت تایید امکان بازیابی تصویر وجود ندارد.',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await database
                                              .deleteImage(snap[index]['id']);

                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "حذف",
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("لغو"))
                                  ],
                                ),
                              );
                            },
                            onTap: () {
                              showDialog(
                                useSafeArea: false,
                                context: context,
                                builder: (context) => Dialog(
                                  insetPadding: const EdgeInsets.all(0),
                                  backgroundColor: Colors.black,
                                  child: Container(
                                    color: MyColors.black,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: CachedNetworkImage(
                                            imageUrl: snap[index]['image'],
                                          ),
                                        ),
                                        IconButton(
                                            splashColor: Colors.white,
                                            icon: const Icon(Icons.arrow_back,
                                                color: Colors.white, size: 30),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                        const SizedBox(height: 20)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: snap[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => listTiles(
            onTap: () =>
                controller.locationBool.value = !controller.locationBool.value,
            leading: Iconsax.map_1,
            iconColor: Colors.black,
            title: 'نقشه (غیر رایگان)',
            sub: 'آگهی شما بر روی نقشه نمایش داده خواهد شد',
            swich: MySwitch(
              val: controller.locationBool.value,
              onChange: (value) {
                controller.locationBool.value = value;
              },
            ),
          ),
        ),
        Obx(
          () => MyAnimatedWidget(
            height: controller.selectedLat.value.isEqual(0) ? 50 : 250,
            state: controller.locationBool.value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: controller.selectedLat.value.isEqual(0)
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: MyButton(
                        fillColor: MyColors.blueGrey,
                        child: const Text(
                          'انتخاب موقعیت از روی نقشه',
                          style: TextStyle(color: Colors.white),
                        ),
                        onClick: () => Get.to(() => const MapPage())
                            ?.then((value) => address = value[0]),
                      ),
                    )
                  : Column(
                      children: [
                        Center(
                          child: InkResponse(
                            onTap: () => Get.to(() => const MapPage()),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl:
                                      'https://api.neshan.org/v2/static?key=service.3701bff2e5814681af87132d10abe63a&type=dreamy&zoom=15&center=${controller.selectedLat.value},${controller.selectedLon.value}&width=700&height=400&marker=red'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(controller.address.value),
                        )
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => listTiles(
            onTap: () =>
                controller.resumeBool.value = !controller.resumeBool.value,
            leading: Iconsax.paperclip,
            iconColor:
                controller.resumeBool.value ? MyColors.red : Colors.black,
            title: 'دریافت رزومه (غیر رایگان)',
            sub: 'می توانید از کارجویان فایل رزومه آنها را بخواهید.',
            swich: MySwitch(
              val: controller.resumeBool.value,
              onChange: (value) {
                controller.resumeBool.value = value;
              },
            ),
          ),
        )
      ],
    );
  }

  ListTile listTiles(
      {required void Function()? onTap,
      required IconData leading,
      required Color iconColor,
      required String title,
      required Widget swich,
      required String sub}) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 5,
      leading: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(leading, color: iconColor),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          swich,
          const SizedBox(width: 10),
        ],
      ),
      subtitle: Text(sub),
      contentPadding: EdgeInsets.zero,
    );
  }
}
