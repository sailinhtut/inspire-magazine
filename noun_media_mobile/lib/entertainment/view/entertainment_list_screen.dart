import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/app/view/components/loading_widget.dart';
import 'package:inspired_blog/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog/entertainment/view/components/entertainment_card_widget.dart';
import 'package:inspired_blog/utils/functions.dart';

class EntertainmentListScreen extends StatefulWidget {
  const EntertainmentListScreen({super.key});

  @override
  State<EntertainmentListScreen> createState() =>
      _EntertainmentListScreenState();
}

class _EntertainmentListScreenState extends State<EntertainmentListScreen> {
  bool loading = false;
  bool gettingMore = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getData(
            page: EntertainmentController.instance.nextPage, fetching: true);
      }
    });
  }

  Future<void> getData({int page = 1, bool fetching = false}) async {
    setState(() {
      fetching ? gettingMore = true : loading = true;
    });
    await EntertainmentController.instance
        .getEntertainments(page: page, append: fetching);
    setState(() {
      fetching ? gettingMore = false : loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: context.textColor,
                  size: 30,
                )),
            centerTitle: true,
            title: const Text('Journals')),
        body: GetBuilder<EntertainmentController>(
          builder: (controller) {
            return loading
                ? const LoadingWidget()
                : Column(
                    children: [
                      // magazine list
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.getEntertainments(
                                page: 1, append: false);
                          },
                          child: GridView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.entertainments.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.25 / 2,
                              ),
                              itemBuilder: (_, index) {
                                final entertainment =
                                    controller.entertainments[index];
                                return EntertainmentCard(
                                    entertainment: entertainment);
                              }),
                        ),
                      ),
                      if (gettingMore) const LoadingWidget()
                    ],
                  );
          },
        ));
  }
}
