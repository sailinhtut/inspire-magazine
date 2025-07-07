import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inspired_blog/app/view/components/image_place_holder.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';
import 'package:inspired_blog/entertainment/view/entertainment_detail_screen.dart';
import 'package:inspired_blog/utils/functions.dart';

class EntertainmentCard extends StatelessWidget {
  const EntertainmentCard({super.key, required this.entertainment});

  final Entertainment entertainment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 5, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OpenContainer(
            closedColor: Colors.transparent,
            openColor: Colors.transparent,
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            openBuilder: (_, __) =>
                EntertainmentDetailScreen(parentEntertainment: entertainment),
            closedBuilder: (_, __) => Card(
              color: context.surfaceColor,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: SizedBox(
                height: 140,
                width: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: entertainment.coverPhoto!,
                    fit: BoxFit.fill,
                    height: 150,
                    width: 220,
                    errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                    placeholder: (_, __) => const ImagePlaceHolder(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entertainment.name ?? "",
                  textScaleFactor: 0.9,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.play_circle_outline_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class EntertainmentCard2 extends StatelessWidget {
  const EntertainmentCard2({super.key, required this.entertainment});

  final Entertainment entertainment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OpenContainer(
            closedColor: Colors.transparent,
            openColor: Colors.transparent,
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            openBuilder: (_, __) =>
                EntertainmentDetailScreen(parentEntertainment: entertainment),
            closedBuilder: (_, __) => Card(
              color: context.surfaceColor,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: context.primary,
              elevation: 2,
              child: SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: entertainment.coverPhoto!,
                    fit: BoxFit.fitHeight,
                    height: 150,
                    errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                    placeholder: (_, __) => const ImagePlaceHolder(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              entertainment.name ?? "",
              textScaleFactor: 0.9,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
