import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/entertainment/model/entertainment.dart';
import 'package:inspired_blog_panel/utils/functions.dart';

class EntertainmentController extends GetxController {
  static EntertainmentController get instance =>
      Get.find<EntertainmentController>();

  List<Entertainment> entertainments = [];
  int currentPage = 1;
  int previousPage = 0;
  int nextPage = 0;
  int lastPage = 0;
  int firstPage = 0;

  Future<List<Entertainment>> getEntertainments(
      {int? page, bool append = false,bool force = false}) async {
    if (currentPage == lastPage && page != 1 && !force) {
      return [];
    }

    final data = await NounAPI.getEntertainments(page ?? currentPage);

    if (data is List) {
      // magazines
      final fetched = List<dynamic>.from(data)
          .map((e) => Entertainment.fromJson(e))
          .toList();

      if (append) {
        fetched.forEach((element) {
          if (!entertainments.any((m) => m.id == element.id)) {
            entertainments.add(element);
          }
        });

        dd("Appending End on ${entertainments.length}");
      } else {
        entertainments = fetched;
      }
      update();
      return fetched;
    }

    if (data.isNotEmpty) {
      // entertainments
      final entertainmentList = List<dynamic>.from(data["data"])
          .map((e) => Entertainment.fromJson(e))
          .toList();

      if (append) {
        entertainments.addAll(entertainmentList);
        entertainments = entertainments.toSet().toList();
      } else {
        entertainments = entertainmentList;
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
      return entertainmentList;
    }

    return [];
  }

  Future<List<Entertainment>> searchEntertainment(String needle) async {
    final data = await NounAPI.searchEntertainments(needle);
    entertainments = data;
    update();
    return data;
  }
}
