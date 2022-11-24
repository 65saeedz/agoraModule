import 'package:agora15min/widgets/stack_profile_pic.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/audio/audio_controller.dart';
import '../widgets/caller_button.dart';
import '../widgets/custom_fab.dart';
import '../widgets/timerbox.dart';

class VoiceCallPage extends StatefulWidget {
  final RtcEngine agoraEngine;
  final String peerName;
  final String peerImageUrl;

  const VoiceCallPage({
    super.key,
    required this.agoraEngine,
    required this.peerName,
    required this.peerImageUrl,
  });

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  final _users = <int>[];
  final _infostring = <String>[];
  bool muted = false;
  bool videoOff = false;
  final CustomTimerController _controller = CustomTimerController();
  bool viewPanel = false;
  bool onSpeaker = false;
  AudioController audioController = Get.find();

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
    widget.agoraEngine.leaveChannel();
    widget.agoraEngine.destroy();

    super.dispose();
  }

  Future<void> _initialize() async {
    widget.agoraEngine.setEventHandler(RtcEngineEventHandler(
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
          _controller.start();
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'user offline:$uid';
          _infostring.add(info);
          // _users.remove(uid);
          _users.clear();
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'first remote video :$uid $width *$height';
          _infostring.add(info);
        });
      },
    ));
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
                controller: _controller,
                color: const Color(0xff353551),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomFAB(iconAddress: 'assets/images/add.svg', func: () {}),
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
                      iconAddress: 'assets/images/microphone-off.svg',
                      func: () {
                        setState(() {
                          muted = !muted;
                        });
                        widget.agoraEngine.muteLocalAudioStream(muted);
                      }),
                  CallerButton(
                    color: const Color(0xffFF4647),
                    func: () {
                      Navigator.of(context).pop();
                      audioController.player.stop();
                    },
                    svgIconAddress: 'assets/images/Call.svg',
                  ),
                  CustomFAB(
                      iconAddress: 'assets/images/volume-high.svg',
                      func: () {
                        setState(() {
                          onSpeaker = !onSpeaker;
                        });
                        widget.agoraEngine.setEnableSpeakerphone(onSpeaker);
                        print(onSpeaker);
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
