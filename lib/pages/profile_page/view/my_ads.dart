import 'package:flutter/material.dart';
import 'package:gereh/components/errorPage/error_page.dart';
import 'package:gereh/components/jobsListViewer/jobs_list_viewer.dart';
import 'package:gereh/components/other/loading.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyAds extends StatefulWidget {
  const MyAds({super.key});

  @override
  State<MyAds> createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  @override
  void initState() {
    _getAds();
    super.initState();
  }

  List<AdvModel> data = [];
  bool hasError = false;
  bool loading = true;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign.cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              title: const Text('آگهی های من'),
              leading: BackButton(
                onPressed: () => Navigator.pop(context),
              )),
          body: loading
              ? const Loading()
              : hasError
                  ? ErrorPage(
                      onReferesh: () => _getAds(),
                    )
                  : SafeArea(
                      child: JobsListViewer(jobsList: data),
                    ),
        ),
      ),
    );
  }

  ///گرفتن تمام تبیلغلات
  _getAds() async {
    hasError = false;
    loading = true;
    setState(() {});
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/ads.php');
    try {
      var response = await http.post(url, body: {
        'query': "select * from requests where advertizerid = ${box.read('id')}"
      });
      List jsonResponse = convert.jsonDecode(response.body);
      Uri imagesUrl = Uri.parse(
          'https://sarkargar.ir/phpfiles/userimages/getallimages.php');
      var imagesResponse = await http.get(imagesUrl);

      List imageToJson = convert.jsonDecode(imagesResponse.body);

      // List<AdvModelTest> jobTestModel = [];
      data = [];

      for (var element in jsonResponse) {
        data.add(AdvModel.fromJson(
            element,
            imageToJson
                .where((image) => image['adId'] == element['id'])
                .toList()));
      }
      data = data.reversed.toList();
      loading = false;
      setState(() {});
      // return jobTestModel;
    } catch (e) {
      loading = false;
      hasError = true;
      setState(() {});
      e.printError;
    }
  }
}
