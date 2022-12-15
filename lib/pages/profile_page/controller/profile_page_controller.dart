import 'package:fluttertoast/fluttertoast.dart';
import 'package:gereh/services/database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePageController extends GetxController {
  @override
  void onInit() {
    _getUserDetails();
    super.onInit();
  }

  final dataBase = AppDataBase();
  final box = GetStorage();
  RxString nameAndFamily = ''.obs;
  RxString family = ''.obs;
  RxString number = ''.obs;
  RxBool isConnected = false.obs;

  _checkConnection() async {
    isConnected.value = await dataBase.checkUserConnection();
  }

  _getUserDetails() async {
    await _checkConnection();
    isConnected.value == false
        ? Fluttertoast.showToast(msg: 'اتصال اینترنت را بررسی نمایید')
        : null;
    var userId = box.read('id') ?? 0;
    var response = await dataBase.getUserDetailsById(userId: userId);
    nameAndFamily.value = response[0]['name'] + ' ' + response[0]['family'];
    number.value = response[0]['number'];
  }
}
