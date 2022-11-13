import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomFAB extends StatelessWidget {
  const CustomFAB({
    Key? key,
    required this.iconAddress,
    required this.func,
  }) : super(key: key);

  final String iconAddress;
  final void Function() func;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        // decoration: BoxDecoration(color: Colors.white),
        width: 50,
        height: 50,
        child: RawMaterialButton(
          fillColor: Colors.white,
          shape: CircleBorder(),
          //  elevation: 0.0,
          child: SvgPicture.asset(
            iconAddress,
            color: Colors.black,
            width: 24,
          ),
          onPressed: func,
        ),
      ),
    );
  }
}