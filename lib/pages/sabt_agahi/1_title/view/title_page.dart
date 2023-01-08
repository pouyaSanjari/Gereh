import 'package:flutter/material.dart';
import 'package:gereh/pages/sabt_agahi/1_title/controller/title_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/switchs/my_toggle_switch.dart';
import 'package:gereh/components/selectCategoryPage/select_category.dart';
import 'package:gereh/components/textFields/selectable_text_field.dart';
import 'package:gereh/components/textFields/my_text_field.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/pages/jobsList/view/select_city.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:gereh/services/database.dart';

final dataBase = AppDataBase();

class TitlePage extends GetView<TitleController> {
  const TitlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child:
                  Text('|   نوع آگهی   |', style: UiDesign.titleTextStyle())),
          const SizedBox(height: 5),
          Center(
            child: Obx(
              () {
                return MyToggleSwitch(
                  initialLableIndex: controller.adType.value,
                  labels: const ['استخدام نیرو', 'تبلیغ کسب و کار'],
                  totalSwitch: 2,
                  onToggle: (index) => controller.adType.value = index ?? 0,
                );
              },
            ),
          ),

          const SizedBox(height: 50),
          Text('عنوان آگهی', style: UiDesign.titleTextStyle()),

          const SizedBox(height: 5),

          //تکست فیلد وارد کردن عنوان آگهی
          Obx(
            () => MyTextField(
              error: controller.titleError.value.isEmpty
                  ? null
                  : controller.titleError.value,
              labeltext: 'عنوان',
              icon: const Icon(Iconsax.subtitle, color: MyColors.black),
              control: controller.titleTEC.value,
              hint: 'عنوان درخواست خود را وارد کنید',
              onChange: (value) {
                controller.titleError.value = '';
              },
            ),
          ),
          const SizedBox(height: 20),
          Text('دسته بندی ', style: UiDesign.titleTextStyle()),
          Text('   انتخاب دسته بندی صحیح بازدید آگهی شما را افزایش خواهد داد.',
              style: UiDesign.descriptionsTextStyle()),
          const SizedBox(height: 5),

          Obx(
            () => SelectableTextField(
              error: controller.categoryError.isEmpty
                  ? null
                  : controller.categoryError.value,
              control: controller.categoryTEC.value,
              icon: const Icon(Iconsax.category_2, color: MyColors.black),
              labeltext: 'یک دسته بندی انتخاب کنید',
              onClick: () {
                Get.to(() => const SelectCategory())?.then((value) {
                  controller.categoryTEC.value.text = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),
          Text('شهر محل آگهی ', style: UiDesign.titleTextStyle()),
          Text('   آگهی شما در لیست آگهی های کدام شهر نمایش داده شود؟',
              style: UiDesign.descriptionsTextStyle()),
          const SizedBox(height: 5),

          Obx(
            () => SelectableTextField(
                error: controller.cityError.isEmpty
                    ? null
                    : controller.cityError.value,
                control: controller.cityTEC.value,
                icon: const Icon(Iconsax.building_3, color: MyColors.black),
                labeltext: 'شهر خود را انتخاب کنید.',
                onClick: () {
                  Get.to(() => SelectCity())?.then((value) {
                    if (value != null) {
                      controller.cityError.value = '';
                      return controller.cityTEC.value.text = value;
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }
}
