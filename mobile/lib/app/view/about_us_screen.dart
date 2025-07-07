import 'package:flutter/material.dart';
import 'package:inspired_blog/utils/constants.dart';
import 'package:inspired_blog/utils/functions.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
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
                        child:
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
                children: const [
                  Text(about_us),
                ],
              ),
            )),
          ],
        ));
  }
}
