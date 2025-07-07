import 'package:get/get.dart';
import 'package:inspired_blog/api/noun_api.dart';
import 'package:inspired_blog/app/model/header_image.dart';

class HeaderImageController extends GetxController {
  static HeaderImageController get instance =>
      Get.find<HeaderImageController>();

  List<HeaderImage> images = [];

  Future<void> getHeaderImages() async {
    final data = await NounAPI.getHeaderImages();
    images = data;
    images.sort((a, b) => a.order!.compareTo(b.order!));
    update();
  }
}
