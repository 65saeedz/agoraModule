import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/widgets.dart';

class OwlgramCallPage extends StatefulWidget {
  final RtcEngine agoraEngine;
  const OwlgramCallPage({
    required this.agoraEngine,
    super.key,
  });

  @override
  State<OwlgramCallPage> createState() => _OwlgramCallPageState();
}

class _OwlgramCallPageState extends State<OwlgramCallPage> {
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

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xff26263F),
        body: Stack(
          children: [
            _users.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      color: Color(0xff26263F),
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xff26263F), Colors.transparent]),
                    ),
                    child: rtc_local_value.SurfaceView())
                : Container(
                    decoration: BoxDecoration(
                      color: Color(0xff26263F),
                    ),
                    child: rtc_remote_value.SurfaceView(
                      uid: _users.first,
                      channelId: _channel!,
                    ),
                  ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 64, 16, 48),
              width: width, height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Color(0xff26263F), Colors.transparent]),
              ),
              // alignment: Alignment.center,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
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
                        child: SvgPicture.asset(
                          'assets/images/Messanger_back.svg',
                          width: 36,
                          // color: Color(0xffD9DCE3),
                        ),
                      ),
                      _users.isEmpty
                          ? Container(
                              width: 84,
                              height: 114,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                  width: 84,
                                  height: 114,
                                  decoration: BoxDecoration(
                                    color: Color(0xff26263F),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: rtc_local_value.SurfaceView()),
                            ),
                    ],
                  ),
                  Spacer(),
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
                                    text: TextSpan(
                                      text: ' Video Call with \n',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'User ID:' +
                                              _users.first.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 19),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TimerBox(
                                  borderCirular: 16.5,
                                  width: 88,
                                  height: 32,
                                  circleSize: 7,
                                  controller: _controller,
                                  color: Color.fromRGBO(41, 45, 50, 0.38),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          : Container(
                              width: 88,
                              height: 32,
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Spacer(),
                          // myFABs(
                          //     icon: Icons.info_outline,
                          //     func: () {
                          //       //          setState(() {
                          //       //   viewPanel = !viewPanel;
                          //       // });
                          //     }),
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
                                  print('object');
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
                          CallerButton(
                            color: Color(0xffFF4647),
                            func: () {
                              Navigator.of(context).pop();
                            },
                            svgIconAddress: 'assets/images/Call.svg',
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
