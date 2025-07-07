import 'package:flutter/material.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';
import 'package:inspired_blog/entertainment/view/components/entertainment_card_widget.dart';

class EntertainmentHorizontalList extends StatelessWidget {
  const EntertainmentHorizontalList({
    super.key,
    required this.entertainments,
  });

  final List<Entertainment> entertainments;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...entertainments.map((e) => EntertainmentCard(entertainment: e))
          ],
        ),
      ),
    );
  }
}
