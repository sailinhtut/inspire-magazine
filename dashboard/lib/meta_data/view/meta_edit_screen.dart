import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:inspired_blog_panel/blog/model/genre.dart';
import 'package:inspired_blog_panel/meta_data/controller/meta_data_controller.dart';
import 'package:inspired_blog_panel/meta_data/model/meta_data.dart';

class MetaEditScreen extends StatefulWidget {
  const MetaEditScreen({super.key, required this.meta});

  final NounMetaData meta;

  @override
  State<MetaEditScreen> createState() => _MetaEditScreenState();
}

class _MetaEditScreenState extends State<MetaEditScreen> {
  HtmlEditorController editor = HtmlEditorController();

  bool loading = false;
  List<Genre> genres = [];
  List<int> selectedGenres = [];

  @override
  void initState() {
    initValues();
    super.initState();
  }

  void initValues() async {
    await Future.delayed(const Duration(seconds: 1));
    editor.setText(widget.meta.content!);
    setState(() {});
  }

  Future<void> submit() async {
    setState(() => loading = true);
    final content = await editor.getText();
    widget.meta.content = content;
    final updated = await NounAPI.createMetaData(
        name: widget.meta.name!, metaContent: content);
    if (updated != null) {
      final index = MetaDataController.instance.metaData
          .indexWhere((element) => element.id == updated.id);
      MetaDataController.instance.metaData.removeAt(index);
      MetaDataController.instance.metaData.insert(index, updated);
    }
    setState(() => loading = false);
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
                        hint: "Write content ..",
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
            Text(widget.meta.name!, style: context.textTheme.headlineSmall!),
          ],
        ),
        loading
            ? Transform.scale(
                scale: 0.8, child: const CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () async {
                  submit();
                },
                child: const Text('Save'),
              ),
      ],
    );
  }
}
