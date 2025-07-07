import 'package:get/get.dart';
import 'package:inspired_blog_panel/advertisement/model/advertisement.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/header_image/model/header_image.dart';

class AdvertisementController extends GetxController {
  static AdvertisementController get instance =>
      Get.find<AdvertisementController>();

  List<Advertisement> advertisements = [];

  Future<void> getAdvertisements() async {
    final data = await NounAPI.getAdvertisements();
    advertisements = data;
    update();
  }
}
