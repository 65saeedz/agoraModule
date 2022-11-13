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

class StackProfilePic extends StatelessWidget {
  const StackProfilePic({
    Key? key,
    required this.peerImageUrl,
    required this.color,
  }) : super(key: key);

  final String peerImageUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      //  fit: StackFit.expand,
      //   alignment: AlignmentDirectional.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: Color.fromRGBO(14, 185, 123, .15), width: 1),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              //  color: Colors.black87,
              shape: BoxShape.circle,
              border: Border.all(
                  color: Color.fromRGBO(14, 185, 123, .22), width: 1),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Color.fromRGBO(14, 185, 123, .54), width: 2),
              ),
              child: Container(
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                          color: Color(0xff11BE7F))
                    ]
                    // border: Border.all(
                    //     color: Color.fromRGBO(14, 185, 123, 1), width: 1),
                    ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: peerImageUrl,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
