import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/video_call_page.dart';
import '../pages/voice_call_page.dart';
import '../models/enums/enums.dart';
import '../pages/calling_snack.dart';
import '../controllers/audio/audio_controller.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final user1Id = '149';
  final user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxNDksInVzZXJfcm9sZV9pZCI6MTQ5LCJsYW5ndWFnZV9zaXRfaWQiOiIxIiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjcwMTQ1NDEwLCJleHAiOjE2NzM3NDU0MTB9.iq-OiWxq_tX89G61F5ki0umdQ2czP78UKSj3TBjYV6M';
  final user1Name = 'User Test 1';
  final user1ImageUrl =
      'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';
  final user2Id = '135';
  final user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMzUsInVzZXJfcm9sZV9pZCI6MTM1LCJsYW5ndWFnZV9zaXRfaWQiOiI0IiwibGFuZ3VhZ2VfdXNlcl9pZCI6IjIiLCJpYXQiOjE2NzAxNDAwNTYsImV4cCI6MTY3Mzc0MDA1Nn0.uZuUftk-dteOt-ySiiix76yHFvHPvRQyR4qlkeJscX0';
  final user2Name = 'User Test 2';
  final user2ImageUrl =
      'https://baelm.net/wp-content/uploads/2014/06/aujrmetyazkenpzv6doe.jpg';
  final channelName = 'chat_149';
  UserRole? userRole = UserRole.callMaker;

  final audioController = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                RadioListTile(
                    title: const Text('Call maker '),
                    value: UserRole.callMaker,
                    groupValue: userRole,
                    onChanged: (UserRole? value) {
                      setState(() {
                        userRole = value;
                      });
                    }),
                RadioListTile(
                    title: const Text('Call receiver '),
                    value: UserRole.callReciver,
                    groupValue: userRole,
                    onChanged: (UserRole? value) {
                      setState(() {
                        userRole = value;
                      });
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.video_camera_back_outlined,
                        ),
                        onPressed: onVideoCall,
                        label: const Text('Video Call')),
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.call,
                        ),
                        onPressed: onVoiceCall,
                        label: const Text('Voice Call')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onVideoCall() async {
    switch (userRole) {
      case UserRole.callMaker:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              userId: user1Id,
              userToken: user1Token,
              peerId: user2Id,
              peerName: user2Name,
              peerImageUrl: user2ImageUrl,
              channelName: channelName,
            ),
          ),
        );
        break;

      case UserRole.callReciver:
        CallingSnack(
          context,
          callType: CallType.videoCall,
          userId: user2Id,
          userToken: user2Token,
          peerId: user1Id,
          peerName: user1Name,
          peerImageUrl: user1ImageUrl,
          channelName: channelName,
        ).show();
        break;

      default:
        break;
    }
  }

  Future<void> onVoiceCall() async {
    switch (userRole) {
      case UserRole.callMaker:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallPage(
              userId: user1Id,
              userToken: user1Token,
              peerId: user2Id,
              peerName: user2Name,
              peerImageUrl: user2ImageUrl,
              channelName: channelName,
            ),
          ),
        );
        break;

      case UserRole.callReciver:
        CallingSnack(
          context,
          callType: CallType.voiceCall,
          userId: user2Id,
          userToken: user2Token,
          peerId: user1Id,
          peerName: user1Name,
          peerImageUrl: user1ImageUrl,
          channelName: channelName,
        ).show();
        break;

      default:
        break;
    }
  }
}
