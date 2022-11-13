import 'dart:ui';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/call_page.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

import '../widgets/stack_profile_pic.dart';

class CallingPage extends StatelessWidget {
  final String peerImageUrl;
  final String peerName;
  final CallType callType;
  final void Function() onAccepted;

  const CallingPage({
    super.key,
    required this.peerImageUrl,
    required this.peerName,
    required this.callType,
    required this.onAccepted,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: CachedNetworkImage(
              imageUrl: peerImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: Color.fromRGBO(24, 24, 29, 0.87),
              ),
            ),
          ),
          topElement(context),
        ],
      ),
    );
  }

  Container topElement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 46),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StackProfilePic(peerImageUrl: peerImageUrl, color: Colors.black87),
            SizedBox(
              height: 16,
            ),
            Text(
              peerName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              callType == CallType.voiceCall
                  ? 'Voice Calling ...'
                  : 'Video Calling ...',
              style: TextStyle(
                  color: Color(0xff86858A),
                  fontWeight: FontWeight.w400,
                  fontSize: 23),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                    backgroundColor: Color(0xffFF4647),
                    extendedPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 52),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: SvgPicture.asset('assets/images/Call.svg')),
                FloatingActionButton.extended(
                  backgroundColor: Color(0xff11BE7F),
                  extendedPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 52),
                  onPressed: onAccepted,
                  label: SvgPicture.asset('assets/images/accept_call.svg'),
                ),
              ],
            )
          ]),
    );
  }
}
