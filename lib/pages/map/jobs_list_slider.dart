import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/buttons/rounded.button.dart';
import 'package:gereh/components/other/icon.container.dart';
import 'package:gereh/constants/colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/constants/my_text_styles.dart';
import 'package:gereh/controllers/map.test.controller.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/pages/jobsList/job_details.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class JobsListSlider extends StatefulWidget {
  const JobsListSlider({
    Key? key,
    required this.controller,
    required MapZoomPanBehavior mapZoomPanBehavior,
    required this.ind,
    required this.data,
  })  : _mapZoomPanBehavior = mapZoomPanBehavior,
        super(key: key);

  final MapTestController controller;
  final MapZoomPanBehavior _mapZoomPanBehavior;
  final int ind;
  final List<AdvModel> data;

  @override
  State<JobsListSlider> createState() => _JobsListSliderState();
}

class _JobsListSliderState extends State<JobsListSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 0.85,
        initialPage: widget.ind,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        height: 320,
        pageViewKey: const PageStorageKey('value'),
        onPageChanged: (index, reason) {
          widget.controller.currentIndex.value = widget.ind;
        },
      ),
      itemCount: widget.data.length,
      itemBuilder: (context, index, realIndex) {
        bool isHiring = widget.data[index].adType == '1' ? false : true;
        bool isBookmarked =
            widget.controller.checkIfObjectExists(widget.data[index]);
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyRoundedButton(
                  icon: const Icon(
                    Icons.location_searching_rounded,
                    color: MyColors.black,
                  ),
                  backColor: Colors.white,
                  text: '',
                  onClick: () {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        widget._mapZoomPanBehavior.latLngBounds =
                            MapLatLngBounds(
                          MapLatLng(
                            double.parse(widget.data[index].lat) - 0.001,
                            double.parse(widget.data[index].lon) - 0.001,
                          ),
                          MapLatLng(
                            double.parse(widget.data[index].lat) + 0.001,
                            double.parse(widget.data[index].lon) + 0.001,
                          ),
                        );
                      },
                    );
                  },
                ),
                MyRoundedButton(
                  icon: Icon(
                    isBookmarked
                        ? FontAwesomeIcons.bookBookmark
                        : FontAwesomeIcons.book,
                    color: isBookmarked ? Colors.white : Colors.black,
                  ),
                  backColor: isBookmarked ? MyColors.red : Colors.white,
                  text: '',
                  onClick: () {
                    if (isBookmarked) {
                      setState(() {
                        widget.controller.deleteBookmark(widget.data[index]);
                      });
                    } else {
                      setState(() {
                        widget.controller.addBookmark(widget.data[index]);
                      });
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => JobDetails(mod: widget.data[index]),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.backgroundColor.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.data[index].images.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 80,
                                        width: 80,
                                        child: const Icon(
                                          Iconsax.gallery_slash,
                                          size: 55,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Flexible(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                              width: 80,
                                              height: 80,
                                              maxWidthDiskCache: 220,
                                              maxHeightDiskCache: 220,
                                              fit: BoxFit.cover,
                                              imageUrl: widget.data[index]
                                                  .images[0]['image']),
                                        ),
                                      ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  height: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.data[index].title,
                                          style: MyTextStyles.titleTextStyle(
                                              Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Iconsax.clock,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            MyStrings.timeFunction(
                                                widget.data[index].time),
                                            style: MyTextStyles
                                                .descriptionsTextStyle(
                                                    Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Iconsax.category,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                              overflow: TextOverflow.visible,
                                              widget.data[index].category)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            isHiring
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'جنسیت',
                                          value: widget.data[index].gender,
                                          icon:
                                              widget.data[index].gender == 'آقا'
                                                  ? Iconsax.man
                                                  : Iconsax.woman,
                                          iconColor: MyColors.green,
                                        ),
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'دستمزد',
                                          value: widget.data[index].price ==
                                                  'توافقی'
                                              ? 'توافقی'
                                              : MyStrings.digi(
                                                  widget.data[index].price == ''
                                                      ? widget.data[index].price
                                                      : widget
                                                          .data[index].price),
                                          icon: Iconsax.dollar_square,
                                          iconColor: MyColors.red,
                                        ),
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'شیوه پرداخت',
                                          value: widget.data[index].payMethod,
                                          icon: Iconsax.wallet_money,
                                          iconColor: MyColors.orange,
                                        ),
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'نوع همکاری',
                                          value: widget.data[index].workType,
                                          icon: Iconsax.home_wifi5,
                                          iconColor: MyColors.blue,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        const Text(
                                          'توضیحات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(widget.data[index].descs)
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 65),
          ],
        );
      },
    );
  }
}
