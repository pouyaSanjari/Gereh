import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/models/adv_model.dart';
import '../../constants/colors.dart';

class MarkerDetailsContainer extends StatelessWidget {
  final List<AdvModel> data;
  final int index;
  final Function() onTap;

  const MarkerDetailsContainer({
    super.key,
    required this.index,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black26,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal,
                )
              ],
              color: MyColors.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(4))),
          width: 180,
          height: 60,
          child: Row(
            children: [
              SizedBox(
                  height: 60,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: data[index].images.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              height: 60,
                              width: 60,
                              child: const Icon(
                                Iconsax.gallery_slash,
                                size: 30,
                                color: Colors.grey,
                              ),
                            )
                          : CachedNetworkImage(
                              maxHeightDiskCache: 154,
                              maxWidthDiskCache: 154,
                              imageUrl: data[index].images[0]['image'],
                              fit: BoxFit.cover),
                    ),
                  )),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.topRight,
                      child:
                          SizedBox(width: 100, child: Text(data[index].title)),
                    )),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.category,
                          size: 10,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            data[index].category,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
