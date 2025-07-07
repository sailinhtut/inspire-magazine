import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/blog/model/blog.dart';

class BlogController extends GetxController {
  static BlogController get instance => Get.find<BlogController>();

  List<Blog> blogs = [];
  int currentPage = 1;
  int previousPage = 0;
  int nextPage = 0;
  int lastPage = 0;
  int firstPage = 0;

  // Future<List<Blog>> getBlogs({int? page}) async {
  //   final data = await NounAPI.getBlogs(page ?? currentPage);
  //   if (data.isNotEmpty) {
  //     // blogs
  //     final blogList = List<dynamic>.from(data["data"])
  //         .map((e) => Blog.fromJson(e))
  //         .toList();
  //     blogs = blogList;

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
  //     return blogList;
  //   }

  //   return [];
  // }

  // Future<List<Blog>> searchBlogs(String needle) async {
  //   final data = await NounAPI.searchBlogs(needle);
  //   blogs = data;
  //   update();
  //   return data;
  // }

  // Future<Blog?> addBlog(Blog blogModel) async {
  //   final created = await NounAPI.addBlog(blogModel);
  //   if (created != null) {
  //     blogs.add(created);
  //     update();
  //   }
  //   return created;
  // }

  // Future<Blog?> updateBlog(Blog blogModel) async {
  //   final updated = await NounAPI.updateBlog(blogModel);
  //   if (updated != null) {
  //     update();
  //   }
  //   return updated;
  // }

  // Future<void> deleteBlog(int blogId) async {
  //   final deleted = await NounAPI.deleteBlog(blogId);
  //   if (deleted) {
  //     blogs.removeWhere((element) => element.blogId == blogId);
  //     update();
  //   }
  // }
}
