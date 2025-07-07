import 'package:get/get.dart';
import 'package:inspired_blog/api/noun_api.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';

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
      {int? page, bool append = false}) async {
    if (currentPage == lastPage && page != 1) {
      return [];
    }

    final data = await NounAPI.getEntertainments(page ?? currentPage);

    if (data is List) {
      // entertainment
      final fetched = List<dynamic>.from(data)
          .map((e) => Entertainment.fromJson(e))
          .toList();

      if (append) {
        entertainments.addAll(fetched);
        entertainments = entertainments.toSet().toList();
      } else {
        entertainments = fetched;
      }
      update();
      return fetched;
    }

    if (data.isNotEmpty) {
      // entertainments
      final blogList = List<dynamic>.from(data["data"])
          .map((e) => Entertainment.fromJson(e))
          .toList();

      if (append) {
        entertainments.addAll(blogList);
        entertainments = entertainments.toSet().toList();
      } else {
        entertainments = blogList;
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

  Future<List<Entertainment>> searchMagazine(String needle) async {
    final data = await NounAPI.searchEntertainments(needle);
    entertainments = data;
    update();
    return data;
  }

  Future<Entertainment?> getEntertainmentDetails(int entertainmentId) async {
    final result = await NounAPI.getEntertainment(entertainmentId);

    if (result != null) {
      final index =
          entertainments.indexWhere((element) => element.id == entertainmentId);
      entertainments.removeWhere((element) => element.id == entertainmentId);
      entertainments.insert(index, result); // replace with full detailed model
      update();
      return result;
    }

    return result;
  }
}
