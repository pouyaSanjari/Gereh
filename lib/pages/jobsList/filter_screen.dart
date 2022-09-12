import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/services/uiDesign.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final box = GetStorage();
  UiDesign uiDesign = UiDesign();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: const Text('فیلتر', style: TextStyle(color: Colors.black)),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context, ''),
                    icon: const Icon(
                      Iconsax.arrow_left,
                      color: Colors.black,
                    ))
              ]),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset('assets/SVG/filter.svg',
                        width: 200, height: 200),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
