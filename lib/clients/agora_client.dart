import 'package:agora15min/clients/http_client.dart';
import 'package:agora15min/models/agora_token_query.dart';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/video_call_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/audio/audio_controller.dart';

class AgoraClient {
  final _appId = 'a5b85475a1e34748a324db9d58622d98';
  late RtcEngine engine;
  final httpClient = HttpClient();
  AudioController audioController = Get.find();

  Future<void> makeCall(
    BuildContext context, {
    required CallType callType,
    required String userId,
    required String userToken,
    required String peerId,
    required String peerName,
    required String peerImageUrl,
  }) async {
    await _initialize(callType: callType);

    final agoraTokenResponse = await httpClient.fetchAgoraToken(
      AgoraTokenQuery(
        token: userToken,
        user_role_id: peerId,
      ),
    );

    await _handlePermissions(callType: callType);

    await engine.joinChannel(
      agoraTokenResponse.token,
      agoraTokenResponse.chanelName,
      null,
      int.parse(userId),
    );
        audioController.playCallingTone();
    switch (callType) {
      case CallType.voiceCall:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallPage(
              agoraEngine: engine,
              peerName: peerName,
              peerImageUrl: peerImageUrl,
            ),
          ),
        );
        break;

      case CallType.videoCall:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              agoraEngine: engine,
              peerName: peerName,
            ),
          ),
        );
        break;
    }
  }

  Future<void> receiveCall({
    required CallType callType,
    required String userId,
    required String userToken,
    required String peerId,
    required String channelName,
  }) async {
    await _initialize(callType: callType);

    final agoraTokenResponse = await httpClient.fetchAgoraToken(
      AgoraTokenQuery(
        token: userToken,
        user_role_id: peerId,
        chanelName: channelName,
      ),
    );

    await _handlePermissions(callType: callType);

    await engine.joinChannel(
      agoraTokenResponse.token,
      channelName,
      null,
      int.parse(userId),
    );
  }

  Future<void> _initialize({
    required CallType callType,
  }) async {
    engine = await RtcEngine.create(_appId);
    if (callType == CallType.videoCall) {
      await engine.enableVideo();
    }
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
    if (callType == CallType.videoCall) {
      VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
      configuration.dimensions = const VideoDimensions();
      await engine.setVideoEncoderConfiguration(configuration);
    }
  }

  Future<void> _handlePermissions({
    required CallType callType,
  }) async {
    if (callType == CallType.videoCall) {
      await Permission.camera.request();
    }
    await Permission.microphone.request();
  }
}
