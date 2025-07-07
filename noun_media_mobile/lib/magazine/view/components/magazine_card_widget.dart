import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inspired_blog/app/view/components/image_place_holder.dart';
import 'package:inspired_blog/magazine/model/magazine.dart';
import 'package:inspired_blog/magazine/view/magazine_detail_screen.dart';
import 'package:inspired_blog/utils/functions.dart';

class MagazineCard extends StatelessWidget {
  const MagazineCard({super.key, required this.magazine});

  final Magazine magazine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
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
                MagazineDetailScreen(parentMagazine: magazine),
            closedBuilder: (_, __) => Card(
              color: context.surfaceColor,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: context.primary,
              elevation: 2,
              child: SizedBox(
                height: 150,
                width: 115,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: magazine.coverPhoto!,
                    fit: BoxFit.fill,
                    height: 150,
                    errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                    placeholder: (_, __) => const ImagePlaceHolder(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            magazine.name.toString(),
            textScaleFactor: 0.9,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
