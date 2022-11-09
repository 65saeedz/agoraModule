import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
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
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _users.isEmpty
                ? Container(
                    decoration: BoxDecoration(color: Colors.amber),
                    child: rtc_local_value.SurfaceView())
                : Container(
                    decoration: BoxDecoration(color: Colors.amber),
                    child: rtc_remote_value.SurfaceView(
                      uid: _users.first,
                      channelId: _channel!,
                    ),
                  ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 52, horizontal: 16),
              width: width, height: height,
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1)),
              // alignment: Alignment.center,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/Messanger_back.png',
                        width: 35,
                      ),
                      _users.isEmpty
                          ? Container(
                              width: 84,
                              height: 114,
                            )
                          : Container(
                              width: 84,
                              height: 114,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: rtc_local_value.SurfaceView()),
                    ],
                  ),
                  Spacer(),
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
                              text: TextSpan(
                                text: ' Video Call with \n',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: 'Jennifer Aniston ',
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
                                Text(
                                  '02:30',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Spacer(),
                          myFABs(
                              icon: Icons.info_outline,
                              func: () {
                                //          setState(() {
                                //   viewPanel = !viewPanel;
                                // });
                              }),
                          myFABs(icon: Icons.add, func: () {}),
                          myFABs(icon: Icons.message, func: () {}),
                          myFABs(icon: Icons.mic, func: () {}),
                          myFABs(
                              icon: Icons.videocam_off_outlined, func: () {}),
                        ],
                      )
                    ],
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Color(0xffFF4647),
                    extendedPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 52),
                    onPressed: () {},
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

  Opacity myFABs({required IconData icon, required Function func}) {
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
          onPressed: () {
            func;
          },
        ),
      ),
    );
  }
}
