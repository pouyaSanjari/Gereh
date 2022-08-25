import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sarkargar/controllers/image_viewer_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';

class ImageViewerPage extends StatelessWidget {
  List images;
  ImageViewerPage({Key? key, required this.images}) : super(key: key);
  final controller = Get.put(ViewerController());

  @override
  Widget build(BuildContext context) {
    controller.total.value = images.length;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign().cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('گالری تصاویر'),
            centerTitle: true,
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
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    Get.back();
                  },
                  child: PhotoViewGallery.builder(
                    onPageChanged: (index) {
                      controller.current.value = index + 1;
                    },
                    backgroundDecoration: BoxDecoration(color: Colors.grey[50]),
                    wantKeepAlive: true,
                    itemCount: images.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                          minScale: 0.13,
                          maxScale: 0.4,
                          imageProvider: CachedNetworkImageProvider(
                              images[index]['image']));
                    },
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event.cumulativeBytesLoaded.toDouble(),
                        ),
                      ),
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
