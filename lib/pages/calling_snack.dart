import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/controllers/audio/audio_controller.dart';
import 'package:agora15min/pages/video_call_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:agora15min/pages/calling_page.dart';
import 'package:agora15min/models/enums/call_type.dart';

class CallingSnack {
  final BuildContext context;
  final CallType callType;
  final String userId;
  final String userToken;
  final String peerId;
  final String peerName;
  final String peerImageUrl;
  final String channelName;

  late AnimationController _animationController;

  CallingSnack(
    this.context, {
    required this.callType,
    required this.userId,
    required this.userToken,
    required this.peerId,
    required this.peerName,
    required this.peerImageUrl,
    required this.channelName,
  });
  AudioController audioController = Get.find();

  void show() {
    audioController.playRingTone();

    showTopSnackBar(
      Overlay.of(context)!,
      _buildChild(),
      padding: EdgeInsets.fromLTRB(24, 64, 24, 16),
      displayDuration: Duration(seconds: 130),
      onAnimationControllerInit: (controller) {
        _animationController = controller;
      },
      dismissType: DismissType.onSwipe,
      dismissDirection: const [
        DismissDirection.up,
      ],
    );
  }

  Widget _buildChild() {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 16,
                spreadRadius: 0,
                color: Color.fromRGBO(197, 197, 197, 0.26))
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        height: 80,
        child: Row(
          children: [
            Container(
              width: 55, height: 55,
              // color: Colors.amber,
              margin: EdgeInsets.fromLTRB(12, 0, 6, 0),
              //  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: peerImageUrl,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DefaultTextStyle(
                  child: Text(
                    peerName,
                  ),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(48, 54, 63, 1)),
                ),
                SizedBox(
                  height: 6,
                ),
                DefaultTextStyle(
                  child: Text(
                    callType == CallType.videoCall
                        ? 'Video Calling ...'
                        : 'Voice Calling ...',
                  ),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(134, 133, 138, 1)),
                )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                _animationController.reverse();
                audioController.player.stop();
              },
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      color: Color.fromRGBO(17, 190, 127, 0.21))
                ], shape: BoxShape.circle, color: Color(0xffFF4647)),
                child: Image.asset(
                  'assets/images/reject_call.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                _animationController.reverse();

                _onAccepted();
              },
              child: Container(
                padding: EdgeInsets.all(8.5),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      color: Color.fromRGBO(17, 190, 127, 0.21))
                ], shape: BoxShape.circle, color: Color(0xff11BE7F)),
                child: Image.asset(
                  'assets/images/accept_call.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    _animationController.reverse();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallingPage(
          callType: callType,
          userId: userId,
          userToken: userToken,
          peerId: peerId,
          peerImageUrl: peerImageUrl,
          peerName: peerName,
          channelName: channelName,
        ),
      ),
    );
  }

  void _onAccepted() async {
    audioController.player.stop();

    final agoraClient = AgoraClient();
    await agoraClient.receiveCall(
      callType: callType,
      userId: userId,
      userToken: userToken,
      peerId: peerId,
      channelName: channelName,
    );
    switch (callType) {
      case CallType.voiceCall:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallPage(
              agoraEngine: agoraClient.engine,
              peerName: peerName,
              peerImageUrl: peerImageUrl,
            ),
          ),
        );
        break;
      case CallType.videoCall:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              agoraEngine: agoraClient.engine,
              peerName: peerName,
            ),
          ),
        );
        break;
    }
  }
}
