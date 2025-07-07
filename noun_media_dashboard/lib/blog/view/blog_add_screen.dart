import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/blog/controller/blog_controller.dart';
import 'package:inspired_blog_panel/blog/controller/genre_controller.dart';
import 'package:inspired_blog_panel/blog/model/blog.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:inspired_blog_panel/blog/model/genre.dart';
import 'package:inspired_blog_panel/blog/view/genre_list_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/utils/functions.dart';

class BlogAddScreen extends StatefulWidget {
  const BlogAddScreen({super.key, this.editBlog});

  final Blog? editBlog;

  @override
  State<BlogAddScreen> createState() => _BlogAddScreenState();
}

class _BlogAddScreenState extends State<BlogAddScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final writerController = TextEditingController();

  HtmlEditorController editor = HtmlEditorController();

  bool loading = false;
  List<Genre> genres = [];
  List<int> selectedGenres = [];

  @override
  void initState() {
    if (widget.editBlog != null) initEditValues();
    super.initState();
    getData();
  }

  Future<void> getData() async {
    // genres = await GenreController.instance.getGenres();
    setState(() {});
  }

  void initEditValues() async {
    await Future.delayed(const Duration(seconds: 1));
    titleController.text = widget.editBlog!.name ?? '';
    descriptionController.text = widget.editBlog!.description ?? '';
    writerController.text = widget.editBlog!.writer ?? '';
    editor.setText(widget.editBlog!.content ?? '');
    selectedGenres = widget.editBlog!.genreIds ?? [];
    setState(() {});
  }

  Future<void> submit() async {
    if (selectedGenres.isEmpty) {
      toast("Select generes");
      return;
    }
    final content = await editor.getText();
    final blog = Blog(
      blogId: 0,
      name: titleController.text,
      description: descriptionController.text,
      content: content,
      writer: writerController.text,
      genreIds: selectedGenres,
    );
    // await BlogController.instance.addBlog(blog);
    Get.back();
  }

  Future<void> editSubmit() async {
    if (selectedGenres.isEmpty) {
      toast("Select generes");
      return;
    }
    widget.editBlog!.name = titleController.text;
    widget.editBlog!.description = descriptionController.text;
    widget.editBlog!.writer = writerController.text;
    widget.editBlog!.content = await editor.getText();
    widget.editBlog!.genreIds = selectedGenres;

    // await BlogController.instance.updateBlog(widget.editBlog!);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Post Information'),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.centerLeft,
              children: [
                const SizedBox(height: 10),
                BlogInputWidget(
                  controller: titleController,
                  hint: "Post Title",
                  inputAction: TextInputAction.newline,
                  maxLines: null,
                  validate: (value) {
                    if (value != null && value.isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                BlogInputWidget(
                  controller: descriptionController,
                  hint: "Description",
                  inputAction: TextInputAction.newline,
                  maxLines: null,
                  // validate: (value) {
                  //   if (value != null && value.isEmpty) {
                  //     return "This field is required";
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                BlogInputWidget(
                  controller: writerController,
                  hint: "Writer",
                  inputAction: TextInputAction.newline,
                  maxLines: null,
                  // validate: (value) {
                  //   if (value != null && value.isEmpty) {
                  //     return "This field is required";
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                const Text("Select Genres"),
                const SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ...genres.map((e) => GestureDetector(
                          onTap: () {
                            if (selectedGenres.contains(e.genreId)) {
                              selectedGenres.remove(e.genreId);
                            } else {
                              selectedGenres.add(e.genreId);
                            }
                            setState(() {});
                          },
                          child: Builder(builder: (context) {
                            final selected = selectedGenres.contains(e.genreId);
                            return Chip(
                              avatar: selected
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.check,
                                          size: 15, color: context.primary),
                                    )
                                  : null,
                              side: BorderSide(
                                  color: Colors.black12.withOpacity(0.05)),
                              label: Text(
                                e.name.toString(),
                                style: TextStyle(
                                    color: selected ? Colors.white : null),
                              ),
                              backgroundColor:
                                  selected ? context.primary : null,
                            );
                          }),
                        )),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) {
                              return const Dialog(
                                child: GenreCreatorBoard(),
                              );
                            });
                        await getData();
                      },
                      child: Chip(
                        side:
                            BorderSide(color: Colors.black12.withOpacity(0.05)),
                        label: const Text('Add New Genre'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => editor.clearFocus(),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 600,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HtmlEditor(
                      controller: editor,
                      otherOptions: OtherOptions(
                          height: 600,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(14))),
                      htmlEditorOptions: const HtmlEditorOptions(
                        spellCheck: true,
                        hint: "Write your best content ..",
                        autoAdjustHeight: false,
                        adjustHeightForKeyboard: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                iconSize: 30,
                icon: const Icon(Icons.chevron_left_rounded)),
            Text("Write Post", style: context.textTheme.headlineSmall!),
          ],
        ),
        loading
            ? Transform.scale(
                scale: 0.8, child: const CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () async {
                  widget.editBlog != null ? editSubmit() : submit();
                },
                child: const Text('Save'),
              ),
      ],
    );
  }
}

class BlogInputWidget extends StatefulWidget {
  const BlogInputWidget({
    super.key,
    this.initValues,
    this.controller,
    this.validate,
    this.useObsecure = false,
    this.hint,
    this.inputAction = TextInputAction.next,
    this.autoFills,
    this.onSubmitted,
    this.onChanged,
    this.inputType,
    this.prefix,
    this.maxLines,
    this.enabled,
    this.inputFormatters,
  });

  final String? initValues;
  final TextEditingController? controller;
  final String? Function(String? value)? validate;
  final bool? useObsecure;
  final String? hint;
  final TextInputAction? inputAction;
  final Iterable<String>? autoFills;
  final Function(String? value)? onSubmitted;
  final Function(String? value)? onChanged;
  final TextInputType? inputType;
  final Widget? prefix;
  final int? maxLines;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<BlogInputWidget> createState() => BlogInputWidgetState();
}

class BlogInputWidgetState extends State<BlogInputWidget> {
  bool invisiblePassword = false;

  @override
  void initState() {
    super.initState();
    invisiblePassword = widget.useObsecure ?? false;
  }

  InputDecoration _getDecoration({String? hintText}) {
    const border = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.black12,
    ));

    final visibleWidget = GestureDetector(
      onTap: () {
        setState(() {
          invisiblePassword = !invisiblePassword;
        });
      },
      child: Icon(invisiblePassword ? Icons.visibility_off : Icons.visibility),
    );

    return InputDecoration(
      enabledBorder: border,
      border: border,
      isDense: true,
      contentPadding: const EdgeInsets.all(10).copyWith(top: 20),
      suffixIcon: (widget.useObsecure ?? false)
          ? visibleWidget
          : const SizedBox.shrink(),
      labelText: hintText,
      prefixIcon: widget.prefix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.mediaType == MediaTypes.mobile ? null : 400,
      child: TextFormField(
        key: widget.key,
        initialValue: widget.initValues,
        cursorColor: context.primary,
        cursorWidth: 1.2,
        obscureText: invisiblePassword,
        controller: widget.controller,
        autofillHints: widget.autoFills,
        textInputAction: widget.inputAction,
        onFieldSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        keyboardType: widget.inputType,
        decoration: _getDecoration(hintText: widget.hint),
        validator: widget.validate,
        enabled: widget.enabled,
        maxLines: widget.useObsecure! ? 1 : widget.maxLines,
        style: (widget.enabled ?? true)
            ? null
            : const TextStyle(color: Colors.grey),
        inputFormatters: widget.inputFormatters,
      ),
    );
  }
}
