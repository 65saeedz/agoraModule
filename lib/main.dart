import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/calling_page.dart';
import 'package:agora15min/pages/test_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
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
        home: TestPage()

        // CallingPage(
        //   peerImageUrl:
        //       'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg',
        //   peerName: 'KATIA BEAUCHAMP',
        //   callType: CallType.videoCall,
        //   onAccepted: () {},
        // ),
        );
  }
}
