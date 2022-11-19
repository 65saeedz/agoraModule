import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/pages/video_call_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/calling_page.dart';

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

  void show() {
    showTopSnackBar(
      Overlay.of(context)!,
      _buildChild(),
      padding: EdgeInsets.fromLTRB(16, 64, 16, 16),
      displayDuration: Duration(seconds: 60),
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
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        height: 90,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: peerImageUrl,
                ),
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                DefaultTextStyle(
                  child: Text(
                    peerName,
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(48, 54, 63, 1)),
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextStyle(
                  child: Text(
                    callType == CallType.videoCall
                        ? 'Video Calling ...'
                        : 'Voice Calling ...',
                  ),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(134, 133, 138, 1)),
                )
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _animationController.reverse();
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/images/Call.svg',
                  width: 28,
                  height: 12,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(14),
                backgroundColor: Color(0xffFF4647),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _animationController.reverse();
                _onAccepted();
              },
              child: SvgPicture.asset(
                'assets/images/accept_call.svg',
                width: 28,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                foregroundColor: const Color(0xff11BE7F),
              ),
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
