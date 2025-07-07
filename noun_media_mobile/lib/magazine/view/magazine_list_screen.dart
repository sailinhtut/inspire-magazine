import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/app/view/components/loading_widget.dart';
import 'package:inspired_blog/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog/magazine/view/components/magazine_card_widget.dart';
import 'package:inspired_blog/utils/functions.dart';

class MagazineListScreen extends StatefulWidget {
  const MagazineListScreen({super.key});

  @override
  State<MagazineListScreen> createState() => _MagazineListScreenState();
}

class _MagazineListScreenState extends State<MagazineListScreen> {
  bool loading = false;
  bool gettingMore = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (!gettingMore) {
          getData(page: MagazineController.instance.nextPage, fetching: true);
        }
      }
    });
  }

  Future<void> getData({int page = 1, bool fetching = false}) async {
    setState(() {
      fetching ? gettingMore = true : loading = true;
    });
    await MagazineController.instance
        .getMagazines(page: page, append: fetching);
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
            title: const Text('Magazines')),
        body: GetBuilder<MagazineController>(
          builder: (controller) {
            return loading
                ? const LoadingWidget()
                : Column(
                    children: [
                      // magazine list
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.getMagazines(
                                page: 1, append: false);
                          },
                          child: GridView.builder(
                              controller: scrollController,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.magazines.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.25 / 2,
                              ),
                              itemBuilder: (_, index) {
                                final magazine = controller.magazines[index];
                                return MagazineCard(magazine: magazine);
                              }),
                        ),
                      ),
                      if (gettingMore) const LoadingWidget(),
                      const SizedBox(height: 50),
                    ],
                  );
          },
        ));
  }
}
