import 'dart:async';
import 'package:agora15min/clients/agora_client.dart';
import 'package:agora15min/models/enums/call_type.dart';
import 'package:agora15min/pages/calling_page.dart';
import 'package:agora15min/pages/video_call_page.dart';
import 'package:agora15min/pages/voice_call_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum UserRole { callMaker, callReciver }

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final String user1Id = '111';
  final String user2Id = '114';
  final String user1Name = 'User Test 1';
  final String user2Name = 'User Test 2';
  final String user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMTEsInVzZXJfcm9sZV9pZCI6MTExLCJsYW5ndWFnZV9zaXRfaWQiOiIxIiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjY3ODcxMjYyLCJleHAiOjE2NzE0NzEyNjJ9.Ho0HmkTr8RnDD9-AdoyVDrg0T9gnh_Muhx1uPpSGaJ8';
  final String user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMTQsInVzZXJfcm9sZV9pZCI6MTE0LCJsYW5ndWFnZV9zaXRfaWQiOiI0IiwibGFuZ3VhZ2VfdXNlcl9pZCI6bnVsbCwiaWF0IjoxNjY3ODkzODIxLCJleHAiOjE2NzE0OTM4MjF9.r0cGeIF9C02KSfJboNClcHeQ9fqwbzb5BHQElbuLgGU';
  final String user1NetworkImageAddress =
      'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';
  final String user2NetworkImageAddress =
      'https://s.cafebazaar.ir/images/upload/screenshot/Amir.ID_Border1.jpg';
  UserRole? userRole = UserRole.callMaker;

  showSnackBar(
      {required void Function() onTap,
      // required AgoraClient agoraClient,
      required void Function() onAccepted,
      required void Function() onReject,
      required String peerImageUrl,
      required String peerName,
      required CallType callType}) {
    return showTopSnackBar(
      //dismissType: DismissType.values,
      padding: EdgeInsets.fromLTRB(16, 60, 16, 15),
      onTap: onTap,
      Overlay.of(context)!,
      displayDuration: Duration(seconds: 60),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        height: 90,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: peerImageUrl,
                ),
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                DefaultTextStyle(
                  child: Text(
                    peerName,
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(48, 54, 63, 1)),
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextStyle(
                  child: Text(
                    callType == CallType.videoCall
                        ? 'Video Calling ...'
                        : 'Voice Calling ...',
                  ),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(134, 133, 138, 1)),
                )
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/images/Call.svg',
                  width: 28,
                  height: 12,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(14),
                backgroundColor: Color(0xffFF4647), // <-- Button color
                //  foregroundColor: Colors.blue, //<-- Splash color
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: onAccepted,
              child: SvgPicture.asset(
                'assets/images/accept_call.svg',
                width: 28,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                // backgroundColor: Colors.blue, // <-- Button color
                foregroundColor: const Color(0xff11BE7F), // <-- Splash color
              ),
            ),
          ],
        ),
      ),
    );
  }
  // final TextEditingController _channelController = TextEditingController();
  // final TextEditingController _uidTokenController = TextEditingController();
  // final TextEditingController _peerUidController = TextEditingController();
  // final TextEditingController _userUidController = TextEditingController();
  // final TextEditingController _userNameController = TextEditingController();
  // final TextEditingController _userImageAddressController =
  //     TextEditingController();
  // final bool _validatorError = false;
  // String userDefaultNetworkImageAddress =
  //     'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';

  // @override
  // void dispose() {
  //   _channelController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.withOpacity(0.95),
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                // TextField(
                //   controller: _userUidController,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //       errorText: _validatorError ? 'user Uid is mandatory' : null,
                //       border: const UnderlineInputBorder(
                //         borderSide: BorderSide(width: 1),
                //       ),
                //       hintText: 'Enter user Id '),
                // ),
                // TextField(
                //   controller: _uidTokenController,
                //   decoration: InputDecoration(
                //       errorText: _validatorError
                //           ? 'Enter User App Token is mandatory'
                //           : null,
                //       border: const UnderlineInputBorder(
                //         borderSide: BorderSide(width: 1),
                //       ),
                //       hintText: 'Enter User App  Token'),
                // ),
                // TextField(
                //   controller: _peerUidController,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //       errorText: _validatorError ? 'peer Id is mandatory' : null,
                //       border: const UnderlineInputBorder(
                //         borderSide: BorderSide(width: 1),
                //       ),
                //       hintText: 'Enter peer Id '),
                // ),
                // if (userRole == UserRole.callReciver)
                //   TextField(
                //     controller: _channelController,
                //     decoration: InputDecoration(
                //         errorText:
                //             _validatorError ? 'Channel name is mandatory' : null,
                //         border: const UnderlineInputBorder(
                //           borderSide: BorderSide(width: 1),
                //         ),
                //         hintText: 'Enter Channel name '),
                //   ),
                // TextField(
                //   controller: _userNameController,
                //   decoration: const InputDecoration(
                //       border: UnderlineInputBorder(
                //         borderSide: BorderSide(width: 1),
                //       ),
                //       hintText: 'Enter User name'),
                // ),
                // TextField(
                //   controller: _userImageAddressController,
                //   decoration: const InputDecoration(
                //       border: UnderlineInputBorder(
                //         borderSide: BorderSide(width: 1),
                //       ),
                //       hintText: 'Enter User network image address  (optional)'),
                // ),
                RadioListTile(
                    title: const Text('Call maker '),
                    value: UserRole.callMaker,
                    groupValue: userRole,
                    onChanged: (UserRole? value) {
                      setState(() {
                        userRole = value;
                      });
                    }),
                RadioListTile(
                    title: const Text('Call receiver '),
                    value: UserRole.callReciver,
                    groupValue: userRole,
                    onChanged: (UserRole? value) {
                      setState(() {
                        userRole = value;
                      });
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.video_camera_back_outlined,
                        ),
                        onPressed: onVideoCall,
                        label: const Text('Video Call')),
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.call,
                        ),
                        onPressed: onVoiceCall,
                        label: const Text('Voice Call')),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {}, child: const Text('show snack bar')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onVoiceCall() async {
    final agoraClient = AgoraClient();

    switch (userRole) {
      case UserRole.callMaker:
        await agoraClient.makeCall(
          callType: CallType.voiceCall,
          userId: user1Id,
          userToken: user1Token,
          peerId: user2Id,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VoiceCallPage(
                networkImageAddress: user2NetworkImageAddress,
                peerName: user2Name,
                agoraEngine: agoraClient.engine,
              ),
            ),
          );
        }
        break;

      case UserRole.callReciver:
        showSnackBar(
            //   agoraClient: agoraClient,
            peerImageUrl: user1NetworkImageAddress,
            peerName: user1Name,
            callType: CallType.voiceCall,
            onTap: () {
              //  Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallingPage(
                    peerImageUrl: user1NetworkImageAddress,
                    peerName: user1Name,
                    callType: CallType.voiceCall,
                    onAccepted: () async {
                      await agoraClient.receiveCall(
                        callType: CallType.voiceCall,
                        userId: user2Id,
                        userToken: user2Token,
                        peerId: user1Id,
                        channelName: 'chat_$user1Id',
                      );
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VoiceCallPage(
                              networkImageAddress: user1NetworkImageAddress,
                              peerName: user1Name,
                              agoraEngine: agoraClient.engine,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
            onAccepted: () async {
              await agoraClient.receiveCall(
                callType: CallType.voiceCall,
                userId: user2Id,
                userToken: user2Token,
                peerId: user1Id,
                channelName: 'chat_$user1Id',
              );
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoiceCallPage(
                      networkImageAddress: user1NetworkImageAddress,
                      peerName: user1Name,
                      agoraEngine: agoraClient.engine,
                    ),
                  ),
                );
              }
            },
            onReject: () {});

        break;

      default:
        break;
    }
  }

  Future<void> onVideoCall() async {
    final agoraClient = AgoraClient();

    switch (userRole) {
      case UserRole.callMaker:
        await agoraClient.makeCall(
          callType: CallType.videoCall,
          userId: user1Id,
          userToken: user1Token,
          peerId: user2Id,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCallPage(
                networkImageAddress: user2NetworkImageAddress,
                peerName: user2Name,
                agoraEngine: agoraClient.engine,
              ),
            ),
          );
        }
        break;

      case UserRole.callReciver:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingPage(
              peerImageUrl: user1NetworkImageAddress,
              peerName: user1Name,
              callType: CallType.videoCall,
              onAccepted: () async {
                await agoraClient.receiveCall(
                  callType: CallType.videoCall,
                  userId: user2Id,
                  userToken: user2Token,
                  peerId: user1Id,
                  channelName: 'chat_$user1Id',
                );
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallPage(
                        networkImageAddress: user1NetworkImageAddress,
                        peerName: user1Name,
                        agoraEngine: agoraClient.engine,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
        break;

      default:
        break;
    }
  }
}
