// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/advertisement/controller/advertisement_controller.dart';
import 'package:inspired_blog_panel/advertisement/model/advertisement.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/meta_data/controller/meta_data_controller.dart';
import 'package:inspired_blog_panel/meta_data/model/meta_data.dart';
import 'package:inspired_blog_panel/meta_data/view/meta_edit_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/components/paginated_button.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class MetaDataListScreen extends StatefulWidget {
  const MetaDataListScreen({super.key});

  @override
  State<MetaDataListScreen> createState() => _MetaDataListScreenState();
}

class _MetaDataListScreenState extends State<MetaDataListScreen> {
  bool fetching = false;
  bool loading = false;
  String searchKey = "";

  @override
  void initState() {
    super.initState();
    MetaDataController.instance.getMetaData();
  }

  List<NounMetaData> filterNounMetaData(List<NounMetaData> data) {
    if (searchKey.isEmpty) return data;
    return data
        .where((element) =>
            element.name!.toLowerCase().contains(searchKey.toLowerCase()))
        .toList();
  }

  Widget buildSearchBar() {
    return Row(
      children: [
        SizedBox(
          width: 200,
          height: 33,
          child: TextInputWidget(
            hint: "Search",
            inputAction: TextInputAction.done,
            onChanged: (value) async {
              setState(() => searchKey = value!);
            },
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  // Future<void> addAdvertisement() async {

  // }

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.mediaType == MediaTypes.mobile;

    return GetBuilder<MetaDataController>(builder: (controller) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() => loading = true);
            await MetaDataController.instance.getMetaData();
            setState(() => loading = false);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isMobile ? buildSearchBar() : const SizedBox(),
                              Row(
                                children: [
                                  // if (!isMobile) buildSearchBar(),
                                  // const SizedBox(width: 10),
                                  // isMobile
                                  //     ? IconButton(
                                  //         onPressed: addAdvertisement,
                                  //         icon: const Icon(Icons.add),
                                  //       )
                                  //     : ElevatedButton(
                                  //         onPressed: addAdvertisement,
                                  //         child: const Text('Add'),
                                  //       ),
                                  loading
                                      ? Transform.scale(
                                          scale: 0.7,
                                          child:
                                              const CircularProgressIndicator(),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            setState(() => loading = true);
                                            await MetaDataController.instance
                                                .getMetaData();
                                            setState(() => loading = false);
                                          },
                                          icon: const Icon(Icons.refresh),
                                        )
                                ],
                              )
                            ],
                          ),
                        ),
                        // table
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Content')),
                              DataColumn(label: Text('Updated on')),
                              // DataColumn(label: SizedBox(width: 50)),
                            ],
                            rows: [
                              ...filterNounMetaData(controller.metaData).map(
                                (e) => DataRow(
                                  onSelectChanged: (value) async {
                                    await Get.to(() => MetaEditScreen(meta: e));
                                    setState(() {});
                                  },
                                  cells: [
                                    DataCell(
                                      Text('${e.id}'),
                                    ),
                                    DataCell(SizedBox(
                                        width: 100,
                                        child: Text(
                                          '${e.name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                    DataCell(SizedBox(
                                        width: isMobile ? 100 : 300,
                                        child: Text(
                                          '${e.content}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                    DataCell(
                                      Text(e.updatedAt != null
                                          ? DateFormat("MMM dd yyyy")
                                              .format(e.updatedAt!)
                                          : ''),
                                    ),
                                    // DataCell(Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: PopupMenuButton(
                                    //     onSelected: (value) async {
                                    //       if (value == "edit") {
                                    //       } else if (value == "delete") {
                                    //         showConfirmDialog(context,
                                    //             title: "Delete ${e.name}",
                                    //             content:
                                    //                 "Are you sure to delete ?",
                                    //             buttonText: "Confirm",
                                    //             onConfirm: () async {
                                    //           Navigator.pop(context);
                                    //           final result =
                                    //               await NounAPI.deleteMetaData(
                                    //                   e.name!);
                                    //           if (result) {
                                    //             toast("Successfully deleted");
                                    //             setState(() {
                                    //               controller.metaData.removeWhere(
                                    //                   (element) =>
                                    //                       element.name == e.name);
                                    //             });
                                    //           }
                                    //         });
                                    //       }
                                    //     },
                                    //     color: context.surfaceColor,
                                    //     icon: const Icon(Icons.more_vert,
                                    //         color: Colors.black),
                                    //     itemBuilder: (_) {
                                    //       return [
                                    //         const PopupMenuItem(
                                    //           height: 30,
                                    //           value: "edit",
                                    //           child: Text(
                                    //             "Edit",
                                    //           ),
                                    //         ),
                                    //         const PopupMenuItem(
                                    //           height: 30,
                                    //           value: "delete",
                                    //           child: Text("Delete",
                                    //               style: TextStyle(
                                    //                   color: Colors.red)),
                                    //         ),
                                    //       ];
                                    //     },
                                    //   ),
                                    // )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Documents", style: context.textTheme.headlineSmall!),
        ],
      ),
    );
  }
}
