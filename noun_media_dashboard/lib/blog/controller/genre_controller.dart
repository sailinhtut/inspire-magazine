import 'package:get/get.dart';
import 'package:inspired_blog_panel/blog/model/genre.dart';

class GenreController extends GetxController {
  static GenreController get instance => Get.find<GenreController>();

  List<Genre> genres = [];
  int currentPage = 1;
  int previousPage = 0;
  int nextPage = 0;
  int lastPage = 0;
  int firstPage = 0;

  // Future<List<Genre>> getGenres({int? page}) async {
  //   final data = await NounAPI.getGenres(page ?? currentPage);
  //   if (data.isNotEmpty) {
  //     // blogs
  //     final genreList = List<dynamic>.from(data["data"])
  //         .map((e) => Genre.fromJson(e))
  //         .toList();
  //     genres = genreList;

  //     // paginate
  //     currentPage = data["current_page"];
  //     previousPage = data["prev_page_url"] != null
  //         ? int.parse(data["prev_page_url"].toString().split("=").last)
  //         : 0;
  //     nextPage = data["next_page_url"] != null
  //         ? int.parse(data["next_page_url"].toString().split("=").last)
  //         : 0;
  //     lastPage = data["last_page_url"] != null
  //         ? int.parse(data["last_page_url"].toString().split("=").last)
  //         : 0;
  //     firstPage = data["first_page_url"] != null
  //         ? int.parse(data["first_page_url"].toString().split("=").last)
  //         : 0;

  //     update();
  //     return genreList;
  //   }

  //   return [];
  // }

  // Future<List<Genre>> searchGenre(String needle) async {
  //   final data = await NounAPI.searchGenre(needle);
  //   genres = data;
  //   update();
  //   return data;
  // }

  // Future<void> addGenre(Genre genreModel) async {
  //   final created = await NounAPI.addGenre(genreModel);
  //   if (created != null) {
  //     genres.add(created);
  //     update();
  //   }
  // }

  // Future<void> updateGenre(Genre genreModel) async {
  //   final updated = await NounAPI.updateGenre(genreModel);
  //   if (updated != null) {
  //     update();
  //   }
  // }

  // Future<void> deleteGenre(int genreId) async {
  //   final deleted = await NounAPI.deleteGenre(genreId);
  //   if (deleted) {
  //     genres.removeWhere((element) => element.genreId == genreId);
  //     update();
  //   }
  // }
}
