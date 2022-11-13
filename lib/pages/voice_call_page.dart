import 'package:agora15min/widgets/widgets.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
import 'package:flutter/services.dart';

class VoiceCallPage extends StatefulWidget {
  // final RtcEngine agoraEngine;
  const VoiceCallPage({
    super.key,
    // required this.agoraEngine,
  });

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
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
    // widget.agoraEngine.leaveChannel();
    // widget.agoraEngine.destroy();

    super.dispose();
  }

  Future<void> _initialize() async {
    // widget.agoraEngine.setEventHandler(RtcEngineEventHandler(
    //   error: (code) {
    //     setState(() {
    //       final info = 'error :$code';
    //       _infostring.add(info);
    //     });
    //   },
    //   joinChannelSuccess: (channel, uid, elapsed) {
    //     setState(() {
    //       final info = 'joined channel:$channel ,uid :$uid';
    //       _channel = channel;
    //       _infostring.add(info);
    //     });
    //   },
    //   leaveChannel: (stats) {
    //     setState(() {
    //       _infostring.add('leave channel');
    //       _users.clear();
    //     });
    //   },
    //   userJoined: (uid, elapsed) {
    //     setState(() {
    //       final info = 'user joined:$uid';
    //       _infostring.add(info);
    //       _users.add(uid);
    //       _controller.start();
    //     });
    //   },
    //   userOffline: (uid, elapsed) {
    //     setState(() {
    //       final info = 'user offline:$uid';
    //       _infostring.add(info);
    //       _users.remove(uid);
    //     });
    //   },
    //   firstRemoteVideoFrame: (uid, width, height, elapsed) {
    //     setState(() {
    //       final info = 'first remote video :$uid $width *$height';
    //       _infostring.add(info);
    //     });
    //   },
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Color(0xff26263F),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 64, 16, 48),
        color: Color(0xff26263F),
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
                  child: SvgPicture.asset(
                    'assets/images/Messanger_back.svg',
                    width: 36,
                    // color: Color(0xffD9DCE3),
                  ),
                ),
                Container(
                  width: 84,
                  //  height: 114,
                )
              ],
            ),
            StackProfilePic(
                color: Color(0xff26263F),
                peerImageUrl:
                    'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg'),
            SizedBox(
              height: 46,
            ),
            Text(
              'Mostafa Sammak',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TimerBox(
              controller: _controller,
              color: Color(0xff353551),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomFAB(
                    iconAddress: 'assets/images/microphone-off.svg',
                    func: () {
                      setState(() {
                        print('object');
                        muted = !muted;
                      });
                      // widget.agoraEngine.muteLocalAudioStream(muted);
                    }),
                CallerButton(
                  color: Color(0xffFF4647),
                  func: () {
                    Navigator.of(context).pop();
                  },
                  svgIconAddress: 'assets/images/Call.svg',
                ),
                CustomFAB(
                    iconAddress: 'assets/images/video-off.svg',
                    func: () {
                      setState(() {
                        videoOff = !videoOff;
                      });
                      //  widget.agoraEngine .muteLocalVideoStream(videoOff);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
