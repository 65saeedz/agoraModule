import 'dart:async';
import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/calling_snack.dart';
import 'package:flutter/material.dart';

enum UserRole { callMaker, callReciver }

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final user1Id = '111';
  final user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMTEsInVzZXJfcm9sZV9pZCI6MTExLCJsYW5ndWFnZV9zaXRfaWQiOiIxIiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjY3ODcxMjYyLCJleHAiOjE2NzE0NzEyNjJ9.Ho0HmkTr8RnDD9-AdoyVDrg0T9gnh_Muhx1uPpSGaJ8';
  final user1Name = 'User Test 1';
  final user1ImageUrl =
      'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';
  final user2Id = '114';
  final user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMTQsInVzZXJfcm9sZV9pZCI6MTE0LCJsYW5ndWFnZV9zaXRfaWQiOiI0IiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjY3ODkzODIxLCJleHAiOjE2NzE0OTM4MjF9.r0cGeIF9C02KSfJboNClcHeQ9fqwbzb5BHQElbuLgGU';
  final user2Name = 'User Test 2';
  final user2ImageUrl =
      'https://baelm.net/wp-content/uploads/2014/06/aujrmetyazkenpzv6doe.jpg';
  final channelName = 'chat_111';

  UserRole? userRole = UserRole.callMaker;

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

  Future<void> onVoiceCall() async {
    final agoraClient = AgoraClient();

    switch (userRole) {
      case UserRole.callMaker:
        agoraClient.makeCall(
          context,
          callType: CallType.voiceCall,
          userId: user1Id,
          userToken: user1Token,
          peerId: user2Id,
          peerName: user2Name,
          peerImageUrl: user2ImageUrl,
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

  Future<void> onVideoCall() async {
    final agoraClient = AgoraClient();

    switch (userRole) {
      case UserRole.callMaker:
        agoraClient.makeCall(
          context,
          callType: CallType.videoCall,
          userId: user1Id,
          userToken: user1Token,
          peerId: user2Id,
          peerName: user2Name,
          peerImageUrl: user2ImageUrl,
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
}
