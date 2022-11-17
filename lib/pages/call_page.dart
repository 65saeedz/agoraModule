// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_value;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_value;
// import 'package:flutter/material.dart';

// class CallPage extends StatefulWidget {
//   final RtcEngine agoraEngine;

//   const CallPage({
//     Key? key,
//     required this.agoraEngine,
//   }) : super(key: key);

//   @override
//   State<CallPage> createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   final _users = <int>[];
//   final _infostring = <String>[];
//   String? _channel;
//   bool muted = false;
//   bool viewPanel = false;

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   @override
//   void dispose() {
//     _users.clear();
//     widget.agoraEngine.leaveChannel();
//     widget.agoraEngine.destroy();
//     super.dispose();
//   }

//   Future<void> _initialize() async {
//     widget.agoraEngine.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         setState(() {
//           final info = 'error :$code';
//           _infostring.add(info);
//         });
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         setState(() {
//           final info = 'joined channel:$channel ,uid :$uid';
//           _channel = channel;
//           _infostring.add(info);
//         });
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           _infostring.add('leave channel');
//           _users.clear();
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           final info = 'user joined:$uid';
//           _infostring.add(info);
//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, elapsed) {
//         setState(() {
//           final info = 'user offline:$uid';
//           _infostring.add(info);
//           _users.remove(uid);
//         });
//       },
//       firstRemoteVideoFrame: (uid, width, height, elapsed) {
//         setState(() {
//           final info = 'first remote video :$uid $width *$height';
//           _infostring.add(info);
//         });
//       },
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   viewPanel = !viewPanel;
//                 });
//               },
//               icon: const Icon(Icons.info_outline))
//         ],
//         title: const Text('Agora'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Stack(
//           children: [
//             _viewRows(),
//             _panel(),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _viewRows() {
//     final List<StatefulWidget> list = [];
//     list.add(const rtc_local_value.SurfaceView());
//     if (_channel != null)
//       for (var uid in _users) {
//         list.add(rtc_remote_value.SurfaceView(
//           uid: uid,
//           channelId: _channel!,
//         ));
//       }
//     final views = list;
//     return Column(
//       children:
//           List.generate(views.length, (index) => Expanded(child: views[index])),
//     );
//   }

//   Widget _toolbar() {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           RawMaterialButton(
//             onPressed: (() {
//               setState(() {
//                 muted = !muted;
//               });
//               widget.agoraEngine.muteLocalAudioStream(muted);
//             }),
//             shape: const CircleBorder(),
//             elevation: 2,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12),
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blue,
//               size: 20.0,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             shape: const CircleBorder(),
//             elevation: 2,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15),
//             child: const Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: () {
//               widget.agoraEngine.switchCamera();
//             },
//             shape: const CircleBorder(),
//             elevation: 2,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12),
//             child: const Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _panel() {
//     return Visibility(
//         visible: viewPanel,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           alignment: Alignment.bottomCenter,
//           child: FractionallySizedBox(
//               heightFactor: 0.5,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 48),
//                 child: ListView.builder(
//                   reverse: true,
//                   itemCount: _infostring.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (_infostring.isEmpty) {
//                       return const Text('null');
//                     }
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 3, horizontal: 10),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Flexible(
//                               child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2, horizontal: 5),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Text(
//                               _infostring[index],
//                               style: const TextStyle(color: Colors.blueGrey),
//                             ),
//                           ))
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               )),
//         ));
//   }
// }
  // final TextEditingController user1Id = TextEditingController();
  // final TextEditingController user1Token = TextEditingController();
  // final TextEditingController user1Name = TextEditingController();
  // final TextEditingController user2Id = TextEditingController();
  // final TextEditingController user2Name = TextEditingController();
  // final TextEditingController _userImageAddressController =
  //     TextEditingController();
  // final TextEditingController channelName = TextEditingController();
  // final bool _validatorError = false;
  // UserRole? userRole = UserRole.callMaker;
  // String userDefaultNetworkImageAddress =
  //     'https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/fc/3024831-inline-s-4-the-personal-philosophies-that-shape-todays-successful-innovators.jpg';
