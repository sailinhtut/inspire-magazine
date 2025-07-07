// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_utils/src/extensions/context_extensions.dart';
// import 'package:inspired_blog_panel/blog/controller/blog_controller.dart';
// import 'package:inspired_blog_panel/blog/view/blog_add_screen.dart';
// import 'package:inspired_blog_panel/blog/view/preview_content_screen.dart';
// import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
// import 'package:inspired_blog_panel/shared/presentation/components/paginated_button.dart';
// import 'package:inspired_blog_panel/shared/presentation/components/side_bar.dart';
// import 'package:inspired_blog_panel/utils/functions.dart';
// import 'package:intl/intl.dart';

// class BlogListScreen extends StatefulWidget {
//   const BlogListScreen({super.key});

//   @override
//   State<BlogListScreen> createState() => _BlogListScreenState();
// }

// class _BlogListScreenState extends State<BlogListScreen> {
//   bool fetching = false;
//   bool searching = false;

//   @override
//   void initState() {
//     super.initState();
//     // BlogController.instance.getBlogs();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isMobile = context.mediaType == MediaTypes.mobile;

//     return GetBuilder<BlogController>(builder: (controller) {
//       return Scaffold(
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               _buildHeader(controller),
//               const SizedBox(height: 10),
//               Card(
//                 elevation: 3,
//                 child: SizedBox(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // table
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           showCheckboxColumn: false,
//                           columns: const [
//                             DataColumn(label: Text('No')),
//                             DataColumn(label: Text('Title')),
//                             DataColumn(label: Text('Description')),
//                             DataColumn(label: Text('Writer')),
//                             DataColumn(label: Text('Updated on')),
//                             DataColumn(label: SizedBox(width: 50)),
//                           ],
//                           rows: [
//                             ...controller.blogs.map(
//                               (e) => DataRow(
//                                 onSelectChanged: (value) {
//                                   Get.to(() => PreviewContentScreen(
//                                       contentTitle: e.name.toString(),
//                                       htmlContent: e.content.toString()));
//                                 },
//                                 cells: [
//                                   DataCell(
//                                     Text('${e.blogId}'),
//                                   ),
//                                   DataCell(SizedBox(
//                                       width: isMobile ? 100 : 200,
//                                       child: Text(
//                                         '${e.name}',
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ))),
//                                   DataCell(SizedBox(
//                                       width: isMobile ? 100 : 300,
//                                       child: Text(
//                                         '${e.description}',
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ))),
//                                   DataCell(SizedBox(
//                                       width: isMobile ? 100 : 200,
//                                       child: Text(
//                                         '${e.writer}',
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ))),
//                                   DataCell(
//                                     Text(e.updatedAt != null
//                                         ? DateFormat("MMM dd yyyy")
//                                             .format(e.updatedAt!)
//                                         : ''),
//                                   ),
//                                   DataCell(Align(
//                                     alignment: Alignment.centerRight,
//                                     child: PopupMenuButton(
//                                       onSelected: (value) {
//                                         if (value == "write") {
//                                           Get.to(
//                                               () => BlogAddScreen(editBlog: e));
//                                         } else if (value == "delete") {
//                                           showConfirmDialog(context,
//                                               title: "Confirm",
//                                               content:
//                                                   "Are you sure to delete ${e.name} ?",
//                                               buttonText: "Delete",
//                                               onConfirm: () async {
//                                             Navigator.pop(context);
//                                             // await BlogController.instance
//                                             //     .deleteBlog(e.blogId);
//                                           });
//                                         }
//                                       },
//                                       color: context.surfaceColor,
//                                       icon: const Icon(Icons.more_vert,
//                                           color: Colors.black),
//                                       itemBuilder: (_) {
//                                         return [
//                                           const PopupMenuItem(
//                                             height: 30,
//                                             value: "write",
//                                             child: Text("Write"),
//                                           ),
//                                           const PopupMenuItem(
//                                             height: 30,
//                                             value: "delete",
//                                             child: Text("Delete",
//                                                 style: TextStyle(
//                                                     color: Colors.red)),
//                                           ),
//                                         ];
//                                       },
//                                     ),
//                                   )),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),

//                       if (fetching)
//                         LinearProgressIndicator(
//                             color: context.primary, minHeight: 1.5),
//                       const SizedBox(height: 10),

//                       // paginate bar
//                       SizedBox(
//                         height: 40,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             if (controller.firstPage != 0 &&
//                                 controller.firstPage !=
//                                     controller.previousPage &&
//                                 controller.firstPage != controller.currentPage)
//                               PaginateButton(
//                                 controller.firstPage.toString(),
//                                 onPressed: () async {
//                                   setState(() => fetching = true);
//                                   // await controller.getBlogs(
//                                   //     page: controller.firstPage);
//                                   setState(() => fetching = false);
//                                 },
//                               ),
//                             if (controller.previousPage != 0 &&
//                                 controller.previousPage !=
//                                     controller.currentPage)
//                               PaginateButton(
//                                 controller.previousPage.toString(),
//                                 onPressed: () async {
//                                   setState(() => fetching = true);
//                                   // await controller.getBlogs(
//                                   //     page: controller.previousPage);
//                                   setState(() => fetching = false);
//                                 },
//                               ),
//                             PaginateButton(
//                               controller.currentPage.toString(),
//                               onPressed: () async {
//                                 setState(() => fetching = true);
//                                 // await controller.getBlogs(
//                                 //     page: controller.currentPage);
//                                 setState(() => fetching = false);
//                               },
//                               active: true,
//                             ),
//                             if (controller.nextPage != 0 &&
//                                 controller.nextPage != controller.currentPage)
//                               PaginateButton(
//                                 controller.nextPage.toString(),
//                                 onPressed: () async {
//                                   setState(() => fetching = true);
//                                   // await controller.getBlogs(
//                                   //     page: controller.nextPage);
//                                   setState(() => fetching = false);
//                                 },
//                               ),
//                             if (controller.lastPage != 0 &&
//                                 controller.lastPage != controller.nextPage &&
//                                 controller.lastPage != controller.currentPage)
//                               PaginateButton(
//                                 controller.lastPage.toString(),
//                                 onPressed: () async {
//                                   setState(() => fetching = true);
//                                   // await controller.getBlogs(
//                                   //     page: controller.lastPage);
//                                   setState(() => fetching = false);
//                                 },
//                               ),
//                             const SizedBox(width: 50),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildHeader(BlogController controller) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("Blogs", style: context.textTheme.headlineSmall!),
//           Row(
//             children: [
//               SizedBox(
//                 width: 200,
//                 height: 33,
//                 child: TextInputWidget(
//                   hint: "Search",
//                   inputAction: TextInputAction.done,
//                   onSubmitted: (value) async {
//                     setState(() => searching = true);
//                     if (value!.isEmpty) {
//                       // await controller.getBlogs(page: controller.currentPage);
//                     } else {
//                       // await controller.searchBlogs(value);
//                     }
//                     setState(() => searching = false);
//                   },
//                 ),
//               ),
//               const SizedBox(width: 10),
//               searching
//                   ? Transform.scale(
//                       scale: 0.8, child: const CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: () {
//                         Get.to(() => const BlogAddScreen());
//                       },
//                       child: const Text('Write Post'),
//                     ),
//               const SizedBox(width: 10),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
