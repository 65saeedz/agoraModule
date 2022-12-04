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
      extendedPadding: EdgeInsets.symmetric(
          vertical: 26,
          horizontal:
              imageIconAddress == 'assets/images/accept_call.png' ? 62 : 56),
      onPressed: func,
      label: Image.asset(
        imageIconAddress,
        width: imageIconAddress == 'assets/images/accept_call.png' ? 31 : 40,
        height: imageIconAddress == 'assets/images/accept_call.png' ? 32 : 40,
      ),
    );
  }
}
