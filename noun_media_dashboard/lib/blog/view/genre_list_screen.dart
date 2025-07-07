// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:inspired_blog_panel/blog/controller/blog_controller.dart';
import 'package:inspired_blog_panel/blog/controller/genre_controller.dart';
import 'package:inspired_blog_panel/blog/model/genre.dart';
import 'package:inspired_blog_panel/blog/view/blog_add_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/components/paginated_button.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class GenreListScreen extends StatefulWidget {
  const GenreListScreen({super.key});

  @override
  State<GenreListScreen> createState() => _GenreListScreenState();
}

class _GenreListScreenState extends State<GenreListScreen> {
  bool fetching = false;
  bool searching = false;

  @override
  void initState() {
    super.initState();
    // GenreController.instance.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.mediaType == MediaTypes.mobile;

    return GetBuilder<GenreController>(builder: (controller) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(controller),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Updated on')),
                            DataColumn(label: SizedBox(width: 50)),
                          ],
                          rows: [
                            ...controller.genres.map(
                              (e) => DataRow(
                                onSelectChanged: (value) {},
                                cells: [
                                  DataCell(
                                    Text('${e.genreId}'),
                                  ),
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
                                    Text(e.updatedAt != null
                                        ? DateFormat("MMM dd yyyy")
                                            .format(e.updatedAt!)
                                        : ''),
                                  ),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == "write") {
                                          await showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Dialog(
                                                  child: GenreCreatorBoard(
                                                      editGenre: e),
                                                );
                                              });
                                        } else if (value == "delete") {
                                          showConfirmDialog(context,
                                              title: "Confirm",
                                              content:
                                                  "Are you sure to delete ${e.name} ?",
                                              buttonText: "Delete",
                                              onConfirm: () async {
                                            Navigator.pop(context);
                                            // await GenreController.instance
                                            //     .deleteGenre(e.genreId);
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
                                            value: "write",
                                            child: Text("Edit"),
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
                                controller.firstPage != controller.currentPage)
                              PaginateButton(
                                controller.firstPage.toString(),
                                onPressed: () async {
                                  setState(() => fetching = true);
                                  // await controller.getGenres(
                                  //     page: controller.firstPage);
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
                                  // await controller.getGenres(
                                  //     page: controller.previousPage);
                                  setState(() => fetching = false);
                                },
                              ),
                            PaginateButton(
                              controller.currentPage.toString(),
                              onPressed: () async {
                                setState(() => fetching = true);
                                // await controller.getGenres(
                                //     page: controller.currentPage);
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
                                  // await controller.getGenres(
                                  //     page: controller.nextPage);
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
                                  // await controller.getGenres(
                                  //     page: controller.lastPage);
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
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(GenreController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Genres", style: context.textTheme.headlineSmall!),
          Row(
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
                      // await controller.getGenres(page: controller.currentPage);
                    } else {
                      // await controller.searchGenre(value);
                    }
                    setState(() => searching = false);
                  },
                ),
              ),
              const SizedBox(width: 10),
              searching
                  ? Transform.scale(
                      scale: 0.8, child: const CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (_) {
                              return const Dialog(
                                child: GenreCreatorBoard(),
                              );
                            });
                      },
                      child: const Text('Create Genre'),
                    ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}

class GenreCreatorBoard extends StatefulWidget {
  const GenreCreatorBoard({super.key, this.editGenre});

  final Genre? editGenre;

  @override
  State<GenreCreatorBoard> createState() => _GenreCreatorBoardState();
}

class _GenreCreatorBoardState extends State<GenreCreatorBoard> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  void initValues() {
    if (widget.editGenre != null) {
      nameController.text = widget.editGenre!.name ?? '';
      descriptionController.text = widget.editGenre!.description ?? '';
    }
  }

  Future<void> submit() async {
    setState(() => loading = true);
    final genre = Genre(
      genreId: 0,
      name: nameController.text,
      description: descriptionController.text,
    );
    // await GenreController.instance.addGenre(genre);
    setState(() => loading = true);
    Navigator.pop(context);
  }

  Future<void> edit() async {
    widget.editGenre!.name = nameController.text;
    widget.editGenre!.description = descriptionController.text;
    setState(() => loading = true);
    // await GenreController.instance.updateGenre(widget.editGenre!);
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
          const SizedBox(
            height: 60,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 13),
              title: Text('Create New Genre', textScaleFactor: 1.2),
            ),
          ),
          // const Divider(
          //   color: Colors.black12,
          //   height: 1,
          // ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const Text('Description'),
                    const SizedBox(height: 10),
                    TextInputWidget(
                      controller: descriptionController,
                      maxLines: null,
                      inputAction: TextInputAction.newline,
                      validate: (value) {
                        if (value != null && value.isEmpty) {
                          return "This field is required";
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
                                    widget.editGenre != null
                                        ? edit()
                                        : submit();
                                  }
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : Text(
                                  widget.editGenre != null ? 'Edit' : 'Create'),
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
