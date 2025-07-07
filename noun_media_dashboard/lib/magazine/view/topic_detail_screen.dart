// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/magazine/model/magazine.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/utils/functions.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen(
      {super.key, required this.magazine, required this.topic});

  final Magazine magazine;
  final Topic topic;

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  String searchKey = "";

  List<String> selectedPhotos = [];

  @override
  void initState() {
    super.initState();
  }

  List<String> filterTopic(List<String> data) {
    if (searchKey.isEmpty) return data;
    return data
        .where((element) =>
            element.toLowerCase().contains(searchKey.toLowerCase()))
        .toList();
  }

  Widget buildSearchBar() {
    return SizedBox(
      width: 200,
      height: 33,
      child: TextInputWidget(
        hint: "Search",
        inputAction: TextInputAction.done,
        onChanged: (value) async {
          setState(() => searchKey = value!);
        },
      ),
    );
  }

  Widget buildSelectedCounter() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12)),
        child: Text(
          selectedPhotos.length.toString(),
          style: const TextStyle(color: Colors.white),
          textScaleFactor: 0.9,
        ),
      ),
    );
  }

  Future<void> addPhotos() async {
    await showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              child: ContentPhotoCreator(
                  topic: widget.topic, magazine: widget.magazine));
        });
    setState(() {});
  }

  Future<void> removePhotos() async {
    showConfirmDialog(context,
        title: "Delete Content",
        content:
            "Are you sure to delete this photos ${selectedPhotos.map((e) => e.split("/").last).join(",")}",
        buttonText: "Delete", onConfirm: () async {
      Navigator.pop(context);
      final result = await NounAPI.removeContentPhotos(
          widget.topic.topiId!, selectedPhotos);
      if (result) {
        widget.topic.photos!
            .removeWhere((element) => selectedPhotos.contains(element));
        selectedPhotos.clear();
        setState(() {});
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.mediaType == MediaTypes.mobile;

    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 30),
      child: Column(
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
                        Row(
                          children: [
                            isMobile
                                ? buildSearchBar()
                                : const Text("Content Photo",
                                    textScaleFactor: 1.3),
                            const SizedBox(width: 10),
                            if (!isMobile) buildSelectedCounter(),
                          ],
                        ),
                        Row(
                          children: [
                            if (!isMobile) buildSearchBar(),
                            const SizedBox(width: 10),
                            isMobile
                                ? IconButton(
                                    onPressed: addPhotos,
                                    icon: const Icon(Icons.add),
                                  )
                                : ElevatedButton(
                                    onPressed: addPhotos,
                                    child: const Text('Add'),
                                  ),
                            const SizedBox(width: 10),
                            selectedPhotos.isNotEmpty
                                ? isMobile
                                    ? IconButton(
                                        onPressed: removePhotos,
                                        icon: const Icon(Icons.delete),
                                      )
                                    : ElevatedButton(
                                        onPressed: removePhotos,
                                        child: const Text('Remove'),
                                      )
                                : const SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                  // table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Image')),
                        DataColumn(label: Text('Title')),
                        DataColumn(label: SizedBox(width: 50)),
                      ],
                      rows: [
                        ...filterTopic(widget.topic.photos!).map(
                          (e) => DataRow(
                            onSelectChanged: (value) {
                              if (value!) {
                                selectedPhotos.add(e);
                              } else {
                                selectedPhotos.remove(e);
                              }
                              setState(() {});
                            },
                            selected: selectedPhotos.contains(e),
                            cells: [
                              DataCell(
                                Text(e.split("/").last.split(".").first),
                              ),
                              DataCell(Container(
                                width: 35,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: NetworkImage(e),
                                      fit: BoxFit.fill,
                                    )),
                              )),
                              DataCell(SizedBox(
                                  width: isMobile ? 100 : 500,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      IconButton(
                                        onPressed: () {
                                          Clipboard.setData(
                                              ClipboardData(text: e));
                                          toast("Copied to clipboard");
                                        },
                                        iconSize: 20,
                                        icon: const Icon(Icons.copy),
                                      )
                                    ],
                                  ))),
                              DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: PopupMenuButton(
                                  onSelected: (value) async {
                                    if (value == "edit") {
                                      setState(() {});
                                    } else if (value == "delete") {
                                      // showConfirmDialog(context,
                                      //     title: "Delete ${e.name}",
                                      //     content: "Are you sure to delete ?",
                                      //     buttonText: "Confirm",
                                      //     onConfirm: () async {
                                      //   Navigator.pop(context);
                                      //   final result =
                                      //       await NounAPI.deleteTopic(
                                      //           e.topiId!);
                                      //   if (result) {
                                      //     toast("Successfully deleted");
                                      //     setState(() {
                                      //       widget.magazine.topics!.removeWhere(
                                      //           (element) =>
                                      //               element.topiId == e.topiId);
                                      //     });
                                      //   }
                                      // });
                                    }
                                  },
                                  color: context.surfaceColor,
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.black),
                                  itemBuilder: (_) {
                                    return [
                                      // const PopupMenuItem(
                                      //   height: 30,
                                      //   value: "edit",
                                      //   child: Text(
                                      //     "Edit",
                                      //   ),
                                      // ),
                                      // const PopupMenuItem(
                                      //   height: 30,
                                      //   value: "delete",
                                      //   child: Text("Delete",
                                      //       style:
                                      //           TextStyle(color: Colors.red)),
                                      // ),
                                    ];
                                  },
                                ),
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const BackButton(),
              Text(widget.topic.name!, style: context.textTheme.headlineSmall!),
            ],
          )
        ],
      ),
    );
  }
}

