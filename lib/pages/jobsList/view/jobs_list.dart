import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gereh/components/filterPage/controller/filter_controller.dart';
import 'package:gereh/constants/my_text_styles.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:gereh/components/errorPage/error_page.dart';
import 'package:gereh/components/jobsListViewer/jobs_list_viewer.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/pages/jobsList/controller/jobs_list_controller.dart';
import 'package:gereh/components/filterPage/view/filter_page.dart';
import 'package:gereh/pages/jobsList/view/select_city.dart';
import 'package:gereh/services/ui_design.dart';

final bucket = PageStorageBucket();

class JobsListTest extends StatelessWidget {
  JobsListTest({super.key});

  final controller = Get.put(permanent: true, JobsListController());
  final box = GetStorage();
  final filController = Get.put(FilterController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign.cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(
          () => Scaffold(
            appBar: AppBar(
              excludeHeaderSemantics: true,
              scrolledUnderElevation: 0,
              bottom:
                  filController.searchChips.isEmpty ? null : const _ChipsBar(),
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
                openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
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
            ),
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
                        ? ErrorPage(onReferesh: () {
                            controller.getAds();
                          })
                        : controller.thereIsNoAd.value
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Icon(
                                    Iconsax.folder_cross,
                                    size: 150,
                                    color: MyColors.red.withOpacity(0.8),
                                  ),
                                  Center(
                                      child: Text(
                                    'چیزی برای نمایش نیست!',
                                    style: MyTextStyles.titrTextStyle(),
                                  ))
                                ],
                              )
                            : PageStorage(
                                bucket: bucket,
                                child: JobsListViewer(
                                    jobsList: controller.jobsList),
                              ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}

class _ChipsBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChipsBar();

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(FilterController());
    var jobsListController = Get.put(JobsListController());

    return Expanded(
      child: Obx(
        () => Visibility(
          visible: controller.searchChips.isEmpty ? false : true,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.searchChips.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Chip(
                  label: Text(
                    controller.searchChips.values.elementAt(index),
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                  backgroundColor: Colors.brown.withOpacity(0.2),
                  deleteIcon: Icon(
                    Iconsax.close_circle5,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  elevation: 2,
                  onDeleted: () {
                    if (controller.searchChips.keys.elementAt(index) ==
                        'title') {
                      controller.deleteTitleFilter();
                    } else if (controller.searchChips.keys.elementAt(index) ==
                        'category') {
                      controller.deleteCategoryFilter();
                    } else if (controller.searchChips.keys.elementAt(index) ==
                        'adtype') {
                      controller.deleteAdTypefilter();
                    } else if (controller.searchChips.keys.elementAt(index) ==
                        'workType') {
                      controller.deleteCooperationType();
                    } else if (controller.searchChips.keys.elementAt(index) ==
                        'payMethod') {
                      controller.deletePayMethod();
                    } else if (!listEquals(
                        controller.sliderValues, [0.0, 1.0])) {
                      controller.deletePriceFilter();
                    }
                    controller.checkAllFilters();
                    controller.searchMethod();
                    jobsListController.query.value =
                        controller.searchQuery.value;
                    jobsListController.getAds();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
