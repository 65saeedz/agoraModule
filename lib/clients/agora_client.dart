import 'package:agora15min/clients/http_client.dart';
import 'package:agora15min/models/agora_token_query.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraClient {
  final _appId = 'a5b85475a1e34748a324db9d58622d98';
  late RtcEngine engine;
  final httpClient = HttpClient();

  Future<void> _initialize() async {
    engine = await RtcEngine.create(_appId);
    await engine.enableVideo();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    await engine.setVideoEncoderConfiguration(configuration);
  }

  Future<void> makeCall({
    required String userId,
    required String userToken,
    required String peerId,
  }) async {
    await _initialize();
    final agoraTokenResponse = await httpClient.fetchAgoraToken(
      AgoraTokenQuery(
        token: userToken,
        user_role_id: peerId,
      ),
    );
    await Permission.camera.request();
    await Permission.microphone.request();
    // await [
    //   Permission.microphone,
    //   Permission.camera,
    // ].request();
    await engine.joinChannel(
      agoraTokenResponse.token,
      agoraTokenResponse.chanelName,
      null,
      int.parse(userId),
    );
  }

  Future<void> receiveCall({
    required String userId,
    required String userToken,
    required String peerId,
    required String channelName,
  }) async {
    await _initialize();
    final agoraTokenResponse = await httpClient.fetchAgoraToken(
      AgoraTokenQuery(
        token: userToken,
        user_role_id: peerId,
        chanelName: channelName,
      ),
    );
    await Permission.camera.request();
    await Permission.microphone.request();
    // await [
    //   Permission.microphone,
    //   Permission.camera,
    // ].request();
    await engine.joinChannel(
      agoraTokenResponse.token,
      channelName,
      null,
      int.parse(userId),
    );
  }
}
