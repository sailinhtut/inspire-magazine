// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog_panel/entertainment/view/entertainment_detail_screen.dart';
import 'package:inspired_blog_panel/header_image/controller/header_image_controller.dart';
import 'package:inspired_blog_panel/header_image/model/header_image.dart';
import 'package:inspired_blog_panel/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/components/paginated_button.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class HeaderImageListScreen extends StatefulWidget {
  const HeaderImageListScreen({super.key});

  @override
  State<HeaderImageListScreen> createState() => _HeaderImageListScreenState();
}

class _HeaderImageListScreenState extends State<HeaderImageListScreen> {
  bool fetching = false;
  bool loading = false;
  String searchKey = "";

  @override
  void initState() {
    super.initState();
    HeaderImageController.instance.getHeaderImages();
  }

  List<HeaderImage> filterHeaderImage(List<HeaderImage> data) {
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

  Future<void> addMagazine() async {
    await showDialog(
        context: context,
        builder: (_) {
          return const Dialog(child: HeaderImageCreator());
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.mediaType == MediaTypes.mobile;

    return GetBuilder<HeaderImageController>(builder: (controller) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: ()async{
             setState(() => loading = true);
            HeaderImageController.instance
                .getHeaderImages();
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
                                  if (!isMobile) buildSearchBar(),
                                  const SizedBox(width: 10),
                                  isMobile
                                      ? IconButton(
                                          onPressed: addMagazine,
                                          icon: const Icon(Icons.add),
                                        )
                                      : ElevatedButton(
                                          onPressed: addMagazine,
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
                                            HeaderImageController.instance
                                                .getHeaderImages();
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
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Order')),
                              DataColumn(label: Text('Created on')),
                              DataColumn(label: SizedBox(width: 50)),
                            ],
                            rows: [
                              ...filterHeaderImage(controller.images).map(
                                (e) => DataRow(
                                  onSelectChanged: (value) {
                                    Get.dialog(
                                      Center(
                                        child: SizedBox(
                                            height: 800,
                                            width: 500,
                                            child: Image.network(e.imageUrl!)),
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
                                          borderRadius: BorderRadius.circular(7),
                                          image: DecorationImage(
                                            image: NetworkImage(e.imageUrl!),
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
                                        width: isMobile ? 100 : 200,
                                        child: Text(
                                          '${e.order}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
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
                                          if (value == "delete") {
                                            showConfirmDialog(context,
                                                title: "Delete ${e.name}",
                                                content:
                                                    "Are you sure to delete ?",
                                                buttonText: "Confirm",
                                                onConfirm: () async {
                                              Navigator.pop(context);
                                              final result =
                                                  await NounAPI.deleteHeaderImage(
                                                      e.id!);
                                              if (result) {
                                                toast("Successfully deleted");
                                                setState(() {
                                                  controller.images.removeWhere(
                                                      (element) =>
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
          Text("Carousel Slider Images",
              style: context.textTheme.headlineSmall!),
        ],
      ),
    );
  }
}

class HeaderImageCreator extends StatefulWidget {
  const HeaderImageCreator({super.key});

  @override
  State<HeaderImageCreator> createState() => HeaderImageCreatorState();
}

class HeaderImageCreatorState extends State<HeaderImageCreator> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final redirectController = TextEditingController();
  final orderController = TextEditingController();
  PlatformFile? image;

  bool loading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    orderController.text = "0";
  }

  Future<void> submit() async {
    if (image == null) {
      toast("Choose cover photo");
      return;
    }

    setState(() => loading = true);
    final created = await NounAPI.createHeaderImage(
      name: nameController.text,
      order: int.tryParse(orderController.text),
      image: image!,
      redirect: redirectController.text,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (created != null) {
      HeaderImageController.instance.images.add(created);
      HeaderImageController.instance.update();
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
              title: Text("Create Image", textScaleFactor: 1.2),
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
                    if (image != null)
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
                    const Text('Redirect To'),
                    const SizedBox(height: 10),
                    TextInputWidget(
                      controller: redirectController,
                      maxLines: null,
                      inputAction: TextInputAction.newline,
                      // validate: (value) {
                      //   if (value != null && value.isEmpty) {
                      //     return "This field is required";
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 10),
                    const Text('Poriority Order (Default-0)'),
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
                                    submit();
                                  }
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : Text('Create'),
                        ),
                      ],
                    ),
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
