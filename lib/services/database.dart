import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarkargar/controllers/request_controller.dart';

final requestController = Get.put(RequestController());
final box = GetStorage();
final ImagePicker picker = ImagePicker();

class AppDataBase {
// گرفتن تصاویر آپلود شده کاربر
  uploadedImages() async {
    requestController.images.clear();
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/getimages.php');
    var jsonresponse =
        await http.post(url, body: {'userid': box.read('id').toString()});
    List result = convert.jsonDecode(jsonresponse.body);
    for (var i = 0; i < result.length; i++) {
      requestController.images.add(result[i]['image']);
    }
    print(result);
  }

  paidFeautersImages(List uploadedImages) async {
    requestController.images.clear();
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/getimages.php');
    try {
      var jsonresponse =
          await http.post(url, body: {'userid': box.read('id').toString()});
      List result = convert.jsonDecode(jsonresponse.body);
      for (int i = 0; i < result.length; i++) {
        uploadedImages.add(result[i]['image']);
      }
      requestController.images.isEmpty
          ? requestController.images.value = uploadedImages
          : null;
      return result;
    } catch (e) {
      null;
    }
  }

// آپلود تصویر
  uploadImage() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image == null) {
      return;
    }
    var url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/upload_image.php');
    var request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('photo[0]', image.path));
    Map<String, String> other = {'id': box.read('id').toString()};
    request.fields.addAll(other);
    Fluttertoast.showToast(msg: 'درحال آپلود...');
    await request.send();
    uploadedImages();
  }

  /// حذف تصویر
  deleteImage(String imageId) async {
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/deletefile.php');
    await http.post(url, body: {'imageid': imageId});
    uploadedImages();
  }

  ///گرفتن اطلاعات کاربر از طریق ایدی
  getUserDetailsById({required int userId}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/userDB/userdetails.php');
    var response = await http
        .post(url, body: {'query': 'select * from users where id = $userId '});
    var jsonresponse = await convert.jsonDecode(response.body);
    return jsonresponse;
  }

  ///گرفتن ای دی شخص از روی شماره تلفن
  getUserIdByNumber({required String number}) async {
    var url = Uri.https('sarkargar.ir', 'phpfiles/userDB/userdetails.php');
    var response = await http.post(
      url,
      body: {'query': 'select id from users where number = $number'},
    );
    var jsonresponse = await convert.jsonDecode(response.body);
    return jsonresponse;
  }

  ///گرفتن تمام تبیلغلات
  getAds({required String query}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/ads.php');
    var response = await http.post(url, body: {'query': query});
    var jsonResponse = convert.jsonDecode(response.body);

    var imagesUrl =
        Uri.parse('https://sarkargar.ir/phpfiles/userimages/getallimages.php');
    var imagesResponse = await http.get(imagesUrl);
    var imageToJson = convert.jsonDecode(imagesResponse.body);
    return [jsonResponse, imageToJson];
  }

  ///گرفتن لیست گروه های شغلی
  getJobs() async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobs.php');
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  getJobGroups() async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobGroups.php');
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  getCitiesAndProvinces() async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/getProvienceList.php');
    var response = await http.get(url);
    List jsonDecoded = await convert.jsonDecode(response.body);
    return jsonDecoded;
  }

  addNewAD({
    required String advertizerid,
    required String adtype,
    required String title,
    required String category,
    required String city,
    required String descs,
    required String gender,
    required String workType,
    required String workTime,
    required String payMethod,
    required String profission,
    required String price,
    required String resumeBool,
    required String callBool,
    required String callNumber,
    required String smsBool,
    required String smsNumber,
    required String chatBool,
    required String emailBool,
    required String emailAddress,
    required String websiteBool,
    required String websiteAddress,
    required String instagramBool,
    required String instagramId,
    required String telegramBool,
    required String telegramId,
    required String whatsappBool,
    required String whatsappNumber,
    required String locationbool,
    required String locationlat,
    required String locationlon,
    required String address,
  }) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/request.php');
    var response = await http.post(url, body: {
      'advertizerid': advertizerid,
      'adtype': adtype,
      'title': title,
      'category': category,
      'city': city,
      'descs': descs,
      'gender': gender,
      'workType': workType,
      'workTime': workTime,
      'payMethod': payMethod,
      'profission': profission,
      'price': price,
      'resumeBool': resumeBool,
      'callBool': callBool,
      'callNumber': callNumber,
      'smsbool': smsBool,
      'smsNumber': smsNumber,
      'chatbool': chatBool,
      'emailBool': emailBool,
      'emailAddress': emailAddress,
      'websiteBool': websiteBool,
      'websiteAddress': websiteAddress,
      'instagramBool': instagramBool,
      'telegramId': telegramId,
      'instagramid': instagramId,
      'telegramBool': telegramBool,
      'whatsappBool': whatsappBool,
      'whatsappNumber': whatsappNumber,
      'locationbool': locationbool,
      'locationlat': locationlat,
      'locationlon': locationlon,
      'address': address,
      'time': DateTime.now().toString(),
    });
    print(response.body);
    return response.statusCode;
  }

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
