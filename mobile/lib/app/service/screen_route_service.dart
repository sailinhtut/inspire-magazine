import 'package:get/get.dart';
import 'package:inspired_blog/api/noun_api.dart';
import 'package:inspired_blog/app/view/main_screen.dart';
import 'package:inspired_blog/entertainment/view/entertainment_detail_screen.dart';
import 'package:inspired_blog/magazine/view/magazine_detail_screen.dart';
import 'package:inspired_blog/magazine/view/magazine_list_screen.dart';
import 'package:inspired_blog/utils/functions.dart';

class NounRouter {
  static String get homeScreen => "homeScreen";
  static String get magazineListScreen => "magazineListScreen";
  static String get magazineDetailScreen => "magazineDetailScreen";
  static String get entertainmentDetailScreen => "entertainmentDetailScreen";
  static String get episodeDetailScreen => "episodeDetailScreen";

  static launchRoute(String? route, Map<dynamic, dynamic> data) {
    switch (route) {
      case "homeScreen":
        Get.offAll(() => const MainScreen());
        break;
      case "magazineListScreen":
        Get.to(() => const MagazineListScreen());
        break;
      case "magazineDetailScreen":
        processMagazineDetailScreen(data);
        break;
      case "entertainmentDetailScreen":
        processEntertainmentDetailScreen(data);
        break;
      default:
        Get.offAll(() => const MainScreen());
    }
  }

  static Future<void> processMagazineDetailScreen(
      Map<dynamic, dynamic> data) async {
    final magazineId = data["id"];
    if (magazineId != null && int.tryParse(magazineId.toString()) != null) {
      final parsed = int.tryParse(magazineId.toString());
      toast("Loading...");
      final magazine = await NounAPI.getMagazine(parsed!);
      if (magazine != null) {
        Get.to(() => MagazineDetailScreen(parentMagazine: magazine));
      }
    }
  }

  static Future<void> processEntertainmentDetailScreen(
      Map<dynamic, dynamic> data) async {
    final entertainmentId = data["id"];
    if (entertainmentId != null &&
        int.tryParse(entertainmentId.toString()) != null) {
      final parsed = int.tryParse(entertainmentId.toString());
      toast("Loading...");
      final entertainment = await NounAPI.getEntertainment(parsed!);
      if (entertainment != null) {
        Get.to(() =>
            EntertainmentDetailScreen(parentEntertainment: entertainment));
      }
    }
  }
}
