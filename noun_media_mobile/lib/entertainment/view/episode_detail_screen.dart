import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../app/view/components/image_place_holder.dart';

class EpisodeDetailScreen extends StatefulWidget {
  const EpisodeDetailScreen(
      {super.key, required this.episode, this.parentSeries});
  final Episode episode;
  final Series? parentSeries;

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen> {
  YoutubePlayerController? youtubeController;

  bool fullScreen = false;

  @override
  void initState() {
    super.initState();
    setUpPlayer();
  }

  void setUpPlayer() async {
    final videoId = YoutubePlayer.convertUrlToId(widget.episode.videoUrl!);
    youtubeController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
  }

  void setFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    setFullScreenMode();
    super.dispose();
  }

  Widget buildContents() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // description
          if (widget.episode.description != null)
            Text(widget.episode.description!),

          const SizedBox(height: 20),

          if (widget.parentSeries != null)
            ...widget.parentSeries!.episodes!
                .where((otherEpisode) => otherEpisode.id != widget.episode.id)
                .map((e) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EpisodeDetailScreen(
                              episode: e, parentSeries: widget.parentSeries)));
                },
                child: Card(
                  shadowColor: context.primary,
                  margin: const EdgeInsets.only(bottom: 25),
                  elevation: 5,
                  child: SizedBox(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: SizedBox(
                            height: 165,
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: e.videoThumbnail!,
                              height: 220,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) =>
                                  const ImagePlaceHolder(),
                              placeholder: (_, __) => const ImagePlaceHolder(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title ?? "",
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fullScreen
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: context.textColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(widget.episode.title ?? ""),
            ),
      body: youtubeController == null
          ? SingleChildScrollView(
              child: Column(
              children: [
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white10.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.spa, color: context.highlightColor, size: 30),
                      const SizedBox(height: 10),
                      const Text(
                        "Video is not available for while",
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                buildContents(),
                const SizedBox(height: 50),
              ],
            ))
          : YoutubePlayerBuilder(
              onEnterFullScreen: () => setState(() => fullScreen = true),
              onExitFullScreen: () => setState(() => fullScreen = false),
              player: YoutubePlayer(
                controller: youtubeController!,
              ),
              builder: (context, player) {
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // some widgets
                    player,

                    if (!fullScreen) buildContents(),

                    const SizedBox(height: 50),
                  ],
                );

                return fullScreen
                    ? player
                    : SingleChildScrollView(child: content);
              }),
    );
  }
}
