import 'package:flutter/material.dart';
import 'package:inspired_blog/app/model/meta_data.dart';
import 'package:inspired_blog/utils/constants.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MetaReader extends StatefulWidget {
  const MetaReader({super.key, required this.metaData, this.icon});

  final NounMetaData metaData;
  final Icon? icon;

  @override
  State<MetaReader> createState() => _MetaReaderState();
}

class _MetaReaderState extends State<MetaReader> {
  final progressNotifier = ValueNotifier<double>(0);
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      progressNotifier.value =
          scrollController.offset / scrollController.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(appName),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Center(
              child: ValueListenableBuilder<double>(
                  valueListenable: progressNotifier,
                  builder: (_, progress, __) {
                    return AnimatedOpacity(
                        opacity: progress,
                        duration: const Duration(milliseconds: 400),
                        child: widget.icon ??
                            Icon(Icons.spa, size: 30, color: context.primary));
                  }),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              controller: scrollController,
              child: Column(
                children: [
                  HtmlWidget(
                    widget.metaData.content!,
                    renderMode: RenderMode.column,
                    onTapUrl: (link) => launchUrlString(link,
                        mode: LaunchMode.externalApplication),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            )),
          ],
        ));
  }
}
