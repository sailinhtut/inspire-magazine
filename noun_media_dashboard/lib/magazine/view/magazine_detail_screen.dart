// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog_panel/magazine/model/magazine.dart';
import 'package:inspired_blog_panel/magazine/view/topic_detail_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class MagazineDetailScreen extends StatefulWidget {
  const MagazineDetailScreen({super.key, required this.magazine});

  final Magazine magazine;

  @override
  State<MagazineDetailScreen> createState() => _MagazineDetailScreenState();
}

class _MagazineDetailScreenState extends State<MagazineDetailScreen> {
  bool fetching = false;
  bool searching = false;

  String searchKey = "";

  @override
  void initState() {
    super.initState();
  }

  List<Topic> filterTopic(List<Topic> data) {
    if (searchKey.isEmpty) return data;
    return data
        .where((element) =>
            element.name!.toLowerCase().contains(searchKey.toLowerCase()) ||
            element.description!
                .toLowerCase()
                .contains(searchKey.toLowerCase()))
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

  Future<void> addTopic() async {
    await showDialog(
        context: context,
        builder: (_) {
          return Dialog(child: TopicCreatorBoard(magazine: widget.magazine));
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
                          isMobile
                              ? buildSearchBar()
                              : const Text("Topics", textScaleFactor: 1.3),
                          Row(
                            children: [
                              if (!isMobile) buildSearchBar(),
                              const SizedBox(width: 10),
                              isMobile
                                  ? IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: addTopic,
                                    )
                                  : ElevatedButton(
                                      onPressed: addTopic,
                                      child: const Text('Add Topic'),
                                    ),
                              const SizedBox(width: 10),
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
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Order')),
                          DataColumn(label: Text('Updated on')),
                          DataColumn(label: SizedBox(width: 50)),
                        ],
                        rows: [
                          ...filterTopic(widget.magazine.topics!).map(
                            (e) => DataRow(
                              onSelectChanged: (value) {
                                Get.to(() => TopicDetailScreen(
                                    magazine: widget.magazine, topic: e));
                              },
                              cells: [
                                DataCell(
                                  Text('${e.topiId}'),
                                ),
                                DataCell(Container(
                                  width: 35,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                        image: NetworkImage(e.coverPhoto!),
                                        fit: BoxFit.fill,
                                      )),
                                )),
                                DataCell(SizedBox(
                                    width: isMobile ? 100 : 200,
                                    child: Text(
                                      '${e.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                                DataCell(SizedBox(
                                    width: isMobile ? 100 : 300,
                                    child: Text(
                                      '${e.description}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                                DataCell(
                                  Text(e.order.toString()),
                                ),
                                DataCell(
                                  Text(e.updatedAt != null
                                      ? DateFormat("MMM dd yyyy")
                                          .format(e.updatedAt!)
                                      : ''),
                                ),
                                DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: PopupMenuButton(
                                    onSelected: (value) async {
                                      if (value == "edit") {
                                        await showDialog(
                                            context: context,
                                            builder: (_) {
                                              return Dialog(
                                                  child: TopicCreatorBoard(
                                                      editTopic: e,
                                                      magazine:
                                                          widget.magazine));
                                            });
                                        setState(() {});
                                      } else if (value == "delete") {
                                        showConfirmDialog(context,
                                            title: "Delete ${e.name}",
                                            content: "Are you sure to delete ?",
                                            buttonText: "Confirm",
                                            onConfirm: () async {
                                          Navigator.pop(context);
                                          final result =
                                              await NounAPI.deleteTopic(
                                                  e.topiId!);
                                          if (result) {
                                            toast("Successfully deleted");
                                            setState(() {
                                              widget.magazine.topics!
                                                  .removeWhere((element) =>
                                                      element.topiId ==
                                                      e.topiId);
                                            });
                                          }
                                        });
                                      }
                                    },
                                    color: context.surfaceColor,
                                    icon: const Icon(Icons.more_vert,
                                        color: Colors.black),
                                    itemBuilder: (_) {
                                      return [
                                        const PopupMenuItem(
                                          height: 30,
                                          value: "edit",
                                          child: Text(
                                            "Edit",
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          height: 30,
                                          value: "delete",
                                          child: Text("Delete",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
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
              Text(widget.magazine.name!,
                  style: context.textTheme.headlineSmall!),
            ],
          )
        ],
      ),
    );
  }
}

class TopicCreatorBoard extends StatefulWidget {
  const TopicCreatorBoard({super.key, required this.magazine, this.editTopic});

  final Magazine magazine;
  final Topic? editTopic;

  @override
  State<TopicCreatorBoard> createState() => TopicCreatorBoardState();
}

class TopicCreatorBoardState extends State<TopicCreatorBoard> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final orderController = TextEditingController();

  PlatformFile? coverPhoto;

  bool loading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  Future<void> initValues() async {
    if (widget.editTopic != null) {
      nameController.text = widget.editTopic!.name ?? '';
      descriptionController.text = widget.editTopic!.description ?? '';
      orderController.text = widget.editTopic!.order.toString();
      setState(() {});
    }else{
       orderController.text = "0";
    }
   
     
    
  }

  Future<void> submit() async {
    if (coverPhoto == null) {
      toast("Choose cover photo");
      return;
    }
    setState(() => loading = true);
    final created = await NounAPI.createTopic(
      magazineId: widget.magazine.magazineId,
      name: nameController.text,
      order: int.tryParse(orderController.text),
      description: descriptionController.text,
      coverPhoto: coverPhoto!,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (created != null) {
      widget.magazine.topics!.add(created);
      setState(() {});
    } else {
      toast("Cannot create topic");
    }

    setState(() => loading = true);
    Navigator.pop(context);
  }

  Future<void> edit() async {
    setState(() => loading = true);
    final updated = await NounAPI.updateTopic(
      widget.editTopic!.topiId!,
      magazineId: widget.magazine.magazineId,
      name: nameController.text,
      description: descriptionController.text,
      coverPhoto: coverPhoto,
      order: int.tryParse(orderController.text),
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (updated != null) {
      final index = widget.magazine.topics!.indexOf(widget.editTopic!);
      widget.magazine.topics!.removeAt(index);
      widget.magazine.topics!.insert(index, updated!);
    } else {
      toast("Cannot update topic");
    }
    setState(() => loading = true);
    Navigator.pop(context);
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
          SizedBox(
            height: 60,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
              title: Text(
                  widget.editTopic != null ? "Edit Topic" : "Create Topic",
                  textScaleFactor: 1.2),
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
                    if (coverPhoto != null ||
                        (widget.editTopic != null && widget.editTopic != null))
                      Container(
                        height: 230,
                        width: 130,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(7),
                            image: coverPhoto != null
                                ? DecorationImage(
                                    image: MemoryImage(coverPhoto!.bytes!),
                                    fit: BoxFit.fill,
                                  )
                                : widget.editTopic != null &&
                                        widget.editTopic!.coverPhoto != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            widget.editTopic!.coverPhoto!),
                                        fit: BoxFit.fill)
                                    : null),
                      ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(90, 35),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 7),
                        ),
                        onPressed: () async {
                          final picked = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.image,
                          );
                          if (picked != null) {
                            setState(() {
                              coverPhoto = picked.files.first;
                            });
                          }
                        },
                        child: const Text("Choose", textScaleFactor: 1)),
                    const SizedBox(height: 10),
                    const Text('Name'),
                    const SizedBox(height: 10),
                    TextInputWidget(
                      controller: nameController,
                      validate: (value) {
                        if (value != null && value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Poriority Order (Optional)'),
                    const SizedBox(height: 10),
                    TextInputWidget(
                      controller: orderController,
                      maxLines: null,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.newline,
                      validate: (value) {
                        if (value != null && int.tryParse(value) == null) {
                          return "Must be number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    const Text('Description'),
                    const SizedBox(height: 10),
                    TextInputWidget(
                      controller: descriptionController,
                      maxLines: null,
                      inputAction: TextInputAction.newline,
                      // validate: (value) {
                      //   if (value != null && value.isEmpty) {
                      //     return "This field is required";
                      //   }
                      //   return null;
                      // },
                    ),
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
                                  if (formKey.currentState!.validate()) {
                                    widget.editTopic != null
                                        ? edit()
                                        : submit();
                                  }
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : Text(
                                  widget.editTopic != null ? 'Save' : 'Create'),
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
