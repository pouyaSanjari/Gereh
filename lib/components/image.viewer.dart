import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sarkargar/controllers/image_viewer_controller.dart';
import 'package:sarkargar/services/ui_design.dart';

class ImageViewerPage extends StatelessWidget {
  final List images;
  ImageViewerPage({Key? key, required this.images}) : super(key: key);
  final controller = Get.put(ViewerController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    controller.total.value = images.length;
    controller.current.value = 1;
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
                  customSize: Size(
                      MediaQuery.of(context).size.width - 1, double.infinity),
                  onPageChanged: (index) {
                    controller.current.value = index + 1;
                  },
                  backgroundDecoration: BoxDecoration(color: Colors.grey[50]),
                  wantKeepAlive: true,
                  itemCount: images.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                        maxScale: Get.mediaQuery.size.aspectRatio * 3,
                        imageProvider: CachedNetworkImageProvider(
                            images[index]['image'],
                            scale: Get.mediaQuery.size.aspectRatio));
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
