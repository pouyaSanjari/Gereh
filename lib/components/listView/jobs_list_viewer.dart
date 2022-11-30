import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/constants/colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/pages/jobsList/job_details.dart';

class JobsListViewer extends StatelessWidget {
  const JobsListViewer({
    Key? key,
    required this.jobsList,
  }) : super(key: key);

  final List<AdvModel> jobsList;

  @override
  Widget build(BuildContext context) {
    double height = 130;
    return ListView.separated(
      key: const PageStorageKey('value'),
      itemCount: jobsList.length,
      itemBuilder: (BuildContext context, int index) {
        var adtype = jobsList[index].adType == '0' ? 'استخدام' : 'تبلیغ';
        Color adTypeBgColor =
            jobsList[index].adType == '0' ? MyColors.orange : MyColors.red;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            onTap: () {
              Get.to(
                () => JobDetails(
                  data: jobsList[index],
                ),
              );
            },
            title: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(jobsList[index].title,
                                style: const TextStyle(fontSize: 20))),
                        Row(children: [
                          const Icon(Iconsax.category_2, size: 14),
                          const SizedBox(width: 6),
                          Text(jobsList[index].category,
                              style: const TextStyle(fontSize: 12))
                        ]),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Iconsax.location, size: 15),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                jobsList[index].address,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //ستون آیکون ها و نوع آگهی
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: SizedBox(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 47,
                          decoration: BoxDecoration(
                              color: adTypeBgColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  adtype,
                                  textScaleFactor: 0.6,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: jobsList[index].callBool,
                                child: const Icon(Iconsax.call, size: 15),
                              ),
                              Visibility(
                                visible: jobsList[index].chatBool,
                                child: const Icon(Iconsax.sms, size: 15),
                              ),
                              Visibility(
                                visible: jobsList[index].instagramBool,
                                child: const Icon(Iconsax.instagram, size: 15),
                              ),
                              Visibility(
                                visible: jobsList[index].locationBool,
                                child: const Icon(Iconsax.location, size: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //ستون تصویر آگهی
                if (jobsList[index].images.isEmpty)
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        height: height,
                        width: height,
                        child: const Icon(
                          Iconsax.gallery_slash,
                          size: 55,
                          color: Colors.grey,
                        ),
                      ),
                      Text(MyStrings.timeFunction(jobsList[index].time),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 109, 109, 109),
                              fontSize: 12)),
                    ],
                  )
                else
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: jobsList[index].images[0]['image'],
                          height: height,
                          width: height,
                          filterQuality: FilterQuality.low,
                          maxWidthDiskCache: 302,
                          maxHeightDiskCache: 302,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 30,
                            width: height,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                              MyStrings.timeFunction(jobsList[index].time),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 20,
                            width: 35,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6)),
                                color: Colors.black45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Iconsax.gallery5,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  jobsList[index].images.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
            endIndent: 15, indent: 15, height: 5, thickness: 1);
      },
    );
  }
}
