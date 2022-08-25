import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AppDataBase {
  ///گرفتن اطلاعات کاربر از طریق ایدی
  getUserDetailsById({required int userId}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/userDB/userdetails.php');
    var response = await http
        .post(url, body: {'query': 'select * from users where id = $userId '});
    var jsonresponse = await convert.jsonDecode(response.body);
    return jsonresponse;
  }

//گرفتن ای دی شخص از روی شماره تلفن
  getUserIdByNumber({required String number}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/userDB/userdetails.php');
    var response = await http.post(url,
        body: {'query': 'select id from users where number = $number'});
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

  ///گرفتن لیست استانهای کشور
  getProvinces() async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/ostanha.php');
    var response = await http.post(url);
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  ///گرفتن لیست شهرهای استان انتخابی
  getCitis(String ostan) async {
    var url1 = Uri.parse('https://sarkargar.ir/phpfiles/ostanNumber.php');
    var response1 = await http.post(url1, body: {'ostan': ostan});
    var jsonResponse1 = await convert.jsonDecode(response1.body);
    var ostanNumber = jsonResponse1[0]['id'];

    var url2 = Uri.parse('https://sarkargar.ir/phpfiles/cities.php');
    var response2 = await http.post(url2, body: {'parent': ostanNumber});
    var jsonResponse2 = convert.jsonDecode(response2.body);

    return jsonResponse2;
  }

  getCitiesAndProvinces() async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/getProvienceList.php');
    var response = await http.get(url);
    List jsonDecoded = await convert.jsonDecode(response.body);
    return jsonDecoded;
  }

  addNewAD({
    required String advertizer,
    required String adtype,
    required String hiringtype,
    required String title,
    required String category,
    required String city,
    required String address,
    required String instagramid,
    required String locationlat,
    required String locationlon,
    required String phonebool,
    required String chatbool,
    required String photobool,
    required String locationbool,
    required String instagrambool,
    required String men,
    required String women,
    required String mprice,
    required String wprice,
    required String descs,
  }) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/request.php');
    var response = await http.post(url, body: {
      'advertizerid': advertizer,
      'adtype': adtype,
      'hiringtype': hiringtype,
      'title': title,
      'category': category,
      'city': city,
      'address': address,
      'instagramid': instagramid,
      'locationlat': locationlat,
      'locationlon': locationlon,
      'phonebool': phonebool,
      'chatbool': chatbool,
      'photobool': photobool,
      'locationbool': locationbool,
      'instagrambool': instagrambool,
      'men': men,
      'women': women,
      'mprice': mprice,
      'wprice': wprice,
      'descs': descs,
      'time': DateTime.now().toString(),
    });
    return response.statusCode;
  }

  getUserGroups({required int userId}) async {
    var url =
        Uri.parse('https://sarkargar.ir/phpfiles/userDB/getusergroups.php');
    var response = await http.post(url,
        body: {'query': 'select * from groups where `userid` =$userId'});
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  createNewGroup({required int userId, required String groupName}) async {
    var url =
        Uri.parse('https://sarkargar.ir/phpfiles/userDB/getusergroups.php');
    var response = await http.post(url, body: {
      'query':
          "INSERT INTO `groups` (`id`, `userid`, `groupname`) VALUES (NULL, '$userId', '$groupName')"
    });
    return response.statusCode;
  }

  deletGroup({required String id}) async {
    var url =
        Uri.parse('https://sarkargar.ir/phpfiles/userDB/getusergroups.php');
    var response = await http
        .post(url, body: {'query': "DELETE FROM `groups` WHERE `id` = $id"});

    return response.statusCode;
  }

  updateGroupName({required String id, required String newName}) async {
    var url =
        Uri.parse('https://sarkargar.ir/phpfiles/userDB/getusergroups.php');
    var response = await http.post(url, body: {
      'query': "UPDATE `groups` SET `groupname` = '$newName' WHERE `id` = $id"
    });

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

  getGroupsDetails({required String groupid}) async {
    var url =
        Uri.parse('https://sarkargar.ir/phpfiles/userDB/getusergroups.php');
    var response = await http.post(url,
        body: {'query': 'select * from groupitems where `groupid` =$groupid'});
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  insertIntoGroup(
      {required String groupid,
      required String gender,
      required String name,
      required String family,
      required String number}) async {
    var url =
        Uri.parse('https://sarkargar.ir/phpfiles/userDB/getusergroups.php');
    var response = await http.post(url, body: {
      'query':
          "INSERT INTO `groupitems` (`id`, `groupid`, `gender`, `name`, `family`, `number`) "
              "VALUES (NULL, '$groupid', '$gender', '$name', '$family', '$number')"
    });
    return response.statusCode;
  }

// ignore: todo
//TODO: تغییر متد GET به PSOT
  adDetailsGet(String jobId) async {
    var url = Uri.parse(
        'https://sarkargar.ir/phpfiles/jobreqsDB/adDetails.php?id=${int.parse(jobId)}');
    var response = await http.get(url);
    var jsonresponse = convert.jsonDecode(response.body);

    return jsonresponse;
  }

  getChats({required String id}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/chats/getChats.php');
    var response = await http.post(url, body: {'id': id});
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  getUnreadMessages({required String groupId}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/chats/getMessages.php');
    var response = await http.post(url, body: {'groupid': groupId});
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  }

  setMessagesToReaded({required String messageId}) async {
    var url = Uri.parse(
        'https://sarkargar.ir/phpfiles/chats/set_read_messages_state.php');
    var response = await http.post(url, body: {'messageId': messageId});

    return response.body;
  }

  uploadImage() async {
    var url = Uri.parse('http://localhost/upload/upload_image.php');
    var request = http.MultipartRequest('POST', url);
    Map<String, String> fields = {'adid': '0'};
    request.fields.addEntries(fields.entries);
    var picture = http.MultipartFile.fromBytes(
        'image', (await rootBundle.load('')).buffer.asInt8List(),
        filename: 'ducking.png');
    request.files.add(picture);
  }
}
