import 'dart:ui';

import 'package:agora15min/pages/video_call_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/voice_call_page.dart';

import '../widgets/stack_profile_pic.dart';

class CallingPage extends StatefulWidget {
  final CallType callType;
  final String userId;
  final String userToken;
  final String peerId;
  final String peerName;
  final String peerImageUrl;
  final String channelName;

  const CallingPage({
    Key? key,
    required this.callType,
    required this.userId,
    required this.userToken,
    required this.peerId,
    required this.peerName,
    required this.peerImageUrl,
    required this.channelName,
  }) : super(key: key);

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              FloatingActionButton.extended(
                  backgroundColor: const Color(0xffFF4647),
                  extendedPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 52),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: SvgPicture.asset('assets/images/Call.svg')),
              FloatingActionButton.extended(
                backgroundColor: const Color(0xff11BE7F),
                extendedPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 52),
                onPressed: _onAccepted,
                label: SvgPicture.asset('assets/images/accept_call.svg'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _onAccepted() async {
    final agoraClient = AgoraClient();

    await agoraClient.receiveCall(
      callType: widget.callType,
      userId: widget.userId,
      userToken: widget.userToken,
      peerId: widget.peerId,
      channelName: widget.channelName,
    );
    if (mounted) {
      switch (widget.callType) {
        case CallType.voiceCall:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VoiceCallPage(
                agoraEngine: agoraClient.engine,
                peerName: widget.peerName,
                peerImageUrl: widget.peerImageUrl,
              ),
            ),
          );
          break;
        case CallType.videoCall:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCallPage(
                agoraEngine: agoraClient.engine,
                peerName: widget.peerName,
              ),
            ),
          );
          break;
      }
    }
  }
}
