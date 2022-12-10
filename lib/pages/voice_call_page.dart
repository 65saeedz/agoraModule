import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../clients/agora_client.dart';
import '../models/enums/user_role.dart';
import '../models/enums/call_type.dart';
import '../widgets/stack_profile_pic.dart';
import '../controllers/audio/audio_controller.dart';
import '../widgets/caller_button.dart';
import '../widgets/custom_fab.dart';
import '../widgets/timerbox.dart';

class VoiceCallPage extends StatefulWidget {
  VoiceCallPage({
    super.key,
    this.userRole = UserRole.callMaker,
    required this.userId,
    required this.userToken,
    required this.peerId,
    required this.peerName,
    required this.peerImageUrl,
    required this.channelName,
    required this.callId,
  });

  final UserRole userRole;
  final String userId;
  final String userToken;
  final String peerId;
  final String peerName;
  final String peerImageUrl;
  final String channelName;
  final String callId;

  final agoraClient = AgoraClient();
  final timerController = CustomTimerController();
  final AudioController audioController = Get.put(AudioController());

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  RtcEngine? _agoraEngine;
  final _users = <int>[];
  final _infostring = <String>[];
  bool _muted = false;
  bool _onSpeaker = false;
  bool isAnyUserJoined = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    _initialize();

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

    _users.clear();
    if (_agoraEngine != null) {
      _agoraEngine!.leaveChannel();
      _agoraEngine!.destroy();
    }

    super.dispose();
  }

  Future<void> _initialize() async {
    if (widget.userRole == UserRole.callMaker) {
      _agoraEngine = await widget.agoraClient.makeCall(
        callType: CallType.voiceCall,
        userId: widget.userId,
        userToken: widget.userToken,
        peerId: widget.peerId,
      );
    } else {
      _agoraEngine = await widget.agoraClient.receiveCall(
        callType: CallType.voiceCall,
        userId: widget.userId,
        userToken: widget.userToken,
        peerId: widget.peerId,
        channelName: widget.channelName,
        callId: widget.callId,
      );
    }

    setState(() {});
    _agoraEngine!.setEventHandler(
      RtcEngineEventHandler(
        audioDeviceStateChanged: ((deviceId, deviceType, deviceState) {
          print(deviceId);
        }),
        audioRouteChanged: (routing) {
          setState(() {
            print(routing);
          });
        },
        error: (code) {
          setState(() {
            final info = 'error :$code';
            _infostring.add(info);
          });
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          setState(() {
            final info = 'joined channel:$channel ,uid :$uid';
            //  _channel = channel;
            _infostring.add(info);
          });
        },
        leaveChannel: (stats) {
          setState(() {
            _infostring.add('leave channel');
            _users.clear();
          });
        },
        userJoined: (uid, elapsed) {
          setState(() {
            final info = 'user joined:$uid';
            _infostring.add(info);
            _users.add(uid);
            widget.timerController.start();
            widget.audioController.stopTone();
            _agoraEngine!.setEnableSpeakerphone(_onSpeaker);
          });
          setState(() {});
        },
        userOffline: (uid, elapsed) {
          setState(() {
            final info = 'user offline:$uid';
            _infostring.add(info);
            _users.clear();
            Future.delayed(Duration(seconds: 3))
                .then((Value) => Navigator.pop(context));
          });
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {
          setState(() {
            final info = 'first remote video :$uid $width *$height';
            _infostring.add(info);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Color(0xff26263F),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 48),
        color: const Color(0xff26263F),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container()),
                Container(
                  width: 84,
                  //  height: 114,
                )
              ],
            ),
            StackProfilePic(
                color: const Color(0xff26263F),
                peerImageUrl: widget.peerImageUrl),
            const SizedBox(
              height: 46,
            ),
            Text(
              widget.peerName,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            if (_users.isNotEmpty)
              TimerBox(
                borderCirular: 22,
                circleSize: 10,
                height: 44,
                width: 102,
                controller: widget.timerController,
                color: const Color(0xff353551),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomFAB(iconAddress: 'assets/images/add.png', func: () {}),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomFAB(
                      iconAddress: _muted
                          ? 'assets/images/microphone-off.png'
                          : 'assets/images/microphone-on.png',
                      func: (_agoraEngine == null || _users.isEmpty)
                          ? null
                          : () {
                              setState(() {
                                _muted = !_muted;
                              });
                              _agoraEngine!.muteLocalAudioStream(_muted);
                            }),
                  CallerButton(
                    color: const Color(0xffFF4647),
                    func: () {
                      widget.audioController.stopTone();
                      if (isAnyUserJoined == false) {
                        // print('userToken is : ${widget.httpClient.userToken}' +
                        //     'call id is: ${widget.httpClient.callId}');
                        print('No one joined');
                        widget.agoraClient.cancelFromCaller();
                      }
                      Navigator.of(context).pop();
                    },
                    imageIconAddress: 'assets/images/Call.png',
                  ),
                  CustomFAB(
                      iconAddress: _onSpeaker
                          ? 'assets/images/volume-high.png'
                          : 'assets/images/volume-off.png',
                      func: (_agoraEngine == null || _users.isEmpty)
                          ? null
                          : () {
                              setState(() {
                                _onSpeaker = !_onSpeaker;
                              });
                              _agoraEngine!.setEnableSpeakerphone(_onSpeaker);
                              print(_onSpeaker);
                            }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
