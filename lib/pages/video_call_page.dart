import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/caller_button.dart';
import '../widgets/custom_fab.dart';
import '../widgets/timerbox.dart';

class VideoCallPage extends StatefulWidget {
  final RtcEngine agoraEngine;
  final String peerName;

  const VideoCallPage({
    Key? key,
    required this.agoraEngine,
    required this.peerName,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _users = <int>[];
  final _infostring = <String>[];
  String? _channel;
  bool muted = false;
  bool videoOff = false;
  final CustomTimerController _controller = CustomTimerController();
  bool viewPanel = false;

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
          _channel = channel;
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
          _users.remove(uid);
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
                    child: const rtc_local_value.SurfaceView())
                : Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff26263F),
                    ),
                    child: rtc_remote_value.SurfaceView(
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
                                  child: const rtc_local_value.SurfaceView()),
                            ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _users.isNotEmpty
                          ? Column(
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
                                TimerBox(
                                  borderCirular: 16.5,
                                  width: 88,
                                  height: 32,
                                  circleSize: 7,
                                  controller: _controller,
                                  color: const Color.fromRGBO(41, 45, 50, 0.38),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          : const SizedBox(
                              width: 88,
                              height: 32,
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomFAB(
                              iconAddress: 'assets/images/add.svg',
                              func: () {}),
                          CustomFAB(
                              iconAddress: 'assets/images/messages.svg',
                              func: () {}),
                          CustomFAB(
                              iconAddress: 'assets/images/microphone-off.svg',
                              func: () {
                                setState(() {
                                  muted = !muted;
                                });
                                widget.agoraEngine.muteLocalAudioStream(muted);
                              }),
                          CustomFAB(
                              iconAddress: 'assets/images/video-off.svg',
                              func: () {
                                setState(() {
                                  videoOff = !videoOff;
                                });
                                widget.agoraEngine
                                    .muteLocalVideoStream(videoOff);
                              }),
                        ],
                      )
                    ],
                  ),
                  CallerButton(
                    color: const Color(0xffFF4647),
                    func: () {
                      Navigator.of(context).pop();
                    },
                    svgIconAddress: 'assets/images/Call.svg',
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
