//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:radio_player/radio_player.dart';
// import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
// import 'package:syrians_in_uae/widgets/components.dart';
//
// import '../../../core/utils/image_constant.dart';
// import '../../../widgets/custom_image_view.dart';
//
//
// class RadioPage extends StatefulWidget {
//   @override
//   _RadioPageState createState() => _RadioPageState();
// }
//
// class _RadioPageState extends State<RadioPage> {
//   RadioPlayer _radioPlayer = RadioPlayer();
//   bool isPlaying = false;
//   List<String>? metadata;
//
//   @override
//   void initState() {
//     super.initState();
//     initRadioPlayer();
//   }
//
//   void initRadioPlayer() {
//     _radioPlayer.setChannel(
//       title: 'Radio Player',
//       url: 'https://a8.asurahosting.com:8010/api/station/420/nowplaying',
//       imagePath: 'assets/images/image_1.jpg',
//     );
//
//     _radioPlayer.stateStream.listen((value) {
//       setState(() {
//         isPlaying = value;
//       });
//     });
//
//     _radioPlayer.metadataStream.listen((value) {
//       setState(() {
//         metadata = value;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _radioPlayer.stop();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarNormalWithIcon(text: 'راديو سيريا',isShowBack: true,context: context),
//       body: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           sizeHeightNormal(
//             height: 40.h
//           ),
//           CustomImageView(
//             imagePath: ImageConstant.radioIcon,
//             height: 190.h,
//             width: 190.h,
//             fit: BoxFit.contain,
//             alignment: Alignment.center,
//           ),
//
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
//         },
//         tooltip: 'Control button',
//           child: Icon(
//             isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//           ),
//       ),
//     );
//   }
// }
//
//
// ///Image
// // FutureBuilder(
// //   future: _radioPlayer.getArtworkImage(),
// //   builder: (BuildContext context, AsyncSnapshot snapshot) {
// //     Image artwork;
// //     if (snapshot.hasData) {
// //       artwork = snapshot.data;
// //     } else {
// //       artwork = Image.asset(
// //         'assets/images/image_1.jpg',
// //         fit: BoxFit.cover,
// //       );
// //     }
// //     return Container(
// //       height: 180,
// //       width: 180,
// //       child: ClipRRect(
// //         child: artwork,
// //         borderRadius: BorderRadius.circular(10.0),
// //       ),
// //     );
// //   },
// // ),
// // SizedBox(height: 20),
// // Text(
// //   metadata?[0] ?? 'Metadata',
// //   softWrap: false,
// //   overflow: TextOverflow.fade,
// //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
// // ),
// // Text(
// //   metadata?[1] ?? '',
// //   softWrap: false,
// //   overflow: TextOverflow.fade,
// //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // ),
// // SizedBox(height: 20),