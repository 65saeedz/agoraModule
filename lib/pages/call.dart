import 'dart:ffi';

import 'package:agora_rtc_engine/agora_rtc_engine_web.dart';
import 'package:agora_rtc_engine/media_recorder.dart';
import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRole? role;
  const CallPage({
    Key? key,
    this.channelName,
    this.role,
  }) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infostring = <String>[];
  bool _mute = false;
  bool _viewPanel = false;
  late RtcEngine _engine;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);
    _addAgoraEventHandler();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token, widget.channelName!, null, 0);
  }

  void _addAgoraEventHandler() {
    _engine.setEventHandler(RtcEngineEventHandler(
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
          final info = 'error joined:$uid';
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
          final info = 'first remote video :$uid ${width}*${height}';
          _infostring.add(info);
        });
      },
    ));
  }
Widget _viewRows(){}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora'),
        centerTitle: true,
      ),
    );
  }
}
