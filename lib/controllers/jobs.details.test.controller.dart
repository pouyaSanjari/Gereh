import 'package:get/get.dart';
import 'package:sarkargar/services/database.dart';

class JobDetailsTestController extends GetxController {
  final database = AppDataBase();
  RxString phoneNumber = ''.obs;

  void getAdvertizer({required String advertizer}) async {
    try {
      var user =
          await database.getUserDetailsById(userId: int.parse(advertizer));
      phoneNumber.value = user[0]['number'];
    } catch (e) {
      print(e);
      phoneNumber.value = '';
    }
  }
}
