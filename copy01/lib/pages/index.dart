import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final TextEditingController _channelController = TextEditingController();
  bool _validatorError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                    errorText:
                        _validatorError ? 'Channel name is mandatory' : null,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Enter channel name '),
              ),
              RadioListTile(
                  title: const Text('Broadcaster '),
                  value: ClientRole.Broadcaster,
                  groupValue: _role,
                  onChanged: (ClientRole? value) {
                    setState(() {
                      _role = value;
                    });
                  }),
              RadioListTile(
                  title: const Text('Audience '),
                  value: ClientRole.Audience,
                  groupValue: _role,
                  onChanged: (ClientRole? value) {
                    setState(() {
                      _role = value;
                    });
                  }),
              ElevatedButton(onPressed: onJoin, child: const Text('Join'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validatorError = true
          : _validatorError = false;
    });
    if (_channelController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
      await _handelPermission(Permission.camera);
      await _handelPermission(Permission.microphone);
    }
  }

  Future<void> _handelPermission(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
