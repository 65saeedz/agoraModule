import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import '../clients/agora_client.dart';
import '../models/enums/call_type.dart';
import '../controllers/audio/audio_controller.dart';
import '../models/enums/user_role.dart';
import '../widgets/caller_button.dart';
import '../widgets/custom_fab.dart';
import '../widgets/timerbox.dart';

class VideoCallPage extends StatefulWidget {
  VideoCallPage({
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
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  RtcEngine? _agoraEngine;
  final _users = <int>[];
  final _infostring = <String>[];
  String? _channel;
  bool _muted = false;
  bool _videoOff = false;

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
    Wakelock.disable();
  }

  Future<void> _initialize() async {
    if (widget.userRole == UserRole.callMaker) {
      _agoraEngine = await widget.agoraClient.makeCall(
        callType: CallType.videoCall,
        userId: widget.userId,
        userToken: widget.userToken,
        peerId: widget.peerId,
      );
      // widget.audioController.playCallingTone();
    } else {
      _agoraEngine = await widget.agoraClient.receiveCall(
        callType: CallType.videoCall,
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
        error: (code) {
          setState(() {
            final info = 'error :$code';
            _infostring.add(info);
          });
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          setState(() {
            final info = 'joined channel:$channel ,uid :$uid';
            _infostring.add(info);
            _channel = channel;
          });
        },
        leaveChannel: (stats) {
          setState(() {
            _infostring.add('leave channel');
            _users.clear();
            // Future.delayed(Duration(seconds: 5))
            //     .then((Value) => Navigator.pop(context));
          });
        },
        userJoined: (uid, elapsed) {
          setState(() {
            final info = 'user joined:$uid';
            _infostring.add(info);
            _users.add(uid);
            widget.timerController.start();
            widget.audioController.stopTone();
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            final info = 'user offline:$uid';
            _infostring.add(info);
            _users.clear();
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

    _agoraEngine!.setEnableSpeakerphone(true);
    _agoraEngine!.setDefaultAudioRouteToSpeakerphone(true);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Wakelock.enable();
    return Scaffold(
      backgroundColor: const Color(0xff26263F),
      body: Stack(
        children: [
          _users.isEmpty
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff26263F),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xff26263F), Colors.transparent]),
                  ),
                  child: _agoraEngine == null
                      ? null
                      : const rtc_local_value.SurfaceView(),
                )
              : Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff26263F),
                  ),
                  child: _agoraEngine == null
                      ? null
                      : rtc_remote_value.SurfaceView(
                          uid: _users.first,
                          channelId: _channel!,
                        ),
                ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 48),
            width: width,
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Color(0xff26263F), Colors.transparent]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                    _users.isEmpty
                        ? const SizedBox(
                            width: 84,
                            height: 114,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 84,
                              height: 114,
                              decoration: BoxDecoration(
                                color: const Color(0xff26263F),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _agoraEngine == null
                                  ? null
                                  : const rtc_local_value.SurfaceView(),
                            ),
                          ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: 'Video Call with \n',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.peerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _users.isNotEmpty
                            ? TimerBox(
                                borderCirular: 16.5,
                                width: 88,
                                height: 32,
                                circleSize: 7,
                                controller: widget.timerController,
                                color: const Color.fromRGBO(41, 45, 50, 0.38),
                              )
                            : const SizedBox(
                                width: 88,
                                height: 32,
                              ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomFAB(
                            iconAddress: 'assets/images/add.png', func: () {}),
                        CustomFAB(
                            iconAddress: 'assets/images/messages.png',
                            func: () {}),
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
                        CustomFAB(
                            iconAddress: _videoOff
                                ? 'assets/images/video-off.png'
                                : 'assets/images/video-on.png',
                            func: (_agoraEngine == null || _users.isEmpty)
                                ? null
                                : () {
                                    setState(() {
                                      _videoOff = !_videoOff;
                                    });
                                    _agoraEngine!
                                        .muteLocalVideoStream(_videoOff);
                                  }),
                      ],
                    )
                  ],
                ),
                CallerButton(
                  color: const Color(0xffFF4647),
                  func: () {
                    widget.audioController.stopTone();
                    Navigator.of(context).pop();
                  },
                  imageIconAddress: 'assets/images/Call.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
