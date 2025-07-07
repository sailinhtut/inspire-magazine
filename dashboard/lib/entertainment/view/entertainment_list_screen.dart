// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog_panel/entertainment/model/entertainment.dart';
import 'package:inspired_blog_panel/entertainment/view/entertainment_detail_screen.dart';
import 'package:inspired_blog_panel/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/components/paginated_button.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class EntertainmentListScreen extends StatefulWidget {
  const EntertainmentListScreen({super.key});

  @override
  State<EntertainmentListScreen> createState() =>
      _EntertainmentListScreenState();
}

class _EntertainmentListScreenState extends State<EntertainmentListScreen> {
  bool fetching = false;
  bool searching = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    EntertainmentController.instance.getEntertainments();
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
            onSubmitted: (value) async {
              setState(() => searching = true);
              if (value!.isEmpty) {
                await EntertainmentController.instance.getEntertainments(
                    page: EntertainmentController.instance.currentPage);
              } else {
                await EntertainmentController.instance
                    .searchEntertainment(value);
              }
              setState(() => searching = false);
            },
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Future<void> addMagazine() async {
    await showDialog(
        context: context,
        builder: (_) {
          return const Dialog(child: EntertainmentCreator());
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.mediaType == MediaTypes.mobile;

    return GetBuilder<EntertainmentController>(builder: (controller) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() => loading = true);
            await EntertainmentController.instance
                .getEntertainments(force: true);
            setState(() => loading = false);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const AlwaysScrollableScrollPhysics(),
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
                                  if (!isMobile) buildSearchBar(),
                                  const SizedBox(width: 5),
                                  isMobile
                                      ? IconButton(
                                          onPressed: addMagazine,
                                          icon: const Icon(Icons.add),
                                        )
                                      : ElevatedButton(
                                          onPressed: addMagazine,
                                          child: const Text('Add'),
                                        ),
                                  const SizedBox(width: 5),
                                  loading
                                      ? Transform.scale(
                                          scale: 0.7,
                                          child:
                                              const CircularProgressIndicator(),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            setState(() => loading = true);
                                            await EntertainmentController
                                                .instance
                                                .getEntertainments(force: true);
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
                              DataColumn(label: Text('Image')),
                              DataColumn(label: Text('Title')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Order')),
                              DataColumn(label: Text('Updated on')),
                              DataColumn(label: SizedBox(width: 50)),
                            ],
                            rows: [
                              ...controller.entertainments.map(
                                (e) => DataRow(
                                  onSelectChanged: (value) {
                                    Get.to(() => EntertainmentDetailScreen(
                                        entertainment: e));
                                  },
                                  cells: [
                                    DataCell(
                                      Text('${e.id}'),
                                    ),
                                    DataCell(Container(
                                      width: 35,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          image: DecorationImage(
                                            image: NetworkImage(e.coverPhoto!),
                                            fit: BoxFit.fill,
                                          )),
                                    )),
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
                                                      child:
                                                          EntertainmentCreator(
                                                    editEntertainment: e,
                                                  ));
                                                });
                                            setState(() {});
                                          } else if (value == "delete") {
                                            showConfirmDialog(context,
                                                title: "Delete ${e.name}",
                                                content:
                                                    "Are you sure to delete ?",
                                                buttonText: "Confirm",
                                                onConfirm: () async {
                                              Navigator.pop(context);
                                              final result = await NounAPI
                                                  .deleteEntertainment(e.id!);
                                              if (result) {
                                                toast("Successfully deleted");
                                                setState(() {
                                                  controller.entertainments
                                                      .removeWhere((element) =>
                                                          element.id == e.id);
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
                                                  style: TextStyle(
                                                      color: Colors.red)),
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

                        if (fetching)
                          LinearProgressIndicator(
                              color: context.primary, minHeight: 1.5),
                        const SizedBox(height: 10),

                        // paginate bar
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (controller.firstPage != 0 &&
                                  controller.firstPage !=
                                      controller.previousPage &&
                                  controller.firstPage !=
                                      controller.currentPage)
                                PaginateButton(
                                  controller.firstPage.toString(),
                                  onPressed: () async {
                                    setState(() => fetching = true);
                                    await controller.getEntertainments(
                                        page: controller.firstPage);
                                    setState(() => fetching = false);
                                  },
                                ),
                              if (controller.previousPage != 0 &&
                                  controller.previousPage !=
                                      controller.currentPage)
                                PaginateButton(
                                  controller.previousPage.toString(),
                                  onPressed: () async {
                                    setState(() => fetching = true);
                                    await controller.getEntertainments(
                                        page: controller.previousPage);
                                    setState(() => fetching = false);
                                  },
                                ),
                              PaginateButton(
                                controller.currentPage.toString(),
                                onPressed: () async {
                                  setState(() => fetching = true);
                                  await controller.getEntertainments(
                                      page: controller.currentPage);
                                  setState(() => fetching = false);
                                },
                                active: true,
                              ),
                              if (controller.nextPage != 0 &&
                                  controller.nextPage != controller.currentPage)
                                PaginateButton(
                                  controller.nextPage.toString(),
                                  onPressed: () async {
                                    setState(() => fetching = true);
                                    await controller.getEntertainments(
                                        page: controller.nextPage);
                                    setState(() => fetching = false);
                                  },
                                ),
                              if (controller.lastPage != 0 &&
                                  controller.lastPage != controller.nextPage &&
                                  controller.lastPage != controller.currentPage)
                                PaginateButton(
                                  controller.lastPage.toString(),
                                  onPressed: () async {
                                    setState(() => fetching = true);
                                    await controller.getEntertainments(
                                        page: controller.lastPage);
                                    setState(() => fetching = false);
                                  },
                                ),
                              const SizedBox(width: 50),
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
          Text("Entertainments", style: context.textTheme.headlineSmall!),
        ],
      ),
    );
  }
}

class EntertainmentCreator extends StatefulWidget {
  const EntertainmentCreator({super.key, this.editEntertainment});

  final Entertainment? editEntertainment;

  @override
  State<EntertainmentCreator> createState() => EntertainmentCreatorState();
}

class EntertainmentCreatorState extends State<EntertainmentCreator> {
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
    if (widget.editEntertainment != null) {
      nameController.text = widget.editEntertainment!.name ?? '';
      descriptionController.text = widget.editEntertainment!.description ?? '';
      orderController.text = widget.editEntertainment!.order.toString();
      setState(() {});
    } else {
      orderController.text = "0";
    }
  }

  Future<void> submit() async {
    if (coverPhoto == null) {
      toast("Choose cover photo");
      return;
    }

    setState(() => loading = true);
    final created = await NounAPI.createEntertainment(
      name: nameController.text,
      description: descriptionController.text,
      coverPhoto: coverPhoto!,
      order: int.tryParse(orderController.text),
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (created != null) {
      EntertainmentController.instance.entertainments.add(created);
      EntertainmentController.instance.update();
      setState(() {});
      toast("Successfully Created");
    } else {
      toast("Cannot create entertainment");
    }

    setState(() {
      loading = false;
      progress = 0;
    });
    Navigator.pop(context);
  }

  Future<void> edit() async {
    setState(() => loading = true);
    final updated = await NounAPI.updateEntertainment(
      widget.editEntertainment!.id!,
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
      final index = EntertainmentController.instance.entertainments
          .indexOf(widget.editEntertainment!);
      EntertainmentController.instance.entertainments.removeAt(index);
      EntertainmentController.instance.entertainments.insert(index, updated);
      EntertainmentController.instance.update();
      toast("Successfully Updated");
    } else {
      toast("Cannot update entertainment");
    }
    setState(() {
      loading = false;
      progress = 0;
    });
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
                  widget.editEntertainment != null
                      ? "Edit Entertainmet"
                      : "Create Entertainment",
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
                        (widget.editEntertainment != null &&
                            widget.editEntertainment?.coverPhoto != null))
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
                                : widget.editEntertainment != null &&
                                        widget.editEntertainment!.coverPhoto !=
                                            null
                                    ? DecorationImage(
                                        image: NetworkImage(widget
                                            .editEntertainment!.coverPhoto!),
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
                            setState(() => coverPhoto = picked.files.first);
                          }
                        },
                        child: const Text("Choose Cover Photo",
                            textScaleFactor: 1)),
                    const SizedBox(height: 10),
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
                                    widget.editEntertainment != null
                                        ? edit()
                                        : submit();
                                  }
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : Text(widget.editEntertainment != null
                                  ? 'Save'
                                  : 'Create'),
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
