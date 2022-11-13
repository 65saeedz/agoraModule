import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimerBox extends StatelessWidget {
  final double circleSize;
  final double height;
  final double borderCirular;
  final double width;
  final Color? color;
  final CustomTimerController controller;
  const TimerBox({
    required this.color,
    required this.height,
    required this.width,
    required this.borderCirular,
    required this.circleSize,
    required this.controller,
    Key? key,
    required,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderCirular),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: circleSize,
            width: circleSize,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          ),
          SizedBox(
            width: 12,
          ),
          CustomTimer(
              controller: controller,
              begin: Duration(seconds: 0),
              end: Duration(hours: 11),
              builder: (remaining) {
                print(remaining.hours);
                return remaining.hours != '00'
                    ? Text(
                        "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )
                    : Text(
                        "${remaining.minutes}:${remaining.seconds}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      );
              }),
        ],
      ),
    );
  }
}