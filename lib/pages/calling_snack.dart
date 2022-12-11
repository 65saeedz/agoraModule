import 'package:agora15min/clients/agora_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vibration/vibration.dart';

import '../pages/calling_page.dart';
import '../models/enums/user_role.dart';
import '../controllers/audio/audio_controller.dart';
import '../pages/video_call_page.dart';
import '../pages/voice_call_page.dart';
import '../models/enums/call_type.dart';

class CallingSnack {
  final BuildContext context;
  final CallType callType;
  final String userId;
  final String userToken;
  final String peerId;
  final String peerName;
  final String peerImageUrl;
  final String channelName;
  final String callId;

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
    required this.callId,
  });
  final AudioController audioController = Get.put(AudioController());
  AgoraClient agoraClient = AgoraClient();
  bool isResponsed = false;
  bool isInCallingPage = false;
  void show() {
    audioController.playRingTone();
    Vibration.vibrate(
      pattern: List.generate(
        100,
        (index) {
          if (index == 0) {
            return 5;
          } else if (index.isOdd) {
            return 2800;
          } else
            return 1800;
        },
      ),
    );
    // timer part:
    // Future.delayed(
    //   Duration(
    //     seconds: 60,
    //   ),
    // ).then((value) {
    //   if (isResponsed == false && isInCallingPage == true) {
    //     audioController.stopTone();
    //     Vibration.cancel();
    //     agoraClient.cancelFromReceiver(
    //         token: userToken, receiverCallId: callId);
    //     Navigator.pop(context);
    //   }
    //   if (isResponsed == false) {
    //     onReject();
    //   }
    // });
    showTopSnackBar(
      Overlay.of(context)!,
      _buildChild(),
      padding: EdgeInsets.fromLTRB(24, 64, 24, 16),
      displayDuration: Duration(seconds: 130),
      onAnimationControllerInit: (controller) {
        _animationController = controller;
      },
      dismissType: DismissType.none,
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
                isResponsed = true;
                onReject();
              },
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      color: Color.fromRGBO(255, 70, 71, 0.21))
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

                Vibration.cancel();
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
    isInCallingPage = true;
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
          callId: callId,
        ),
      ),
    );
  }

  void _onAccepted() {
    isResponsed = true;
    switch (callType) {
      case CallType.voiceCall:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallPage(
              userRole: UserRole.callReciver,
              channelName: channelName,
              userToken: userToken,
              peerId: peerId,
              userId: userId,
              peerName: peerName,
              peerImageUrl: peerImageUrl,
              callId: callId,
            ),
          ),
        );
        break;
      case CallType.videoCall:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              userRole: UserRole.callReciver,
              channelName: channelName,
              userToken: userToken,
              peerId: peerId,
              userId: userId,
              peerName: peerName,
              peerImageUrl: peerImageUrl,
              callId: callId,
            ),
          ),
        );
        break;
    }
    audioController.stopTone();
  }

  void onReject() {
    _animationController.reverse();
    audioController.stopTone();
    Vibration.cancel();
    agoraClient.cancelFromReceiver(token: userToken, receiverCallId: callId);
  }

  void dismissSnackBar() {
    if (isResponsed == false && isInCallingPage == true) {
      audioController.stopTone();
      Vibration.cancel();
      agoraClient.cancelFromReceiver(token: userToken, receiverCallId: callId);
      Navigator.pop(context);
    }
    if (isResponsed == false) {
      onReject();
    }
  }
}
