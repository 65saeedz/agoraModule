import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/accept_call_query.dart';
import '../clients/http_client.dart';
import '../models/agora_token_query.dart';
import '../models/enums/call_type.dart';
import '../controllers/audio/audio_controller.dart';

class AgoraClient {
  final _appId = 'a5b85475a1e34748a324db9d58622d98';
  final _httpClient = HttpClient();
  final AudioController _audioController = Get.put(AudioController());

  late RtcEngine _engine;

  Future<RtcEngine> makeCall({
    required CallType callType,
    required String userId,
    required String userToken,
    required String peerId,
  }) async {
    await _handlePermissions(callType: callType);
    await _initialize(callType: callType);

    callType == CallType.voiceCall
        ? _audioController.playCallingToneAudio()
        : _audioController.playCallingToneVideo();
    final agoraTokenResponse = await _httpClient.fetchAgoraToken(
      AgoraTokenQuery(
        token: userToken,
        caller_id: int.parse(userId),
        pree_id: int.parse(peerId),
        has_video: callType == CallType.videoCall ? 1 : 0,
      ),
    );
    await _engine.joinChannel(
      agoraTokenResponse.token,
      agoraTokenResponse.chanelName,
      null,
      int.parse(userId),
    );

    return _engine;
  }

  Future<RtcEngine> receiveCall({
    required CallType callType,
    required String userId,
    required String userToken,
    required String peerId,
    required String channelName,
    required String callId,
  }) async {
    await _handlePermissions(callType: callType);
    await _initialize(callType: callType);

    final agoraTokenResponse = await _httpClient.fetchAgoraToken(
      AgoraTokenQuery(
        token: userToken,
        chanelName: channelName,
        pree_id: int.parse(peerId),
      ),
    );
    await _engine.joinChannel(
      agoraTokenResponse.token,
      channelName,
      null,
      int.parse(userId),
    );
    _httpClient.setCallingStatus(
      AcceptCallQuery(token: userToken, callId: callId),
    );
    return _engine;
  }

  void cancelFromCaller() {
    _httpClient.cancelCallFromCaller();
  }

  void cancelFromReceiver(
      {required String receiverCallId, required String token}) {
    _httpClient.cancelCallFromReceiver(
        receiverCallId: receiverCallId, token: token);
  }

  Future<void> _handlePermissions({
    required CallType callType,
  }) async {
    if (callType == CallType.videoCall) {
      await Permission.camera.request();
    }
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();
  }

  Future<void> _initialize({
    required CallType callType,
  }) async {
    _engine = await RtcEngine.create(_appId);
    if (callType == CallType.videoCall) {
      await _engine.enableVideo();
    }
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    if (callType == CallType.videoCall) {
      VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
      configuration.dimensions = const VideoDimensions();
      await _engine.setVideoEncoderConfiguration(configuration);
    }
  }
}
