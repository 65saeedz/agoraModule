import 'package:get/get.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart' as ja;

class AudioController extends GetxController {
  final player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );
  playCallingTone() {
    playTone("assets/audios/calling.mp3");
  }

  playRingTone() {
    playTone("assets/audios/ringing.mp3");
  }

  playTone(String assetAddress) {
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(
        const AudioSessionConfiguration(),
      );

      await player.setAsset(assetAddress);
      player.play();
    });
  }
}
