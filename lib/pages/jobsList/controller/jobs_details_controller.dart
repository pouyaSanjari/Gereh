import 'package:get/get.dart';
import 'package:gereh/services/database.dart';
import 'package:hive/hive.dart';

class JobDetailsTestController extends GetxController {
  @override
  bool get initialized {
    Hive.openBox('bookmarks');

    return super.initialized;
  }

  final database = AppDataBase();
  RxString phoneNumber = ''.obs;

  void getAdvertizer({required String advertizer}) async {
    try {
      var user =
          await database.getUserDetailsById(userId: int.parse(advertizer));
      phoneNumber.value = user[0]['number'];
    } catch (e) {
      phoneNumber.value = '';
    }
  }
}
