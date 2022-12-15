import 'package:flutter/material.dart';
import 'package:gereh/pages/jobsList/controller/select_city_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/buttons/my_button.dart';
import 'package:gereh/components/textFields/text.field.dart';
import 'package:gereh/constants/my_colors.dart';

class SelectCity extends StatelessWidget {
  SelectCity({super.key});
  final controller = Get.put(SelectCityController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Iconsax.arrow_right_3,
              color: Colors.black,
            ),
          ),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: MyTextField(
              labeltext: 'جستجو',
              control: controller.searchTEC.value,
              icon: const Icon(Iconsax.search_normal),
              onChange: (value) {
                controller.updateSearchValue(value);
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 15),
                const Icon(Iconsax.building_3),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => Row(
                      children: [
                        Text(
                          controller.city.value,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                MyButton(
                  height: 30,
                  fillColor: MyColors.blue,
                  onClick: () async {
                    await controller.getCityNameByLocation();
                    Get.back(result: controller.city.value);
                  },
                  child: Row(children: const [
                    Icon(
                      Iconsax.location,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'دریافت خودکار ',
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                ),
                const SizedBox(width: 5),
              ],
            ),
            Obx(
              () => Expanded(
                child: controller.searchValue.isEmpty
                    ? Obx(
                        () => ListView.builder(
                          itemCount: controller.cities
                              .where((p0) => p0['parent'] == '0')
                              .toList()
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            var title = controller.cities
                                // داخل دیتابیس شهر ها با پرنت صفر ذخیره شدن
                                .where((item) => item['parent'] == '0')
                                .toList();
                            List<Widget> item = controller
                                .citiesList(controller.ostan[index]['id']);
                            return ExpansionTile(
                              title: Text(title[index]['title']),
                              childrenPadding: const EdgeInsets.only(right: 20),
                              children: item,
                            );
                          },
                        ),
                      )
                    : Obx(
                        () => ListView.builder(
                          itemCount: controller.searched.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Get.back(result: controller.searched[index]);
                              },
                              child: ListTile(
                                title: Text(controller.searched[index]),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