class ContentPhotoCreator extends StatefulWidget {
  const ContentPhotoCreator(
      {super.key, required this.magazine, required this.topic});

  final Magazine magazine;
  final Topic topic;

  @override 
  State<ContentPhotoCreator> createState() => ContentPhotoCreatorState();
}

class ContentPhotoCreatorState extends State<ContentPhotoCreator> {
  final formKey = GlobalKey<FormState>();

  List<PlatformFile> contentPhotos = [];

  bool loading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> submit() async {
    setState(() => loading = true);
    final created = await NounAPI.addContentPhotos(
      widget.topic.topiId!,
      contentPhotos,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (created.isNotEmpty) {
      widget.topic.photos = created;
      setState(() {});
      Navigator.pop(context);
    } else {
      toast("Cannot create topic");
    }

    setState(() {
      loading = false;
      progress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final reslovedWidth = screen.width < 400 ? 380 : 500;
    return Container(
      width: reslovedWidth.toDouble(),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 60,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 13),
              title: Text("Add Content Photo", textScaleFactor: 1.2),
            ),
          ),
          if (progress > 0)
            LinearProgressIndicator(
              value: progress,
              minHeight: 2,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ...contentPhotos.map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 180,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: MemoryImage(e.bytes!),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                      const SizedBox(height: 10),
                                      Tooltip(
                                        message: e.name,
                                        child: SizedBox(
                                          width: 120,
                                          child: Text(e.name,
                                              overflow: TextOverflow.ellipsis,
                                              textScaleFactor: 1,
                                              maxLines: 1),
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          contentPhotos.remove(e);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(90, 35),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 7),
                        ),
                        onPressed: () async {
                          final picked = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.image,
                          );
                          if (picked != null) {
                            // final fileName = picked.files.first.name;
                            // final fileDataBytes = picked.files.first.bytes;

                            setState(() {
                              contentPhotos.addAll(picked.files);
                            });
                          }
                        },
                        child: const Text("Choose", textScaleFactor: 1)),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(100, 43),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 43),
                          ),
                          onPressed: loading
                              ? null
                              : () {
                                  submit();
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : const Text('Add'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
