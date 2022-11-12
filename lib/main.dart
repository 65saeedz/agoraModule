import 'package:agora15min/pages/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/video_call_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agora',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TestPage(),
    );
  }
}
