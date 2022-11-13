import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallerButton extends StatelessWidget {
  final void Function() func;
  final Color color;
  final String svgIconAddress;
  const CallerButton({
    Key? key,
    required this.func,
    required this.color,
    required this.svgIconAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: color,
      extendedPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 52),
      onPressed: func,
      label: SvgPicture.asset(svgIconAddress),
    );
  }
}
