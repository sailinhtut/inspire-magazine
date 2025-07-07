import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/advertisement/controller/advertisement_controller.dart';
import 'package:inspired_blog_panel/auth/controller/auth_controller.dart';
import 'package:inspired_blog_panel/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog_panel/header_image/controller/header_image_controller.dart';
import 'package:inspired_blog_panel/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog_panel/meta_data/controller/meta_data_controller.dart';
import 'package:inspired_blog_panel/shared/presentation/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configure();

  runApp(const App());
}

Future<void> configure() async {
  // disk storage
  pref = await SharedPreferences.getInstance();

  // state dependency
  Get.put(AuthController());
  Get.put(MagazineController());
  Get.put(EntertainmentController());
  Get.put(HeaderImageController());
  Get.put(AdvertisementController());
  Get.put(MetaDataController());
}
