import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/app/view/components/back_button.dart';
import 'package:inspired_blog/app/view/components/image_place_holder.dart';
import 'package:inspired_blog/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';
import 'package:inspired_blog/entertainment/view/entertainment_list_screen.dart';
import 'package:inspired_blog/entertainment/view/episode_detail_screen.dart';
import 'package:inspired_blog/entertainment/view/series_detail_screen.dart';
import 'package:inspired_blog/utils/functions.dart';

class EntertainmentDetailScreen extends StatefulWidget {
  const EntertainmentDetailScreen(
      {super.key, required this.parentEntertainment});

  final Entertainment parentEntertainment;

  @override
  State<EntertainmentDetailScreen> createState() =>
      _EntertainmentDetailScreenState();
}

class _EntertainmentDetailScreenState extends State<EntertainmentDetailScreen> {
  late Entertainment entertainment;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    entertainment = widget.parentEntertainment;
    setState(() => loading = true);
    final fetchedEntertainment = await EntertainmentController.instance
        .getEntertainmentDetails(entertainment.id!);
    entertainment = fetchedEntertainment ?? entertainment;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButtonArrow(),
          centerTitle: true,
          title: Text(entertainment.name ?? "Entertainment"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      ...entertainment.series!.map((series) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(
                                series.name ?? "",
                                style: const TextStyle(
                                    color: Colors.tealAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Container(
                              height: 190,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...series.episodes!.map((e) => EpisodeCard(
                                        episode: e, parentSeries: series))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ));
  }
}

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({super.key, required this.episode, this.parentSeries});

  final Episode episode;
  final Series? parentSeries;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 7, right: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OpenContainer(
            closedColor: Colors.transparent,
            openColor: Colors.transparent,
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            openBuilder: (_, __) => EpisodeDetailScreen(
                episode: episode, parentSeries: parentSeries),
            closedBuilder: (_, __) => Card(
              color: context.surfaceColor,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: context.primary,
              elevation: 2,
              child: SizedBox(
                height: 150,
                width: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: episode.videoThumbnail!,
                    fit: BoxFit.fill,
                    height: 150,
                    errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                    placeholder: (_, __) => const ImagePlaceHolder(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            episode.title ?? "",
            textScaleFactor: 0.9,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
