// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/entertainment/model/entertainment.dart';
import 'package:inspired_blog_panel/magazine/model/magazine.dart';
import 'package:inspired_blog_panel/magazine/view/topic_detail_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class SeriesDetailScreen extends StatefulWidget {
  const SeriesDetailScreen(
      {super.key, required this.entertainment, required this.series});

  final Entertainment entertainment;
  final Series series;

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  bool fetching = false;
  bool searching = false;

  String searchKey = "";

  @override
  void initState() {
    super.initState();
  }

  List<Episode> filterEpisodes(List<Episode> data) {
    if (searchKey.isEmpty) return data;
    return data
        .where((element) =>
            element.title!.toLowerCase().contains(searchKey.toLowerCase()) ||
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
          return Dialog(child: EpisodeCreator(series: widget.series));
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
                              : const Text("Episodes", textScaleFactor: 1.3),
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
                                      child: const Text('Add Episode'),
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
                          ...filterEpisodes(widget.series.episodes!).map(
                            (e) => DataRow(
                              onSelectChanged: (value) {},
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
                                        image: NetworkImage(e.videoThumbnail!),
                                        fit: BoxFit.fill,
                                      )),
                                )),
                                DataCell(SizedBox(
                                    width: isMobile ? 100 : 200,
                                    child: Text(
                                      '${e.title}',
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
                                                  child: EpisodeCreator(
                                                      series: widget.series,
                                                      editEpisode: e));
                                            });
                                        setState(() {});
                                      } else if (value == "delete") {
                                        showConfirmDialog(context,
                                            title: "Delete ${e.title}",
                                            content: "Are you sure to delete ?",
                                            buttonText: "Confirm",
                                            onConfirm: () async {
                                          Navigator.pop(context);
                                          final result =
                                              await NounAPI.deleteEpisode(
                                                  e.id!);
                                          if (result) {
                                            toast("Successfully deleted");
                                            setState(() {
                                              widget.series.episodes!
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
              Text(widget.series.name!,
                  style: context.textTheme.headlineSmall!),
            ],
          )
        ],
      ),
    );
  }
}

class EpisodeCreator extends StatefulWidget {
  const EpisodeCreator({super.key, required this.series, this.editEpisode});

  final Series series;
  final Episode? editEpisode;

  @override
  State<EpisodeCreator> createState() => EpisodeCreatorState();
}

class EpisodeCreatorState extends State<EpisodeCreator> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final videoUrlController = TextEditingController();
  final orderController = TextEditingController();

  PlatformFile? videoThumbnail;

  bool loading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  Future<void> initValues() async {
    if (widget.editEpisode != null) {
      nameController.text = widget.editEpisode!.title ?? '';
      descriptionController.text = widget.editEpisode!.description ?? '';
      videoUrlController.text = widget.editEpisode!.videoUrl ?? '';
      orderController.text = widget.editEpisode!.order.toString();
      setState(() {});
    }else{
      orderController.text = "0";
    }
  }

  Future<void> submit() async {
    if (videoThumbnail == null) {
      toast("Choose cover photo");
      return;
    }

    setState(() => loading = true);
    final created = await NounAPI.createEpisode(
      name: nameController.text,
      description: descriptionController.text,
      videoUrl: videoUrlController.text,
      videoThunbnail: videoThumbnail!,
      seriesId: widget.series.id!,
      order: int.tryParse(orderController.text) ?? 0,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (created != null) {
      widget.series.episodes!.add(created);
      setState(() {});
      toast("Successfully Created");
    } else {
      toast("Cannot create episode");
    }

    setState(() {
      loading = false;
      progress = 0;
    });
    Navigator.pop(context);
  }

  Future<void> edit() async {
    setState(() => loading = true);
    final updated = await NounAPI.updateEpisode(
      widget.editEpisode!.id!,
      name: nameController.text,
      description: descriptionController.text,
      videoUrl: videoUrlController.text,
      videoThumbnail: videoThumbnail,
      order: int.tryParse(orderController.text) ?? 0,
      seriesId: widget.series.id,
      onSendProgress: (current, total) {
        setState(() => progress = (current / total));
      },
      onReceiveProgress: (current, total) {
        setState(() => progress = (current / total));
      },
    );

    if (updated != null) {
      final index = widget.series.episodes!.indexOf(widget.editEpisode!);
      widget.series.episodes!.removeAt(index);
      widget.series.episodes!.insert(index, updated);
      toast("Successfully Updated");
    } else {
      toast("Cannot update episode");
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
                  widget.editEpisode != null
                      ? "Edit Episode"
                      : "Create Episode",
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
                    if (videoThumbnail != null ||
                        (widget.editEpisode != null &&
                            widget.editEpisode?.videoThumbnail != null))
                      Container(
                        height: 230,
                        width: 130,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(7),
                            image: videoThumbnail != null
                                ? DecorationImage(
                                    image: MemoryImage(videoThumbnail!.bytes!),
                                    fit: BoxFit.fill,
                                  )
                                : widget.editEpisode != null &&
                                        widget.editEpisode!.videoThumbnail !=
                                            null
                                    ? DecorationImage(
                                        image: NetworkImage(widget
                                            .editEpisode!.videoThumbnail!),
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
                            setState(() => videoThumbnail = picked.files.first);
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
                    const Text('Video Url'),
                    const SizedBox(height: 10),
                    TextInputWidget(
                      controller: videoUrlController,
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
                                    widget.editEpisode != null
                                        ? edit()
                                        : submit();
                                  }
                                },
                          child: loading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator())
                              : Text(widget.editEpisode != null
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
