import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/meta_data/model/meta_data.dart';

class MetaDataController extends GetxController {
  static MetaDataController get instance => Get.find<MetaDataController>();

  List<NounMetaData> metaData = [];

  Future<void> getMetaData() async {
    final data = await NounAPI.getMetaData();
    metaData = data;
    update();
  }
}
