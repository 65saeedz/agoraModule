import 'dart:ui';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

import '../models/enums/user_role.dart';
import '../pages/video_call_page.dart';
import '../widgets/caller_button.dart';
import '../clients/agora_client.dart';
import '../models/enums/call_type.dart';
import '../pages/voice_call_page.dart';
import '../controllers/audio/audio_controller.dart';
import '../widgets/stack_profile_pic.dart';

class CallingPage extends StatefulWidget {
  final CallType callType;
  final String userId;
  final String userToken;
  final String peerId;
  final String peerName;
  final String peerImageUrl;
  final String channelName;
  final String callId;

  const CallingPage({
    Key? key,
    required this.callType,
    required this.userId,
    required this.userToken,
    required this.peerId,
    required this.peerName,
    required this.peerImageUrl,
    required this.channelName,
    required this.callId,
  }) : super(key: key);

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  final AudioController _audioController = Get.find();
  AgoraClient agoraClient = AgoraClient();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: CachedNetworkImage(
              imageUrl: widget.peerImageUrl,
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
                color: const Color.fromRGBO(24, 24, 29, 0.87),
              ),
            ),
          ),
          _buildTopElement(context),
        ],
      ),
    );
  }

  Widget _buildTopElement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 46),
      child: Column(
        children: [
          StackProfilePic(
              peerImageUrl: widget.peerImageUrl, color: Colors.black87),
          const SizedBox(
            height: 16,
          ),
          Text(
            widget.peerName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.callType == CallType.voiceCall
                ? 'Voice Calling ...'
                : 'Video Calling ...',
            style: const TextStyle(
                color: Color(0xff86858A),
                fontWeight: FontWeight.w400,
                fontSize: 23),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CallerButton(
                func: () {
                  Navigator.of(context).pop();
                  _audioController.stopTone();
                  Vibration.cancel();
                  agoraClient.cancelFromReceiver(
                      token: widget.userToken, receiverCallId: widget.callId);
                },
                color: Color(0xffFF4647),
                imageIconAddress: 'assets/images/Call.png',
              ),
              CallerButton(
                  func: _onAccepted,
                  color: Color(0xff11BE7F),
                  imageIconAddress: 'assets/images/accept_call.png'),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _onAccepted() async {
    final agoraClient = AgoraClient();
    Vibration.cancel();

    _audioController.stopTone();
    await agoraClient.receiveCall(
        callType: widget.callType,
        userId: widget.userId,
        userToken: widget.userToken,
        peerId: widget.peerId,
        channelName: widget.channelName,
        callId: widget.callId);
    if (mounted) {
      switch (widget.callType) {
        case CallType.voiceCall:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VoiceCallPage(
                callId: widget.callId,
                channelName: widget.channelName,
                peerName: widget.peerName,
                peerId: widget.peerId,
                userId: widget.userId,
                peerImageUrl: widget.peerImageUrl,
                userRole: UserRole.callReciver,
                userToken: widget.userToken,
              ),
            ),
          );
          break;
        case CallType.videoCall:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCallPage(
                callId: widget.callId,
                channelName: widget.channelName,
                peerName: widget.peerName,
                peerId: widget.peerId,
                userId: widget.userId,
                peerImageUrl: widget.peerImageUrl,
                userRole: UserRole.callReciver,
                userToken: widget.userToken,
              ),
            ),
          );
          break;
      }
    }
  }
}
