// globals
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/advertisement/controller/advertisement_controller.dart';
import 'package:inspired_blog/app.dart';
import 'package:inspired_blog/app/controller/header_image_controller.dart';
import 'package:inspired_blog/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/functions.dart';

late SharedPreferences pref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pref = await SharedPreferences.getInstance();
  getxDependencies();
  clearImageCache();
  setSystemUIOverlay(navigationBarColor: scaffoldBackgroundColor);

  runApp(const App());
}

Future<void> clearImageCache() async {
  await DefaultCacheManager().emptyCache();
}

void getxDependencies() {
  Get.put(MagazineController());
  Get.put(EntertainmentController());
  Get.put(HeaderImageController());
  Get.put(AdvertisementController());
}
