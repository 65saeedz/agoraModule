import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';




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
