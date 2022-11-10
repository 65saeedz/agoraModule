import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';

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
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
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
              padding: EdgeInsets.symmetric(vertical: 52, horizontal: 16),
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
                        child: Image.asset(
                          'assets/images/Messanger_back.png',
                          width: 35,
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
                                Container(
                                  width: 88,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(41, 45, 50, 0.38),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 7,
                                        width: 7,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      CustomTimer(
                                          controller: _controller,
                                          begin: Duration(seconds: 0),
                                          end: Duration(hours: 11),
                                          builder: (remaining) {
                                            print(remaining.hours);
                                            return remaining.hours != '00'
                                                ? Text(
                                                    "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "${remaining.minutes}:${remaining.seconds}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  );
                                          }),
                                    ],
                                  ),
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
                          myFABs(icon: Icons.add, func: () {}),
                          //myFABs(icon: Icons.message, func: () {}),
                          myFABs(
                              icon: muted ? Icons.mic_off_outlined : Icons.mic,
                              func: () {
                                setState(() {
                                  print('object');
                                  muted = !muted;
                                });
                                widget.agoraEngine.muteLocalAudioStream(muted);
                              }),
                          myFABs(
                              icon: videoOff
                                  ? Icons.videocam_off_outlined
                                  : Icons.video_camera_front_outlined,
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
                  FloatingActionButton.extended(
                    backgroundColor: Color(0xffFF4647),
                    extendedPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 52),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Opacity myFABs({required IconData icon, required func}) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        // decoration: BoxDecoration(color: Colors.white),
        width: 50,
        height: 50,
        child: RawMaterialButton(
          fillColor: Colors.white,
          shape: CircleBorder(),
          //  elevation: 0.0,
          child: Icon(
            icon,
            color: Colors.black,
            size: 32,
          ),
          onPressed: func,
        ),
      ),
    );
  }
}
