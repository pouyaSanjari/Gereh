import 'package:flutter/material.dart';
import 'package:gereh/components/other/loading.dart';
import 'package:gereh/pages/profile_page/controller/saved_ads_page_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/jobsListViewer/jobs_list_viewer.dart';
import 'package:gereh/services/ui_design.dart';

class SavedAdsPage extends StatelessWidget {
  const SavedAdsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedAdsPageController());
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(
          () => Scaffold(
            appBar: AppBar(
                actions: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(Iconsax.message_question),
                    ),
                  ),
                ],
                title: const Text('موارد ذخیره شده'),
                leading: BackButton(
                  onPressed: () => Navigator.pop(context),
                )),
            body: controller.loading.value
                ? const Center(
                    child: Loading(),
                  )
                : controller.empty.value
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Iconsax.empty_wallet_remove,
                              size: 100,
                            ),
                            SizedBox(height: 20),
                            Text('چیزی برای نمایش وجود ندارد!')
                          ],
                        ),
                      )
                    : JobsListViewer(jobsList: controller.model),
          ),
        ),
      ),
    );
  }
}
