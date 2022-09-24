import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:expandable_fab_menu/expandable_fab_menu.dart';
import 'package:get/get.dart';
import 'package:sarkargar/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsController extends GetxController {
  final database = AppDataBase();

  String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
  RxString advertizer = ''.obs;

  RxString advertizerNumber = ''.obs;

  RxString adType = ''.obs;
  RxString hiringtype = ''.obs;
  RxString title = ''.obs;
  RxString category = ''.obs;
  RxString city = ''.obs;
  RxString address = ''.obs;
  RxString locationlat = ''.obs;
  RxString locationlon = ''.obs;
  RxString men = ''.obs;
  RxString women = ''.obs;
  RxString mprice = ''.obs;
  RxString wprice = ''.obs;
  RxString descs = ''.obs;
  RxString time = ''.obs;
  RxString instagramid = ''.obs;

  RxBool phonebool = false.obs;
  RxBool smsbool = false.obs;
  RxBool chatbool = false.obs;
  RxBool photobool = false.obs;
  RxBool locationbool = false.obs;
  RxBool instagrambool = false.obs;

  RxBool contactInfoPosition = false.obs;

  RxList<ExpandableFabMenuItem> contact = <ExpandableFabMenuItem>[].obs;

  void initialData({required Map ad}) {
    advertizer.value = ad['advertizerid'];
    adType.value = ad['adtype'];
    hiringtype.value = ad['hiringtype'];
    title.value = ad['title'];
    category.value = ad['category'];
    city.value = ad['city'];
    address.value = ad['address'];
    locationlat.value = ad['locationlat'];
    locationlon.value = ad['locationlon'];
    men.value = ad['men'];
    women.value = ad['women'];
    mprice.value = ad['mprice'];
    wprice.value = ad['wprice'];
    descs.value = ad['descs'];
    time.value = ad['time'];
    instagramid.value = ad['instagramid'];

    phonebool.value = ad['phonebool'] == '0' ? false : true;
    smsbool.value = ad['smsbool'] == '0' ? false : true;
    chatbool.value = ad['chatbool'] == '0' ? false : true;
    photobool.value = ad['photobool'] == '0' ? false : true;
    locationbool.value = ad['locationbool'] == '0' ? false : true;
    instagrambool.value = ad['instagrambool'] == '0' ? false : true;
  }

  void getAdvertizer() async {
    var user =
        await database.getUserDetailsById(userId: int.parse(advertizer.value));
    advertizerNumber.value = user[0]['number'];
  }

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: advertizerNumber.value.toString(),
    );
    await launchUrl(launchUri);
  }

  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  textMe() async {
    // Android
    var uri = 'sms:${advertizerNumber.value}';
    await launchUrl(Uri.parse(uri));
  }

  Future<void> launchInstagram() async {
    // ignore: deprecated_member_use
    await launch("https://www.instagram.com/${instagramid.value}/",
        universalLinksOnly: true);
  }

  @override
  void onClose() {
    contactInfoPosition.value = false;
    super.onClose();
  }
}
