import 'package:flutter/material.dart';

class CallerButton extends StatelessWidget {
  final void Function() func;
  final Color color;
  final String imageIconAddress;
  const CallerButton({
    Key? key,
    required this.func,
    required this.color,
    required this.imageIconAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: color,
      extendedPadding: const EdgeInsets.symmetric(vertical: 26, horizontal: 56),
      onPressed: func,
      label: Image.asset(
        imageIconAddress,
        width: 40,
        height: 40,
      ),
    );
  }
}
