import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/advertisement/controller/advertisement_controller.dart';
import 'package:inspired_blog/advertisement/model/advertisement.dart';
import 'package:inspired_blog/app/view/components/image_place_holder.dart';
import 'package:inspired_blog/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog/magazine/model/magazine.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MagazineDetailScreen extends StatefulWidget {
  const MagazineDetailScreen({super.key, required this.parentMagazine});

  final Magazine parentMagazine;

  @override
  State<MagazineDetailScreen> createState() => _MagazineDetailScreenState();
}

class _MagazineDetailScreenState extends State<MagazineDetailScreen> {
  bool loading = false;
  late Magazine magazine;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    magazine = widget.parentMagazine;
    setState(() => loading = true);
    final fetchedMagazine = await MagazineController.instance
        .getMagazineDetails(magazine.magazineId);
    magazine = fetchedMagazine ?? magazine;
    setState(() => loading = false);
  }

  Widget buildAdvertisement() {
    return GetBuilder<AdvertisementController>(builder: (controller) {
      final magazineAdvertisements = controller.magazineAds;
      if (magazineAdvertisements.isEmpty) {
        return const SizedBox();
      }

      magazineAdvertisements.shuffle();
      final randomFirstAds = magazineAdvertisements.first;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            dense: true,
            title: Text('Advertisement'),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          GestureDetector(
            onTap: () {
              if (randomFirstAds.redirect != null) {
                launchUrlString(randomFirstAds.redirect!,
                    mode: LaunchMode.externalApplication);
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Card(
                  color: context.surfaceColor,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  shadowColor: context.primary,
                  elevation: 2,
                  child: SizedBox(
                    height: 400,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: randomFirstAds.imageUrl!,
                        fit: BoxFit.fitHeight,
                        errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                        placeholder: (_, __) => const ImagePlaceHolder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(magazine.name.toString()),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await getDetails();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (magazine.topics!.isNotEmpty)
                        const SizedBox(height: 10),

                      // topics
                      if (magazine.topics!.isNotEmpty)
                        SizedBox(
                          height: 450,
                          child: TopicSlider(topics: magazine.topics!),
                        ),
                      buildAdvertisement(),
                      const ListTile(
                        dense: true,
                        title: Text('Cover Photo'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Card(
                            color: context.surfaceColor,
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            shadowColor: context.primary,
                            elevation: 2,
                            child: SizedBox(
                              height: 400,
                              width: 300,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: magazine.coverPhoto!,
                                  fit: BoxFit.fitHeight,
                                  errorWidget: (_, __, ___) =>
                                      const ImagePlaceHolder(),
                                  placeholder: (_, __) =>
                                      const ImagePlaceHolder(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (magazine.description != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            magazine.description!,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ));
  }
}

class TopicSlider extends StatefulWidget {
  const TopicSlider({super.key, required this.topics});

  final List<Topic> topics;

  @override
  State<TopicSlider> createState() => _TopicSliderState();
}

class _TopicSliderState extends State<TopicSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 430,
            autoPlay: true,
            aspectRatio: 4 / 3,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: widget.topics.map((topic) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    OpenContainer(
                      closedColor: Colors.transparent,
                      openColor: Colors.transparent,
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      openBuilder: (_, __) => MagazineReader(topic: topic),
                      closedBuilder: (_, __) => Card(
                        color: context.surfaceColor,
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: context.primary,
                        elevation: 2,
                        child: SizedBox(
                          height: 370,
                          width: 280,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: topic.coverPhoto!,
                              fit: BoxFit.fitHeight,
                              errorWidget: (_, __, ___) =>
                                  const ImagePlaceHolder(),
                              placeholder: (_, __) => const ImagePlaceHolder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(topic.name ?? ""),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: widget.topics.length,
            effect: WormEffect(
              dotHeight: 7,
              dotWidth: 7,
              activeDotColor: context.primary,
              dotColor: Colors.white10,
            ),
          ),
        )
      ],
    );
  }
}

class MagazineReader extends StatefulWidget {
  const MagazineReader({super.key, required this.topic});

  final Topic topic;

  @override
  State<MagazineReader> createState() => _MagazineReaderState();
}

class _MagazineReaderState extends State<MagazineReader> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(widget.topic.name.toString()),
        ),
        body: ListView.builder(
          itemCount: widget.topic.photos!.length,
          itemBuilder: (_, index) {
            final imageUrl = widget.topic.photos![index];
            return SizedBox(
              height: screen.height - kToolbarHeight,
              width: screen.width,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fill,
                errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                placeholder: (_, __) => const ImagePlaceHolder(),
              ),
            );
          },
        ));
  }
}
