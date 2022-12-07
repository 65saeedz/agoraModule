import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(VibratingApp());

class VibratingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text('Vibrate for default 500ms'),
                onPressed: () {
                  Vibration.vibrate();
                },
              ),
              ElevatedButton(
                child: Text('Vibrate for 1000ms'),
                onPressed: () {
                  Vibration.vibrate(duration: 1000);
                },
              ),
              ElevatedButton(
                child: Text('Vibrate with pattern'),
                onPressed: () {
                  Vibration.vibrate(
                    pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                  );
                },
              ),
              ElevatedButton(
                child: Text('Vibrate with pattern and amplitude'),
                onPressed: () {
                  Vibration.vibrate(
                    pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                    intensities: [0, 128, 0, 255, 0, 64, 0, 255],
                  );
                },
              ),
              ElevatedButton(
                child: Text('stop Vibration '),
                onPressed: () {
                  Vibration.cancel();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
