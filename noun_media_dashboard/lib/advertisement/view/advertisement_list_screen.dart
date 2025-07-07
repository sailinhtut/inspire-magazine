// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/advertisement/controller/advertisement_controller.dart';
import 'package:inspired_blog_panel/advertisement/model/advertisement.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/components/paginated_button.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class AdvertisementListScreen extends StatefulWidget {
  const AdvertisementListScreen({super.key});

  @override
  State<AdvertisementListScreen> createState() =>
      _AdvertisementListScreenState();
}

class _AdvertisementListScreenState extends State<AdvertisementListScreen> {
  bool fetching = false;
  bool loading = false;
  String searchKey = "";

  @override
  void initState() {
    super.initState();
    AdvertisementController.instance.getAdvertisements();
  }

  List<Advertisement> filterAdvertisement(List<Advertisement> data) {
    if (searchKey.isEmpty) return data;
    return data
        .where((element) =>
            element.name!.toLowerCase().contains(searchKey.toLowerCase()) ||
            element.redirect!.toLowerCase().contains(searchKey.toLowerCase()))
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

  Future<void> addAdvertisement() async {
    await showDialog(
        context: context,
        builder: (_) {
          return const Dialog(child: AdvertisementCreator());
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.mediaType == MediaTypes.mobile;

    return GetBuilder<AdvertisementController>(builder: (controller) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() => loading = true);
            await AdvertisementController.instance.getAdvertisements();
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
                              // isMobile ? buildSearchBar() : const SizedBox(),
                              const SizedBox(),
                              Row(
                                children: [
                                  // if (!isMobile) buildSearchBar(),
                                  const SizedBox(width: 10),
                                  isMobile
                                      ? IconButton(
                                          onPressed: addAdvertisement,
                                          icon: const Icon(Icons.add),
                                        )
                                      : ElevatedButton(
                                          onPressed: addAdvertisement,
                                          child: const Text('Add'),
                                        ),
                                  loading
                                      ? Transform.scale(
                                          scale: 0.7,
                                          child:
                                              const CircularProgressIndicator(),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            setState(() => loading = true);
                                            await AdvertisementController
                                                .instance
                                                .getAdvertisements();
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
                              // DataColumn(label: Text('Name')),
                              // DataColumn(label: Text('Redirect')),
                              DataColumn(label: Text('Type')),
                              // DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Created on')),
                              DataColumn(label: SizedBox(width: 50)),
                            ],
                            rows: [
                              ...filterAdvertisement(controller.advertisements)
                                  .map(
                                (e) => DataRow(
                                  onSelectChanged: (value) {
                                    Get.dialog(
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Center(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height: 500,
                                                      width: 350,
                                                      child: Image.network(
                                                          e.imageUrl!)),
                                                  const SizedBox(height: 20),
                                                  if (e.name != null)
                                                    Text(e.name!,
                                                        textScaleFactor: 2.0),
                                                  const SizedBox(height: 10),
                                                  if (e.description != null)
                                                    Text(e.description!),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      transitionCurve: Curves.bounceInOut,
                                    );
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
                                            image: NetworkImage(e.imageUrl!),
                                            fit: BoxFit.fill,
                                          )),
                                    )),
                                    // DataCell(SizedBox(
                                    //     width: 100,
                                    //     child: Text(
                                    //       '${e.name}',
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ))),
                                    // DataCell(Tooltip(
                                    //   message: e.redirect,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       Clipboard.setData(
                                    //           ClipboardData(text: e.redirect));
                                    //       toast("Copied to clipboard");
                                    //     },
                                    //     child: SizedBox(
                                    //         width: 100,
                                    //         child: Text(
                                    //           '${e.redirect}',
                                    //           maxLines: 1,
                                    //           overflow: TextOverflow.ellipsis,
                                    //         )),
                                    //   ),
                                    // )),
                                    DataCell(SizedBox(
                                        width: 100,
                                        child: Text(
                                          '${e.adsType!.name.capitalizeFirst}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                    // DataCell(SizedBox(
                                    //     width: isMobile ? 100 : 300,
                                    //     child: Text(
                                    //       '${e.description}',
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ))),
                                    DataCell(
                                      Text(e.updatedAt != null
                                          ? DateFormat("MMM dd yyyy")
                                              .format(e.createdAt!)
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
                                                          AdvertisementCreator(
                                                              editAdvertisement:
                                                                  e));
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
                                                  .deleteAdvertisement(e.id!);
                                              if (result) {
                                                toast("Successfully deleted");
                                                setState(() {
                                                  controller.advertisements
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
          Text("Advertisements", style: context.textTheme.headlineSmall!),
        ],
      ),
    );
  }
}

class AdvertisementCreator extends StatefulWidget {
  const AdvertisementCreator({super.key, this.editAdvertisement});

  final Advertisement? editAdvertisement;

  @override
  State<AdvertisementCreator> createState() => AdvertisementCreatorState();
}

class AdvertisementCreatorState extends State<AdvertisementCreator> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final redirectController = TextEditingController();
  AdsTypes adsType = AdsTypes.magazine;

  PlatformFile? image;

  bool loading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  Future<void> initValues() async {
    if (widget.editAdvertisement != null) {
      nameController.text = widget.editAdvertisement!.name ?? '';
      descriptionController.text = widget.editAdvertisement!.description ?? '';
      redirectController.text = widget.editAdvertisement!.redirect ?? '';
      adsType = widget.editAdvertisement!.adsType ?? AdsTypes.magazine;
      setState(() {});
    }
  }

  Future<void> submit() async {
    if (image == null) {
      toast("Choose image ");
      return;
    }

    setState(() => loading = true);
    final created = await NounAPI.createAdvertisement(
      name: nameController.text,
      description: descriptionController.text,
      redirect: redirectController.text.isEmpty
          ? "https://google.com"
          : redirectController.text,
      adsType: adsType,
      image: image!,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (created != null) {
      AdvertisementController.instance.advertisements.add(created);
      setState(() {});
      toast("Successfully Created");
    } else {
      toast("Cannot create advertisements");
    }

    setState(() {
      loading = false;
      progress = 0;
    });
    Navigator.pop(context);
  }

  Future<void> edit() async {
    setState(() => loading = true);
    final updated = await NounAPI.updateAdvertisement(
      widget.editAdvertisement!.id!,
      name: nameController.text,
      description: descriptionController.text,
      redirect: redirectController.text.isEmpty
          ? "https://google.com"
          : redirectController.text,
      adsType: adsType,
      image: image,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (updated != null) {
      final index = AdvertisementController.instance.advertisements
          .indexWhere((element) => element.id == updated.id);
      AdvertisementController.instance.advertisements.removeAt(index);
      AdvertisementController.instance.advertisements.insert(index, updated);
      toast("Successfully Updated");
    } else {
      toast("Cannot update advertisement");
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
                  widget.editAdvertisement != null
                      ? "Edit Advertisement"
                      : "Create Advertisement",
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
                    if (image != null ||
                        (widget.editAdvertisement != null &&
                            widget.editAdvertisement?.imageUrl != null))
                      Container(
                        height: 230,
                        width: 130,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(7),
                            image: image != null
                                ? DecorationImage(
                                    image: MemoryImage(image!.bytes!),
                                    fit: BoxFit.fill,
                                  )
                                : widget.editAdvertisement != null &&
                                        widget.editAdvertisement!.imageUrl !=
                                            null
                                    ? DecorationImage(
                                        image: NetworkImage(widget
                                            .editAdvertisement!.imageUrl!),
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
                            setState(() => image = picked.files.first);
                          }
                        },
                        child: const Text("Choose Advertisement Photo",
                            textScaleFactor: 1)),
                    const SizedBox(height: 10),
                    // const SizedBox(height: 10),
                    // const Text('Name'),
                    // const SizedBox(height: 10),
                    // TextInputWidget(
                    //   controller: nameController,
                    //   validate: (value) {
                    //     if (value != null && value.isEmpty) {
                    //       return "This field is required";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: const Text("Advertisement Type",
                            textScaleFactor: 0.9),
                        trailing: PopupMenuButton(
                          child: Text(adsType.name.capitalizeFirst!,
                              style: TextStyle(
                                  color: context.primary,
                                  fontWeight: FontWeight.bold)),
                          onSelected: (value) {
                            setState(() => adsType = value);
                          },
                          itemBuilder: (_) {
                            return [
                              ...AdsTypes.values.map((e) => PopupMenuItem(
                                    value: e,
                                    child: Text(e.name.capitalizeFirst!),
                                  ))
                            ];
                          },
                        )),
                    // const SizedBox(height: 10),
                    // const Text('Redirect'),
                    // const SizedBox(height: 10),
                    // TextInputWidget(
                    //   controller: redirectController,
                    //   validate: (value) {
                    //     if (value != null && value.isEmpty) {
                    //       return "This field is required";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    // const Text('Description'),
                    // const SizedBox(height: 10),
                    // TextInputWidget(
                    //   controller: descriptionController,
                    //   maxLines: null,
                    //   inputAction: TextInputAction.newline,
                    //   // validate: (value) {
                    //   //   if (value != null && value.isEmpty) {
                    //   //     return "This field is required";
                    //   //   }
                    //   //   return null;
                    //   // },
                    // ),
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
                                    widget.editAdvertisement != null
                                        ? edit()
                                        : submit();
                                  }
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : Text(widget.editAdvertisement != null
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
