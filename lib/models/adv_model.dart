import 'package:hive/hive.dart';

part 'adv_model.g.dart';

@HiveType(typeId: 1)
class AdvModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String advertizerId;
  @HiveField(2)
  final String adType;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final String city;
  @HiveField(6)
  final String descs;
  @HiveField(7)
  final String gender;
  @HiveField(8)
  final String workType;
  @HiveField(9)
  final String workTime;
  @HiveField(10)
  final String payMethod;
  @HiveField(11)
  final String profission;
  @HiveField(12)
  final String price;
  @HiveField(13)
  final String callNumber;
  @HiveField(14)
  final String smsNumber;
  @HiveField(15)
  final String emailAddress;
  @HiveField(16)
  final String websiteAddress;
  @HiveField(17)
  final String instagramid;
  @HiveField(18)
  final String telegramId;
  @HiveField(19)
  final String whatsappNumber;
  @HiveField(20)
  final String time;
  @HiveField(21)
  final String lat;
  @HiveField(22)
  final String lon;
  @HiveField(23)
  final String address;
  @HiveField(24)
  final bool resumeBool;
  @HiveField(25)
  final bool callBool;
  @HiveField(26)
  final bool smsBool;
  @HiveField(27)
  final bool chatBool;
  @HiveField(28)
  final bool emailBool;
  @HiveField(29)
  final bool websiteBool;
  @HiveField(30)
  final bool instagramBool;
  @HiveField(31)
  final bool telegramBool;
  @HiveField(32)
  final bool whatsappBool;
  @HiveField(33)
  final bool locationBool;
  @HiveField(34)
  final List images;
  @HiveField(35)
  final String mazaya;
  @HiveField(36)
  final String sharayet;

  AdvModel(
      this.callNumber,
      this.smsNumber,
      this.emailAddress,
      this.websiteAddress,
      this.instagramid,
      this.telegramId,
      this.whatsappNumber,
      this.lat,
      this.lon,
      this.time,
      this.resumeBool,
      this.callBool,
      this.smsBool,
      this.chatBool,
      this.emailBool,
      this.websiteBool,
      this.instagramBool,
      this.telegramBool,
      this.whatsappBool,
      this.locationBool,
      this.profission,
      this.price,
      this.address,
      this.id,
      this.advertizerId,
      this.adType,
      this.title,
      this.category,
      this.city,
      this.descs,
      this.gender,
      this.workType,
      this.workTime,
      this.payMethod,
      this.images,
      this.mazaya,
      this.sharayet);

  AdvModel.fromJson(Map<dynamic, dynamic> json, List imagesJson)
      : id = json['id'],
        advertizerId = json['advertizerid'],
        adType = json['adtype'],
        title = json['title'],
        category = json['category'],
        city = json['city'],
        descs = json['descs'],
        gender = json['gender'],
        workType = json['workType'],
        workTime = json['workTime'],
        payMethod = json['payMethod'],
        profission = json['profission'],
        price = json['price'],
        address = json['address'],
        resumeBool = json['resumeBool'] == '1' ? true : false,
        callBool = json['callBool'] == '1' ? true : false,
        smsBool = json['smsbool'] == '1' ? true : false,
        chatBool = json['chatbool'] == '1' ? true : false,
        emailBool = json['emailBool'] == '1' ? true : false,
        websiteBool = json['websiteBool'] == '1' ? true : false,
        instagramBool = json['instagramBool'] == '1' ? true : false,
        telegramBool = json['telegramBool'] == '1' ? true : false,
        whatsappBool = json['whatsappBool'] == '1' ? true : false,
        locationBool = json['locationbool'] == '1' ? true : false,
        callNumber = json['callNumber'],
        smsNumber = json['smsNumber'],
        emailAddress = json['emailAddress'],
        websiteAddress = json['websiteAddress'],
        instagramid = json['instagramid'],
        telegramId = json['telegramId'],
        whatsappNumber = json['whatsappNumber'],
        lat = json['locationlat'],
        lon = json['locationlon'],
        time = json['time'],
        images = imagesJson,
        mazaya = json['mazaya'],
        sharayet = json['sharayet'];
}
