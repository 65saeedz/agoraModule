import 'package:agora15min/pages/test_page.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: const TestPage(),
    );
  }
}
