// part 'adv_model.g.dart';

class AdvModel {
  final String id;
  final String advertizerId;
  final String adType;
  final String title;
  final String category;
  final String city;
  final String descs;
  final String gender;
  final String workType;
  final String workTime;
  final String payMethod;
  final String profission;
  final String price;
  final String callNumber;
  final String smsNumber;
  final String emailAddress;
  final String websiteAddress;
  final String instagramid;
  final String telegramId;
  final String whatsappNumber;
  final String time;
  final String lat;
  final String lon;
  final String address;
  final bool resumeBool;
  final bool callBool;
  final bool smsBool;
  final bool chatBool;
  final bool emailBool;
  final bool websiteBool;
  final bool instagramBool;
  final bool telegramBool;
  final bool whatsappBool;
  final bool locationBool;
  final List images;

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
      this.images);

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
        images = imagesJson;
}
