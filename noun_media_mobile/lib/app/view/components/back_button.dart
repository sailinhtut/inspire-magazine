import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackButtonArrow extends StatelessWidget {
  const BackButtonArrow({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed?.call();
        } else {
          Get.back();
        }
      },
      icon: const Icon(
        Icons.chevron_left_rounded,
        size: 35,
        color: Colors.white,
      ),
    );
  }
}
