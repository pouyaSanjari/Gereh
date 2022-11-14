import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/switchs/toggle.switch.dart';
import 'package:gereh/components/pages/select_category.dart';
import 'package:gereh/components/textFields/selectable.text.field.dart';
import 'package:gereh/components/textFields/text.field.dart';
import 'package:gereh/constants/colors.dart';
import 'package:gereh/components/pages/select_city.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:gereh/services/database.dart';
import '../../controllers/request_controller.dart';

final dataBase = AppDataBase();

class TitlePage extends GetView<RequestController> {
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

          const SizedBox(height: 20),

          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.images.isEmpty)
                  InkWell(
                    onTap: () => dataBase.uploadImage(),
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Iconsax.gallery_add,
                        size: 35,
                        color: Colors.black87,
                      ),
                    ),
                  )
                else
                  Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 85,
                        height: 85,
                        child: CachedNetworkImage(
                            imageUrl: controller.images[0], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' تصویر شاخص', style: UiDesign.titleTextStyle()),
                      Text('   این تصور در لیست آگهی ها نمایش داده خواهد شد.',
                          style: UiDesign.descriptionsTextStyle()),
                      Text(
                          '   (با نگه داشتن روی تصویر می توانید آن را حذف کنید)',
                          style: UiDesign.descriptionsTextStyle())
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('|عنوان آگهی', style: UiDesign.titleTextStyle()),
          Text('   توضیح مختصری از آگهی خود را وارد کنید.',
              style: UiDesign.descriptionsTextStyle()),
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
          Text('|دسته بندی ', style: UiDesign.titleTextStyle()),
          Text('   انتخاب دسته بندی صحیح بازدید آگهی شما را افزایش خواهد داد.',
              style: UiDesign.descriptionsTextStyle()),
          const SizedBox(height: 5),

          Obx(
            () => MySelectableTextField(
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
          Text('|شهر محل آگهی ', style: UiDesign.titleTextStyle()),
          Text('   آگهی شما در لیست آگهی های کدام شهر نمایش داده شود؟',
              style: UiDesign.descriptionsTextStyle()),
          const SizedBox(height: 5),

          Obx(
            () => MySelectableTextField(
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

          const SizedBox(height: 20),
          Text('|توضیحات', style: UiDesign.titleTextStyle()),
          Text(
            '   سعی کنید شرح کاملی از درخواست خود را وارد کنید تا هیچ ابهامی باقی نماند، این مورد می تواند شانس استخدام نیرو و جذب مشتری را افزایش دهد.',
            style: UiDesign.descriptionsTextStyle(),
          ),
          const SizedBox(height: 5),
          Obx(
            () => MyTextField(
                error: controller.descriptionsError.isEmpty
                    ? null
                    : controller.descriptionsError.value,
                textInputType: TextInputType.multiline,
                control: controller.descriptionsTEC.value,
                minLine: 1,
                maxLine: 20,
                icon: const Icon(Iconsax.textalign_justifyright5,
                    color: MyColors.black),
                length: 1000,
                hint: 'توضیحات کامل آگهی خود را اینجا وارد کنید',
                onChange: (value) {
                  controller.descriptionsError.value = '';
                },
                labeltext: 'توضیحات آگهی '),
          ),
        ],
      ),
    );
  }
}
