import 'package:get/get.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final _player = AudioPlayer(
      // handleInterruptions: false,
      // androidApplyAudioAttributes: false,
      // handleAudioSessionActivation: false,
      );
  @override
  void onClose() {
    _player.dispose();

    super.onClose();
  }

  playCallingToneVideo() {
    _player.setAndroidAudioAttributes(
      AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
    );
    _playTone("assets/audios/calling.mp3");
  }

  playCallingToneAudio() {
    _player.setAndroidAudioAttributes(
      AndroidAudioAttributes(
        contentType: AndroidAudioContentType.unknown,
        usage: AndroidAudioUsage.unknown,
      ),
    );
    _playTone("assets/audios/calling.mp3");
  }

  playRingTone() {
    _playTone("assets/audios/ringing.mp3");
  }

  stopTone() {
    _player.stop();
  }

  _playTone(String assetAddress) {
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(
        const AudioSessionConfiguration(),
      );

      await _player.setAsset(assetAddress);
      _player.setLoopMode(LoopMode.all);

      _player.play();
    });
  }
}
