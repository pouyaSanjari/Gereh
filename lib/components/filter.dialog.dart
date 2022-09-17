import 'package:flutter/material.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/components/select.category.dart';
import 'package:sarkargar/components/selectable.text.field.dart';
import 'package:sarkargar/components/toggle.switch.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/controllers/filter.controller.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(permanent: true, FilterController());
    final jobsListController = Get.find<JobsListController>();
    return WillPopScope(
      onWillPop: () async => true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.grey[50],
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(5),
          titlePadding: const EdgeInsets.symmetric(vertical: 10),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            buttons(
              text: 'اعمال فیلتر',
              color: MyColors.blueGrey,
              onPressed: () {
                jobsListController.search.clear();
                // عدد 3 به معنای غیر فعال بودن است
                if (controller.adType.value != 3) {
                  jobsListController.search
                      .addAll({'adtype': controller.adType.value.toString()});
                }
                if (controller.hiringType.value != 3) {
                  jobsListController.search.addAll(
                      {'hiringtype': controller.hiringType.value.toString()});
                }
                // if (controller.gender.value != 3) {
                //   jobsListController.search
                //       .addAll({'gender': controller.gender.value.toString()});
                // }
                if (controller.categoryController.value.text != '') {
                  jobsListController.search.addAll(
                      {'category': controller.categoryController.value.text});
                }
                // jobsListController.searchMap();
                // Get.back();
                print(jobsListController.search.values);
              },
            ),
            buttons(text: 'حذف فیلتر ها')
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Iconsax.filter),
              SizedBox(width: 10),
              Text('اعمال فیلتر'),
            ],
          ),
          content: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ##################################س####################################################
                  Obx(
                    () => row(
                      title: 'نوع آگهی',
                      onPress: controller.adType.value == 3
                          ? null
                          : () => controller.adType.value = 3,
                    ),
                  ),
                  Center(
                    child: Obx(
                      () => MyToggleSwitch(
                        initialLableIndex: controller.adType.value,
                        labels: const ['استخدام', 'تبلیغ'],
                        totalSwitch: 2,
                        onToggle: (value) {
                          controller.adType.value = value!;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                        visible: controller.adType.value == 0 ? true : false,
                        child: const SizedBox(height: 10)),
                  ),
                  // ######################################################################################
                  Obx(
                    () => Visibility(
                      visible: controller.adType.value == 0 ? true : false,
                      child: row(
                        title: 'نوع استخدام',
                        onPress: controller.hiringType.value == 3
                            ? null
                            : () => controller.hiringType.value = 3,
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.adType.value == 0 ? true : false,
                      child: Center(
                        child: Obx(
                          () => MyToggleSwitch(
                            initialLableIndex: controller.hiringType.value,
                            labels: const ['روزمزد', 'ماهیانه'],
                            totalSwitch: 2,
                            onToggle: (value) {
                              controller.hiringType.value = value!;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ######################################################################################
                  Obx(
                    () => Visibility(
                      visible: controller.adType.value == 0 ? true : false,
                      child: row(
                        title: 'جنسیت',
                        onPress: controller.gender.value == 3
                            ? null
                            : () => controller.gender.value = 3,
                      ),
                    ),
                  ),
                  Center(
                    child: Obx(
                      () => Visibility(
                        visible: controller.adType.value == 0 ? true : false,
                        child: MyToggleSwitch(
                          minWidth: 98,
                          initialLableIndex: controller.gender.value,
                          labels: const ['خانم', 'آقا', 'هردو'],
                          totalSwitch: 3,
                          onToggle: (value) => controller.gender.value = value!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ######################################################################################
                  Obx(
                    () => row(
                      title: 'دسته بندی',
                      onPress: controller.categoryController.value.text.isEmpty
                          ? null
                          : () {
                              controller.categoryController.value.clear();
                            },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MySelectableTextField(
                      icon: const Icon(Iconsax.category_2),
                      control: controller.categoryController.value,
                      labeltext: 'انتخاب دسته بندی',
                      onClick: () async {
                        await Get.to(const SelectCategory())?.then((value) {
                          print(value);
                          controller.categoryController.value.text = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ######################################################################################
                  Obx(
                    () => Visibility(
                      visible: controller.adType.value == 0 ? true : false,
                      child: row(
                        title: 'دستمزد',
                        onPress: () {
                          controller.ghimat[0] = 0.0;
                          controller.ghimat[1] = 1.0;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.adType.value == 0 ? true : false,
                      child: MultiSlider(
                        color: MyColors.blueGrey,
                        horizontalPadding: 30,
                        height: 40,
                        values: controller.ghimat,
                        divisions: 100,
                        onChanged: (value) {
                          // مقداری بین 0 تا 1 بر میگردونه پس ضربش می کنیم تا به عدد دلخواه برسیم
                          controller.ghimat.value = value;
                          if (controller.hiringType.value == 0) {
                            controller.minPrice.value =
                                (value[0] * 30000000).round();
                          } else {
                            controller.minPrice.value =
                                (value[0] * 1000000).round();
                          }
                          if (controller.hiringType.value == 0) {
                            controller.maxPrice.value =
                                (value[1] * 30000000).round();
                          } else {
                            controller.maxPrice.value =
                                (value[1] * 1000000).round();
                          }
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.adType.value == 0 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // درصورتی که نوع استخدام ماهیانه باشه مقدار اسلایدر رو در عدد بزرگتری ضرب می کنیم
                            Obx(() => Text(
                                  'تا: ${UiDesign().digi((controller.ghimat[1] * (controller.hiringType.value == 0 ? 30000000 : 1000000)).round().toString())}',
                                  style: const TextStyle(fontSize: 12),
                                )),
                            Obx(
                              () => Text(
                                'از: ${UiDesign().digi((controller.ghimat[0] * (controller.hiringType.value == 0 ? 30000000 : 1000000)).round().toString())}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextButton buttons(
      {Color? color, void Function()? onPressed, required String text}) {
    return TextButton(
        style: ButtonStyle(
            minimumSize: const MaterialStatePropertyAll<Size>(Size(150, 40)),
            backgroundColor:
                MaterialStatePropertyAll<Color>(color ?? MyColors.red)),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)));
  }

  Padding row({String title = 'عنوان', void Function()? onPress}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: UiDesign().titleTextStyle(),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: onPress,
              icon: const Icon(Iconsax.trash))
        ],
      ),
    );
  }
}
