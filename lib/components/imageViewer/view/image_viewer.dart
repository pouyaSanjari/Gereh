import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/components/imageViewer/controller/image_viewer_controller.dart';
import 'package:gereh/services/ui_design.dart';

class ImageViewer extends StatelessWidget {
  final List images;
  final int? currentIndex;
  ImageViewer({Key? key, required this.images, this.currentIndex})
      : super(key: key);
  final controller = Get.put(ViewerController());

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: currentIndex ?? 0);
    controller.total.value = images.length;
    currentIndex == null
        ? controller.current.value = 1
        : controller.current.value = currentIndex! + 1;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign.cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('گالری تصاویر'),
            elevation: 0,
            leading: InkWell(
                onTap: () => Get.back(),
                child: const Icon(
                  Iconsax.arrow_right_3,
                  color: Colors.black,
                )),
          ),
          body: Column(
            children: [
              Expanded(
                child: PhotoViewGallery.builder(
                  onPageChanged: (index) {
                    controller.current.value = index + 1;
                  },
                  pageController: pageController,
                  backgroundDecoration: BoxDecoration(color: Colors.grey[50]),
                  wantKeepAlive: false,
                  itemCount: images.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                        minScale: Get.mediaQuery.size.aspectRatio,
                        maxScale: Get.mediaQuery.size.aspectRatio * 3,
                        imageProvider: CachedNetworkImageProvider(
                            images[index]['image'],
                            maxWidth:
                                MediaQuery.of(context).size.width.toInt() + 200,
                            scale: Get.mediaQuery.size.aspectRatio));
                  },
                  loadingBuilder: (context, event) => const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.blue,
                    ),
                  ),
                ),
              ),
              Obx(() => Text(
                    '${controller.current} / ${controller.total}',
                    style: const TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
