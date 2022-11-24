import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _player = ja.AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  @override
  void initState() {
    super.initState();
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(
        const AudioSessionConfiguration(),
      );
      await _player.setAsset("assets/audios/WhatsApp Audio 2022-11-19 at 16.54.55.mp3");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
     
        body: Center(
          child: StreamBuilder<ja.PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              if (playerState?.processingState !=
                  ja.ProcessingState.ready) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: const CircularProgressIndicator(),
                );
              } else if (playerState?.playing == true) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: _player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: _player.play,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
