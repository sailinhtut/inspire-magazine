import 'package:flutter/material.dart';
import 'package:inspired_blog/magazine/model/magazine.dart';
import 'package:inspired_blog/magazine/view/components/magazine_card_widget.dart';

class MagazineHorizontalList extends StatelessWidget {
  const MagazineHorizontalList({
    super.key,
    required this.magazineList,
  });

  final List<Magazine> magazineList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...magazineList.map((e) => MagazineCard(magazine: e)),
          ],
        ),
      ),
    );
  }
}
