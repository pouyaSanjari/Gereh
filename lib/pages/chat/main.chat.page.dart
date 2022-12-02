import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/jobsListViewer/jobs_list_viewer.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/services/ui_design.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({Key? key}) : super(key: key);

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

late MapController mapController;

class _MainChatPageState extends State<MainChatPage> {
  @override
  void initState() {
    mapController = MapController();
    readData();
    super.initState();
  }

  List<AdvModel> model = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text('موارد ذخیره شده'),
            leading: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {},
                child: const Icon(Iconsax.message_question))),
        body: JobsListViewer(jobsList: model),
      ),
    );
  }

  Future<void> readData() async {
    Box hiveBox = await Hive.openBox('bookmarks');
    List<AdvModel> savedJobsList = [];
    for (var i = 0; i < hiveBox.length; i++) {
      savedJobsList.add(hiveBox.getAt(i));
    }
    model = savedJobsList.reversed.toList();
    setState(() {});
  }
}
