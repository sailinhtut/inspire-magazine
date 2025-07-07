import 'package:flutter/material.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.horizontalRotatingDots(
          color: context.primary, size: 40),
    );
  }
}
