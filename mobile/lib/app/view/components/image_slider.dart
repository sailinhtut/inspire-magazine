import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:inspired_blog/app/model/header_image.dart';
import 'package:inspired_blog/app/service/screen_route_service.dart';
import 'package:inspired_blog/app/view/components/image_place_holder.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key, required this.imageList});

  final List<HeaderImage> imageList;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 220.0,
            autoPlay: true,
            aspectRatio: 4 / 3,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: widget.imageList.map((i) {
            return GestureDetector(
              onTap: () async {
                if (i.isWebUrl) {
                  launchUrlString(i.redirect!,
                      mode: LaunchMode.externalApplication);
                } else if (i.isRouteMeta) {
                  final route = i.parsedMeta["route"];
                  if (route != null && route.isNotEmpty) {
                    NounRouter.launchRoute(route, i.parsedMeta);
                  }
                }
              },
              onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (_) {
                      return SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            if (i.name != null)
                              ListTile(
                                dense: true,
                                title: Text(i.name!,
                                    style:
                                        const TextStyle(color: Colors.black)),
                                trailing: const Icon(Icons.link),
                              ),
                            if (i.isWebUrl)
                              ListTile(
                                  dense: true,
                                  title: Text(i.redirect!,
                                      textScaleFactor: 1,
                                      style:
                                          const TextStyle(color: Colors.black)))
                          ],
                        ),
                      );
                    });
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: i.imageUrl!,
                  height: 220,
                  fit: BoxFit.fill,
                  errorWidget: (_, __, ___) => const ImagePlaceHolder(),
                  placeholder: (_, __) => const ImagePlaceHolder(),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: widget.imageList.length,
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
