import 'package:flutter/material.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/components/pages/select.category.dart';
import 'package:sarkargar/components/textFields/selectable.text.field.dart';
import 'package:sarkargar/components/switchs/toggle.switch.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/constants/my_strings.dart';
import 'package:sarkargar/controllers/filter.controller.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/services/ui_design.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(permanent: true, FilterController());
    final jobsListController = Get.find<JobsListController>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(5),
          titlePadding: const EdgeInsets.symmetric(vertical: 10),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttons(
                  text: 'اعمال فیلتر',
                  color: MyColors.blueGrey,
                  onPressed: () async {
                    controller.setFilter();
                  },
                ),
                const SizedBox(width: 5),
                Obx(
                  () => buttons(
                    text: jobsListController.searchedList.isNotEmpty
                        ? 'حذف فیلتر ها'
                        : 'بازگشت',
                    onPressed: () {
                      controller.deleteFilter();
                    },
                  ),
                )
              ],
            ),
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
                      maintainAnimation: true,
                      maintainState: true,
                      visible: controller.adType.value == 0 ? true : false,
                      child: Center(
                        child: Obx(
                          () => MyToggleSwitch(
                            initialLableIndex: controller.hiringType.value,
                            labels: const ['روزمزد', 'ماهیانه'],
                            totalSwitch: 2,
                            onToggle: (value) {
                              controller.resetMultiSliderWidget(value: value!);
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
                          labels: const ['آقا', 'خانم', 'هر دو'],
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
                      onPress:
                          controller.categoryTEController.value.text.isEmpty
                              ? null
                              : () {
                                  controller.categoryTEController.value.clear();
                                },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MySelectableTextField(
                      icon: const Icon(Iconsax.category_2),
                      control: controller.categoryTEController.value,
                      labeltext: 'انتخاب دسته بندی',
                      onClick: () async {
                        await Get.to(const SelectCategory())?.then((value) {
                          controller.categoryTEController.value.text = value;
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
                          controller.convertNumber(value: value);
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
                                  'تا: ${MyStrings.digi(controller.maxPrice.value.toString())}',
                                  style: const TextStyle(fontSize: 12),
                                )),
                            Obx(
                              () => Text(
                                'از: ${MyStrings.digi(controller.minPrice.value.toString())}',
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
            minimumSize: const MaterialStatePropertyAll<Size>(Size(110, 40)),
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
            style: UiDesign.titleTextStyle(),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              color: MyColors.red,
              onPressed: onPress,
              icon: const Icon(Iconsax.trash))
        ],
      ),
    );
  }
}
