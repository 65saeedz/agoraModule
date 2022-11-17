import 'dart:async';
import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/calling_page.dart';
import 'package:agora15min/pages/video_call_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
import 'package:flutter/material.dart';

enum UserRole { callMaker, callReciver }

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final String user1Id = '111';
  final String user2Id = '114';
  final String user1Name = 'User Test 1';
  final String user2Name = 'User Test 2';
  final String user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMTEsInVzZXJfcm9sZV9pZCI6MTExLCJsYW5ndWFnZV9zaXRfaWQiOiIxIiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjY3ODcxMjYyLCJleHAiOjE2NzE0NzEyNjJ9.Ho0HmkTr8RnDD9-AdoyVDrg0T9gnh_Muhx1uPpSGaJ8';
  final String user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMTQsInVzZXJfcm9sZV9pZCI6MTE0LCJsYW5ndWFnZV9zaXRfaWQiOiI0IiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjY3ODkzODIxLCJleHAiOjE2NzE0OTM4MjF9.r0cGeIF9C02KSfJboNClcHeQ9fqwbzb5BHQElbuLgGU';
  final String user1NetworkImageAddress =
      'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';
  final String user2NetworkImageAddress =
      'https://s.cafebazaar.ir/images/upload/screenshot/Amir.ID_Border1.jpg';
  final TextEditingController _channelController = TextEditingController();
  UserRole? userRole = UserRole.callMaker;
  // final TextEditingController _uidTokenController = TextEditingController();
  // final TextEditingController _peerUidController = TextEditingController();
  // final TextEditingController _userUidController = TextEditingController();
  // final TextEditingController _userNameController = TextEditingController();
  // final TextEditingController _userImageAddressController =
  //     TextEditingController();
  // final bool _validatorError = false;
  // String userDefaultNetworkImageAddress =
  //     'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              // TextField(
              //   controller: _userUidController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //       errorText: _validatorError ? 'user Uid is mandatory' : null,
              //       border: const UnderlineInputBorder(
              //         borderSide: BorderSide(width: 1),
              //       ),
              //       hintText: 'Enter user Id '),
              // ),
              // TextField(
              //   controller: _uidTokenController,
              //   decoration: InputDecoration(
              //       errorText: _validatorError
              //           ? 'Enter User App Token is mandatory'
              //           : null,
              //       border: const UnderlineInputBorder(
              //         borderSide: BorderSide(width: 1),
              //       ),
              //       hintText: 'Enter User App  Token'),
              // ),
              // TextField(
              //   controller: _peerUidController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //       errorText: _validatorError ? 'peer Id is mandatory' : null,
              //       border: const UnderlineInputBorder(
              //         borderSide: BorderSide(width: 1),
              //       ),
              //       hintText: 'Enter peer Id '),
              // ),
              // if (userRole == UserRole.callReciver)
              //   TextField(
              //     controller: _channelController,
              //     decoration: InputDecoration(
              //         errorText:
              //             _validatorError ? 'Channel name is mandatory' : null,
              //         border: const UnderlineInputBorder(
              //           borderSide: BorderSide(width: 1),
              //         ),
              //         hintText: 'Enter Channel name '),
              //   ),
              // TextField(
              //   controller: _userNameController,
              //   decoration: const InputDecoration(
              //       border: UnderlineInputBorder(
              //         borderSide: BorderSide(width: 1),
              //       ),
              //       hintText: 'Enter User name'),
              // ),
              // TextField(
              //   controller: _userImageAddressController,
              //   decoration: const InputDecoration(
              //       border: UnderlineInputBorder(
              //         borderSide: BorderSide(width: 1),
              //       ),
              //       hintText: 'Enter User network image address  (optional)'),
              // ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onVoiceCall() async {
    final agoraClient = AgoraClient();

    switch (userRole) {
      case UserRole.callMaker:
        await agoraClient.makeCall(
          callType: CallType.voiceCall,
          userId: user1Id,
          userToken: user1Token,
          peerId: user2Id,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VoiceCallPage(
                networkImageAddress: user2NetworkImageAddress,
                peerName: user2Name,
                agoraEngine: agoraClient.engine,
              ),
            ),
          );
        }
        break;

      case UserRole.callReciver:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingPage(
              peerImageUrl: user1NetworkImageAddress,
              peerName: user1Name,
              callType: CallType.voiceCall,
              onAccepted: () async {
                await agoraClient.receiveCall(
                  callType: CallType.voiceCall,
                  userId: user2Id,
                  userToken: user2Token,
                  peerId: user1Id,
                  channelName: 'chat_$user1Id',
                );
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceCallPage(
                        networkImageAddress: user1NetworkImageAddress,
                        peerName: user1Name,
                        agoraEngine: agoraClient.engine,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
        break;

      default:
        break;
    }
  }

  Future<void> onVideoCall() async {
    final agoraClient = AgoraClient();

    switch (userRole) {
      case UserRole.callMaker:
        await agoraClient.makeCall(
          callType: CallType.videoCall,
          userId: user1Id,
          userToken: user1Token,
          peerId: user2Id,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCallPage(
                networkImageAddress: user2NetworkImageAddress,
                peerName: user2Name,
                agoraEngine: agoraClient.engine,
              ),
            ),
          );
        }
        break;

      case UserRole.callReciver:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingPage(
              peerImageUrl: user1NetworkImageAddress,
              peerName: user1Name,
              callType: CallType.videoCall,
              onAccepted: () async {
                await agoraClient.receiveCall(
                  callType: CallType.videoCall,
                  userId: user2Id,
                  userToken: user2Token,
                  peerId: user1Id,
                  channelName: 'chat_$user1Id',
                );
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallPage(
                        networkImageAddress: user1NetworkImageAddress,
                        peerName: user1Name,
                        agoraEngine: agoraClient.engine,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
        break;

      default:
        break;
    }
  }
}
