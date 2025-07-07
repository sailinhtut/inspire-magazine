import 'package:get/get.dart';
import 'package:inspired_blog/api/noun_api.dart';
import 'package:inspired_blog/magazine/model/magazine.dart';
import 'package:inspired_blog/utils/functions.dart';

class MagazineController extends GetxController {
  static MagazineController get instance => Get.find<MagazineController>();

  List<Magazine> magazines = [];
  int currentPage = 1;
  int previousPage = 0;
  int nextPage = 0;
  int lastPage = 0;
  int firstPage = 0;

  Future<List<Magazine>> getMagazines({int? page, bool append = false}) async {
    if (currentPage == lastPage && page != 1) {
      return [];
    }

    final data = await NounAPI.getMagazines(page ?? currentPage);

    if (data is List) {
      // magazines
      final fetched =
          List<dynamic>.from(data).map((e) => Magazine.fromJson(e)).toList();

      if (append) {
        // magazines.addAll(fetched);
        // magazines = magazines.toSet().toList();
        dd("Appending Started on ${magazines.length}");
        fetched.forEach((element) {
          if (!magazines.any((m) => m.magazineId == element.magazineId)) {
            magazines.add(element);
          }
        });

        dd("Appending End on ${magazines.length}");
      } else {
        magazines = fetched;
      }
      update();
      return fetched;
    }

    if (data.isNotEmpty) {
      // magazines
      final blogList = List<dynamic>.from(data["data"])
          .map((e) => Magazine.fromJson(e))
          .toList();

      if (append) {
        magazines.addAll(blogList);
        magazines = magazines.toSet().toList();
      } else {
        magazines = blogList;
      }

      // paginate
      currentPage = data["current_page"] ?? 0;
      previousPage = data["prev_page_url"] != null
          ? int.parse(data["prev_page_url"].toString().split("=").last)
          : 0;
      nextPage = data["next_page_url"] != null
          ? int.parse(data["next_page_url"].toString().split("=").last)
          : 0;
      lastPage = data["last_page_url"] != null
          ? int.parse(data["last_page_url"].toString().split("=").last)
          : 0;
      firstPage = data["first_page_url"] != null
          ? int.parse(data["first_page_url"].toString().split("=").last)
          : 0;

      update();
      return blogList;
    }

    return [];
  }

  Future<List<Magazine>> searchMagazine(String needle) async {
    final data = await NounAPI.searchMagazines(needle);
    magazines = data;
    update();
    return data;
  }

  Future<Magazine?> getMagazineDetails(int magazineId) async {
    final result = await NounAPI.getMagazine(magazineId);

    if (result != null) {
      final index =
          magazines.indexWhere((element) => element.magazineId == magazineId);
      magazines.removeWhere((element) => element.magazineId == magazineId);
      magazines.insert(index, result); // replace with full detailed model
      update();
      return result;
    }

    return null;
  }
}
