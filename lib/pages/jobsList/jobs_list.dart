import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:gereh/components/pages/error_page.dart';
import 'package:gereh/components/listView/jobs_list_viewer.dart';
import 'package:gereh/constants/colors.dart';
import 'package:gereh/controllers/jobs_list_controller.dart';
import 'package:gereh/components/pages/filter_page.dart';
import 'package:gereh/components/pages/select_city.dart';
import 'package:gereh/services/ui_design.dart';

final bucket = PageStorageBucket();

class JobsListTest extends StatelessWidget {
  JobsListTest({super.key});

  final controller = Get.put(permanent: true, JobsListController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign.cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: appBar(),
          body: SafeArea(
              child: Obx(
            () => RefreshIndicator(
              backgroundColor: MyColors.notWhite,
              onRefresh: () async {
                await controller.getAds();
              },
              child: controller.loading.value
                  ? Center(
                      child: Lottie.asset('assets/lottie/loading.json',
                          width: 80, height: 80),
                    )
                  : controller.hasError.value
                      ? ErrorPage(referesh: () {
                          controller.getAds();
                        })
                      : PageStorage(
                          bucket: bucket,
                          child: JobsListViewer(jobsList: controller.jobsList),
                        ),
            ),
          )),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 0,
      actions: [
        InkWell(
          onTap: () => Get.to(() => SelectCity())?.then((value) async {
            controller.city.value = value;
            await box.write('city', value);
            controller.getAds();
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                const Icon(
                  Iconsax.location,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Obx(
                  () => Text(controller.city.value,
                      style: UiDesign.descriptionsTextStyle()),
                ),
              ],
            ),
          ),
        )
      ],
      title: OpenContainer(
        onClosed: (data) {
          if (data != null) {
            controller.query.value = data.toString();
            controller.getAds();
          }
        },
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        closedColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (BuildContext context,
            void Function({Object? returnValue}) action) {
          return FilterPage();
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: () => action.call(),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(children: const [
                    SizedBox(width: 10),
                    Icon(
                      Iconsax.search_normal,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'جستجو',
                      style: TextStyle(color: Colors.grey),
                    )
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
