import 'package:get/get.dart';
import 'package:inspired_blog/advertisement/model/advertisement.dart';
import 'package:inspired_blog/api/noun_api.dart';
import 'package:inspired_blog/utils/functions.dart';

class AdvertisementController extends GetxController {
  static AdvertisementController get instance =>
      Get.find<AdvertisementController>();

  List<Advertisement> advertisements = [];

  Future<void> getAdvertisements() async {
    final data = await NounAPI.getAdvertisements();
    advertisements = data;
    update();
  }

  List<Advertisement> get magazineAds => advertisements
      .where((element) => element.adsType == AdsTypes.magazine)
      .toList();

  List<Advertisement> get entertainmentAds => advertisements
      .where((element) => element.adsType == AdsTypes.entertainment)
      .toList();

  List<Advertisement> get popupAds => advertisements
      .where((element) => element.adsType == AdsTypes.popup)
      .toList();
}
