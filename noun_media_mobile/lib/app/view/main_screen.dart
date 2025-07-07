// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/advertisement/controller/advertisement_controller.dart';
import 'package:inspired_blog/api/noun_api.dart';
import 'package:inspired_blog/app/controller/header_image_controller.dart';
import 'package:inspired_blog/app/model/header_image.dart';
import 'package:inspired_blog/app/view/about_us_screen.dart';
import 'package:inspired_blog/app/view/components/image_place_holder.dart';
import 'package:inspired_blog/app/view/components/image_slider.dart';
import 'package:inspired_blog/app/view/meta_reader.dart';
import 'package:inspired_blog/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog/entertainment/view/entertainment_list_screen.dart';
import 'package:inspired_blog/entertainment/view/episode_detail_screen.dart';
import 'package:inspired_blog/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog/magazine/view/components/magazine_list_widget.dart';
import 'package:inspired_blog/magazine/view/magazine_list_screen.dart';
import 'package:inspired_blog/main.dart';
import 'package:inspired_blog/utils/constants.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../entertainment/view/components/entertainment_list_widget.dart';
import '../model/meta_data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen(
      {Key? key,
      this.startPageIndex = 1,
      this.activityTabIndex = 0,
      this.loadAppData = false})
      : super(key: key);

  final int startPageIndex;
  final int activityTabIndex;
  final bool loadAppData;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  final categories = ["ART", "M-9"];
  String category = "ART";

  @override
  void initState() {
    super.initState();
    getConfigs();
  }

  Future<void> getData() async {
    await clearImageCache();
    await MagazineController.instance.getMagazines(page: 1);
    await EntertainmentController.instance.getEntertainments(page: 1);
  }

  Future<void> getConfigs() async {
    await HeaderImageController.instance.getHeaderImages();
    await AdvertisementController.instance
        .getAdvertisements()
        .then((value) async {
      await Future.delayed(const Duration(seconds: 3));
      showPopUpAdvertise();
    });
  }

  Future<void> showPopUpAdvertise() async {
    if (AdvertisementController.instance.popupAds.isEmpty) return;
    final magazineAdvertisements = AdvertisementController.instance.popupAds;
    magazineAdvertisements.shuffle();
    final randomFirstAds = magazineAdvertisements.first;
    Uint8List imageData = await downloadImage(randomFirstAds.imageUrl!);

    Get.dialog(GetBuilder<AdvertisementController>(builder: (controller) {
      if (magazineAdvertisements.isEmpty) {
        return const SizedBox();
      }

      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height - 100,
            width: 300,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width - 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          imageData,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Column(
                  //     children: [
                  //       Text(randomFirstAds.name.toString(),
                  //           textScaleFactor: 1.8),
                  //       Text(randomFirstAds.description.toString(),
                  //           textScaleFactor: 1),
                  //     ],
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(
                  //       style:
                  //           TextButton.styleFrom(foregroundColor: Colors.grey),
                  //       child: const Text("Later", textScaleFactor: 1),
                  //       onPressed: () => Navigator.pop(context),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     if (randomFirstAds.redirect != null &&
                  //         randomFirstAds.redirect!.isNotEmpty &&
                  //         randomFirstAds.redirect!.contains("https://"))
                  //       TextButton(
                  //         child: const Text("Visit Now", textScaleFactor: 1),
                  //         onPressed: () => launchUrlString(
                  //             randomFirstAds.redirect!,
                  //             mode: LaunchMode.externalApplication),
                  //       ),
                  //     const SizedBox(width: 10),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }

  Widget buildCategoryBar() {
    return Row(
      children: [
        ...categories.map((e) {
          return GestureDetector(
            onTap: () {
              setState(() => category = e);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10.withOpacity(0.05)),
              ),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: Text(
                e,
                style: TextStyle(color: category == e ? context.primary : null),
              ),
            ),
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: const DrawerWidget(),
        appBar: AppBar(
          leading: Icon(Icons.spa, color: context.primary, size: 30),
          actions: [
            IconButton(
              icon: Icon(Icons.menu_rounded, color: context.textColor),
              onPressed: () => scaffoldKey.currentState!.openDrawer(),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await getData();
            await getConfigs();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCategoryBar(),
                const SizedBox(height: 15),
                GetBuilder<HeaderImageController>(builder: (imageController) {
                  return ImageSlider(imageList: imageController.images);
                }),
                const SizedBox(height: 10),

                // magazines
                ListTile(
                  dense: true,
                  title: const Text(
                    'Magazine',
                    style: TextStyle(
                        color: Colors.tealAccent, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                      iconSize: 22,
                      icon: Icon(Icons.arrow_forward, color: context.textColor),
                      onPressed: () =>
                          Get.to(() => const MagazineListScreen())),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5)
                      .copyWith(right: 0),
                ),
                GetBuilder<MagazineController>(
                    builder: (magazineController) => MagazineHorizontalList(
                        magazineList: magazineController.magazines.length > 10
                            ? magazineController.magazines.sublist(0, 10)
                            : magazineController.magazines)),

                // entertainments
                GetBuilder<EntertainmentController>(
                    builder: (entertainmentController) =>
                        EntertainmentHorizontalList(
                            entertainments:
                                entertainmentController.entertainments)),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      shape: const RoundedRectangleBorder(),
      surfaceTintColor: Colors.transparent,
      backgroundColor: context.surfaceColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(appName, textScaleFactor: 1.5),
                    Text('$description ',
                        textScaleFactor: 0.8,
                        style: TextStyle(color: Colors.white30)),
                  ],
                ),
                const SizedBox(width: 10),
                Icon(Icons.spa, color: context.primary, size: 30),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            // buildMenuTile(
            //     icon: Icons.bookmark,
            //     title: "Inspired Blogs",
            //     onTap: () => Get.to(() => const BlogListScreen())),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MetaMenuTile(
                    leading: Icon(Icons.file_copy,
                        color: context.textColor, size: 20),
                    title: "Privacy Policy",
                    metaType: MetaDataTypes.pravicy_policy,
                    fallbackMetaContent: "https://google.com",
                  ),
                  // MetaMenuTile(
                  //   leading: Icon(Icons.edit_document,
                  //       color: context.textColor, size: 20),
                  //   title: "Term & Service",
                  //   metaType: MetaDataTypes.terms,
                  //   fallbackMetaContent: "https://google.com",
                  // ),
                  MetaMenuTile(
                    leading: Icon(Icons.info_outline,
                        color: context.textColor, size: 20),
                    title: "About Us",
                    metaType: MetaDataTypes.about_us,
                    fallbackMetaContent: "https://google.com",
                  ),
                  buildMenuTile(
                    icon: Icons.share,
                    title: "Share Noun",
                    onTap: () => Share.share("https://google.com"),
                  ),
                ],
              ),
            ),
            const Text('Version 1.0',
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white38)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildMenuTile(
      {required IconData icon,
      required String title,
      required VoidCallback? onTap}) {
    return Theme(
      data: Theme.of(context).copyWith(highlightColor: context.highlightColor),
      child: ListTile(
        leading: Icon(icon, color: context.textColor, size: 20),
        minLeadingWidth: 20,
        title: Text(title, textScaleFactor: 1),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}

class MetaMenuTile extends StatefulWidget {
  const MetaMenuTile(
      {super.key,
      required this.title,
      required this.metaType,
      this.leading,
      this.fallbackMetaContent = ""});

  final Icon? leading;
  final String title;
  final String metaType;
  final String fallbackMetaContent;

  @override
  State<MetaMenuTile> createState() => _MetaMenuTileState();
}

class _MetaMenuTileState extends State<MetaMenuTile> {
  bool loading = false;
  NounMetaData? meta;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMeta() async {
    setState(() => loading = true);
    meta = await NounAPI.getMetaData(widget.metaType);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(highlightColor: context.highlightColor),
      child: Column(
        children: [
          ListTile(
            leading: widget.leading,
            minLeadingWidth: 20,
            title: Text(widget.title, textScaleFactor: 1),
            dense: true,
            onTap: () async {
              await loadMeta();
              if (meta == null) {
                final fallbackMeta = NounMetaData(
                    content: widget.fallbackMetaContent,
                    name: widget.metaType
                        .toString()
                        .capitalizeFirst!
                        .replaceAll("-", " "));

                if (fallbackMeta.content!.startsWith('https://') ||
                    fallbackMeta.content!.startsWith("http://")) {
                  launchUrlString(fallbackMeta.content!.trim(),
                      mode: LaunchMode.externalApplication);
                } else {
                  Get.to(() => MetaReader(
                        metaData: fallbackMeta,
                        icon: widget.leading,
                      ));
                }
              } else {
                if (meta!.content!.startsWith('https://') ||
                    meta!.content!.startsWith("http://")) {
                  launchUrlString(meta!.content!.trim(),
                      mode: LaunchMode.externalApplication);
                } else {
                  Get.to(() => MetaReader(
                        metaData: meta!,
                        icon: widget.leading,
                      ));
                }
              }
            },
          ),
          if (loading) const LinearProgressIndicator(minHeight: 1)
        ],
      ),
    );
  }
}
