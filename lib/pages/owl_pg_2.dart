// import 'package:flutter/material.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//   });

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// @override
// class _MyHomePageState extends State<MyHomePage> {
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(color: Colors.amber),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(vertical: 52, horizontal: 16),
//           width: width, height: height,
//           decoration: BoxDecoration(color: Colors.green.withOpacity(0.1)),
//           // alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Column(
//                 children: [
//                   Row(
//                     //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Image.asset(
//                               'assets/images/Messanger_back.png',
//                               width: 35,
//                             ),
//                             Opacity(
//                               opacity: 0.7,
//                               child: RichText(
//                                 text: TextSpan(
//                                   text: ' Video Call with \n',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w400),
//                                   children: const <TextSpan>[
//                                     TextSpan(
//                                       text: 'Jennifer Aniston ',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 19),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: 88,
//                               height: 32,
//                               decoration: BoxDecoration(
//                                 color: Color.fromRGBO(41, 45, 50, 0.38),
//                                 borderRadius: BorderRadius.circular(17),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     height: 7,
//                                     width: 7,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.green),
//                                   ),
//                                   SizedBox(
//                                     width: 12,
//                                   ),
//                                   Text(
//                                     '02:30',
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.white),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               width: 84,
//                               height: 114,
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                             ),
//                             // Spacer(),
//                             myFABs(icon: Icons.add, func: () {}),
//                             myFABs(icon: Icons.message, func: () {}),
//                             myFABs(icon: Icons.mic, func: () {}),
//                             myFABs(
//                                 icon: Icons.videocam_off_outlined, func: () {})
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   FloatingActionButton.extended(
//                     backgroundColor: Color(0xffFF4647),
//                     extendedPadding:
//                         EdgeInsets.symmetric(vertical: 8, horizontal: 52),
//                     onPressed: () {},
//                     label: Icon(
//                       Icons.call_end,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//       ],
//     ));
//   }

//   Opacity myFABs({required IconData icon, required Function func}) {
//     return Opacity(
//       opacity: 0.7,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         // decoration: BoxDecoration(color: Colors.white),
//         width: 50,
//         height: 50,
//         child: RawMaterialButton(
//           fillColor: Colors.white,
//           shape: CircleBorder(),
//           //  elevation: 0.0,
//           child: Icon(
//             icon,
//             color: Colors.black,
//             size: 32,
//           ),
//           onPressed: () {
//             func;
//           },
//         ),
//       ),
//     );
//   }
// }
