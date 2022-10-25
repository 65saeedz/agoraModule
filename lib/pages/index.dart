import 'dart:async';
import 'dart:developer';
import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/models/agora_token_query.dart';
import 'package:agora15min/clients/http_client.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call.dart';
import 'package:flutter/material.dart';

enum UserRole { callMaker, callReciver }

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final TextEditingController _channelController = TextEditingController();
  final TextEditingController _uidTokenController = TextEditingController();
  final TextEditingController _peerUidController = TextEditingController();
  final TextEditingController _userUidController = TextEditingController();
  bool _validatorError = false;
  // ClientRole _role = ClientRole.Broadcaster;
  UserRole? userRole = UserRole.callMaker;

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
                keyboardType: TextInputType.number,
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
              ElevatedButton(onPressed: onJoin, child: const Text('Join'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    final agoraClient = AgoraClient();
    switch (userRole) {
      case UserRole.callMaker:
        await agoraClient.makeCall(
          userId: _userUidController.text,
          userToken: _uidTokenController.text,
          peerId: _peerUidController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              agoraEngine: agoraClient.engine,
            ),
          ),
        );
        break;
      case UserRole.callReciver:
        await agoraClient.receiveCall(
          userId: _userUidController.text,
          userToken: _uidTokenController.text,
          peerId: _peerUidController.text,
          channelName: _channelController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              agoraEngine: agoraClient.engine,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }
}
