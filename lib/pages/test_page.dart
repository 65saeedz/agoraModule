import 'dart:async';
import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/calling_page.dart';
import 'package:agora15min/pages/video_call_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
import 'call_page.dart';
import 'package:flutter/material.dart';

enum UserRole { callMaker, callReciver }

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _channelController = TextEditingController();
  final TextEditingController _uidTokenController = TextEditingController();
  final TextEditingController _peerUidController = TextEditingController();
  final TextEditingController _userUidController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userImageAddressController =
      TextEditingController();
  bool _validatorError = false;
  UserRole? userRole = UserRole.callMaker;
  String userDefaultNetworkImageAddress =
      'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';

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
              TextField(
                controller: _userUidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorText: _validatorError ? 'user Uid is mandatory' : null,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Enter user Id '),
              ),
              TextField(
                controller: _uidTokenController,
                decoration: InputDecoration(
                    errorText: _validatorError
                        ? 'Enter User App Token is mandatory'
                        : null,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Enter User App  Token'),
              ),
              TextField(
                controller: _peerUidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorText: _validatorError ? 'peer Id is mandatory' : null,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Enter peer Id '),
              ),
              if (userRole == UserRole.callReciver)
                TextField(
                  controller: _channelController,
                  decoration: InputDecoration(
                      errorText:
                          _validatorError ? 'Channel name is mandatory' : null,
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: 'Enter Channel name '),
                ),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Enter User name'),
              ),
              TextField(
                controller: _userImageAddressController,
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Enter User network image address  (optional)'),
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
                      icon: Icon(
                        Icons.video_camera_back_outlined,
                      ),
                      onPressed: onVideoCall,
                      label: const Text('Video Call')),
                  ElevatedButton.icon(
                      icon: Icon(
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
          userId: _userUidController.text,
          userToken: _uidTokenController.text,
          peerId: _peerUidController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallPage(
              networkImageAddress: _userImageAddressController.text == ''
                  ? userDefaultNetworkImageAddress
                  : _userImageAddressController.text,
              peerName: _userNameController.text == ''
                  ? 'user test'
                  : _userNameController.text,
              agoraEngine: agoraClient.engine,
            ),
          ),
        );
        break;

      case UserRole.callReciver:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingPage(
              peerImageUrl: _userImageAddressController.text == ''
                  ? userDefaultNetworkImageAddress
                  : _userImageAddressController.text,
              peerName: _userNameController.text == ''
                  ? 'caller user'
                  : _userNameController.text,
              callType: CallType.voiceCall,
              onAccepted: () async {
                await agoraClient.receiveCall(
                  callType: CallType.voiceCall,
                  userId: _userUidController.text,
                  userToken: _uidTokenController.text,
                  peerId: _peerUidController.text,
                  channelName: _channelController.text,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoiceCallPage(
                      networkImageAddress:
                          _userImageAddressController.text == ''
                              ? userDefaultNetworkImageAddress
                              : _userImageAddressController.text,
                      peerName: _userNameController.text == ''
                          ? 'receiver user'
                          : _userNameController.text,
                      agoraEngine: agoraClient.engine,
                    ),
                  ),
                );
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
          userId: _userUidController.text,
          userToken: _uidTokenController.text,
          peerId: _peerUidController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              networkImageAddress: _userImageAddressController.text == ''
                  ? userDefaultNetworkImageAddress
                  : _userImageAddressController.text,
              peerName: _userNameController.text == ''
                  ? 'caller user'
                  : _userNameController.text,
              agoraEngine: agoraClient.engine,
            ),
          ),
        );
        break;

      case UserRole.callReciver:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingPage(
              peerImageUrl: _userImageAddressController.text == ''
                  ? userDefaultNetworkImageAddress
                  : _userImageAddressController.text,
              peerName: _userNameController.text == ''
                  ? 'receiver user'
                  : _userNameController.text,
              callType: CallType.videoCall,
              onAccepted: () async {
                await agoraClient.receiveCall(
                  callType: CallType.videoCall,
                  userId: _userUidController.text,
                  userToken: _uidTokenController.text,
                  peerId: _peerUidController.text,
                  channelName: _channelController.text,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallPage(
                      networkImageAddress:
                          _userImageAddressController.text == ''
                              ? userDefaultNetworkImageAddress
                              : _userImageAddressController.text,
                      peerName: _userNameController.text == ''
                          ? 'user test'
                          : _userNameController.text,
                      agoraEngine: agoraClient.engine,
                    ),
                  ),
                );
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
