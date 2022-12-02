import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/other/my_chip.dart';
import 'package:gereh/components/selectCategoryPage/select_category.dart';
import 'package:gereh/components/textFields/selectable.text.field.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/constants/my_text_styles.dart';
import 'package:gereh/components/filterPage/controller/filter_controller.dart';
import 'package:gereh/services/ui_design.dart';
import '../../textFields/text.field.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});
  final controller = Get.put(permanent: true, FilterController());
  @override
  Widget build(BuildContext context) {
    double elementsPadding = 30;
    double insideElementsPadding = 10;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign.cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  controller.checkAllFilters();
                  controller.searchMethod();
                  Navigator.pop(context, controller.searchQuery.value);
                },
                label: Row(
                  children: const [
                    Icon(Iconsax.filter),
                    SizedBox(width: 20),
                    Text(
                      'اعمال فیلتر',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () => controller.deleteAllFilters(),
                backgroundColor: MyColors.red,
                label: const Icon(Iconsax.trash),
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(FontAwesomeIcons.xmark)),
            title: Text(
              'فیلتر',
              style: MyTextStyles.titrTextStyle(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'جستجو در عناوین',
                          style: MyTextStyles.titleTextStyle(Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.deleteTitleFilter(),
                        child: const Icon(
                          Iconsax.close_circle,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  SizedBox(height: insideElementsPadding),
                  MyTextField(
                    height: 45,
                    textInputAction: TextInputAction.search,
                    icon: const Icon(Iconsax.search_normal),
                    labeltext: 'جستجو',
                    control: controller.titleTEC.value,
                  ),
                  SizedBox(height: elementsPadding),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'دسته بندی',
                          style: MyTextStyles.titleTextStyle(Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.deleteCategoryFilter(),
                        child: const Icon(
                          Iconsax.close_circle,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  SizedBox(height: insideElementsPadding),
                  MySelectableTextField(
                    control: controller.categoryTEC.value,
                    icon: const Icon(Iconsax.category_2),
                    labeltext: 'یک دسته بندی انتخاب کنید',
                    onClick: () {
                      Get.to(() => const SelectCategory())?.then(
                        (value) {
                          if (value != null) {
                            controller.categoryTEC.value.text = value;
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: elementsPadding),
                  Text(
                    'نوع آگهی',
                    style: MyTextStyles.titleTextStyle(Colors.black),
                  ),
                  Obx(
                    () => Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: 20,
                      children: [
                        MyChip(
                          val: controller.allAdvTypes.value,
                          text: 'همه',
                          onSelected: (value) {
                            controller.selectAllAdvTypes();
                          },
                        ),
                        MyChip(
                          val: controller.hireAdvType.value,
                          text: 'استخدام نیرو',
                          onSelected: (p0) => controller.selectHireAdvType(),
                        ),
                        MyChip(
                          val: controller.businessPromotionAdvType.value,
                          text: 'تبلیغ کسب و کار',
                          onSelected: (p0) =>
                              controller.selectBusinessPromotionAdvtype(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: insideElementsPadding),
                  Text(
                    'نوع همکاری',
                    style: MyTextStyles.titleTextStyle(Colors.black),
                  ),
                  Obx(
                    () => Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: 20,
                      children: [
                        MyChip(
                          disabled: controller.businessPromotionAdvType.value,
                          val: controller.allCooperationTypes.value,
                          text: 'همه',
                          onSelected: (value) {
                            controller.selectAllCooperationTypes();
                          },
                        ),
                        MyChip(
                          disabled: controller.businessPromotionAdvType.value,
                          val: controller.teleCooperationType.value,
                          text: 'دورکاری',
                          onSelected: (p0) =>
                              controller.selectTeleCooperationType(),
                        ),
                        MyChip(
                          disabled: controller.businessPromotionAdvType.value,
                          val: controller.inPlaceCooperationtype.value,
                          text: 'حضوری',
                          onSelected: (p0) =>
                              controller.selectInPlaceCooperationType(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: insideElementsPadding),
                  Text(
                    'شیوه پرداخت',
                    style: MyTextStyles.titleTextStyle(Colors.black),
                  ),
                  Obx(
                    () => Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: 20,
                      children: [
                        MyChip(
                          disabled: controller.businessPromotionAdvType.value,
                          val: controller.allMethods.value,
                          text: 'همه',
                          onSelected: (v) => controller.selectAllPayMethods(),
                        ),
                        MyChip(
                          disabled: controller.businessPromotionAdvType.value,
                          val: controller.daily.value,
                          text: 'روزمزد',
                          onSelected: (v) => controller.selectDailyPayMethod(),
                        ),
                        MyChip(
                          disabled: controller.businessPromotionAdvType.value,
                          val: controller.monthly.value,
                          text: 'ماهیانه',
                          onSelected: (v) =>
                              controller.selectMonthlyPayMethod(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: elementsPadding),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'دستمزد',
                          style: MyTextStyles.titleTextStyle(Colors.black),
                        ),
                      ),
                      Obx(
                        () => InkWell(
                          onTap: () => controller.deletePriceFilter(),
                          child: Icon(
                            Iconsax.close_circle,
                            color:
                                listEquals(controller.sliderValues, [0.0, 1.0])
                                    ? Colors.grey
                                    : MyColors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  Obx(
                    () => MultiSlider(
                      divisions: 200,
                      color: MyColors.blueGrey,
                      values: controller.sliderValues,
                      onChanged: controller.businessPromotionAdvType.value
                          ? null
                          : (value) {
                              controller.sliderValues.value = value;
                            },
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "تا: ${MyStrings.digi(
                              (controller.sliderValues[1] *
                                      controller.sliderValuesMultiplyer.value)
                                  .round()
                                  .toString(),
                            )}",
                          ),
                          Text(
                            "از: ${MyStrings.digi(
                              (controller.sliderValues[0] *
                                      controller.sliderValuesMultiplyer.value)
                                  .round()
                                  .toString(),
                            )}",
                          )
                        ],
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
}
