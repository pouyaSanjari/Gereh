import 'package:gereh/models/adv_model.dart';
import 'package:hive/hive.dart';

class HiveActions {
  HiveActions._();
  static Future<bool> checkIfObjectExists(
      {required AdvModel advModel, Box? hive, String? box}) async {
    if (box != null) {
      hive = await Hive.openBox(box);
    }
    List<AdvModel> model = [];
    for (var i = 0; i < hive!.length; i++) {
      model.add(hive.getAt(i));
    }

    for (var i = 0; i < model.length; i++) {
      if (model[i].id == advModel.id) {
        // object exists
        return true;
      }
    }
    return false;
  }

  static Future<void> addBookmark(
      {required AdvModel advModel, required Box hive}) async {
    bool isExists = await checkIfObjectExists(advModel: advModel, hive: hive);
    if (!isExists) {
      hive.add(advModel);
    }
  }

  static void deleteBookmark({required AdvModel advModel, required Box hive}) {
    List<AdvModel> model = [];
    for (var i = 0; i < hive.length; i++) {
      model.add(hive.getAt(i));
    }
    for (var i = 0; i < model.length; i++) {
      if (model[i].id == advModel.id) {
        hive.deleteAt(i);
      }
    }
  }
}
