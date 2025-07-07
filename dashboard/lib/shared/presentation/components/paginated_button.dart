import 'package:flutter/material.dart';

class PaginateButton extends StatelessWidget {
  const PaginateButton(this.text,
      {super.key, this.onPressed,  this.active = false});

  final VoidCallback? onPressed;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: active
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                minimumSize: const Size(35, 35),
              ),
              onPressed: onPressed,
              child: Text(text))
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                minimumSize: const Size(35, 35),
              ),
              onPressed: onPressed,
              child: Text(text)),
    );
  }
}
