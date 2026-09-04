// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AdaptiveStatusBar extends StatelessWidget {
//   final Widget child;
//   final Color backgroundColor;
//
//   const AdaptiveStatusBar({
//     super.key,
//     required this.child,
//     required this.backgroundColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final Brightness iconBrightness =
//     backgroundColor.computeLuminance() > 0.5
//         ? Brightness.dark // خلفية فاتحة → أيقونات داكنة
//         : Brightness.light; // خلفية داكنة → أيقونات بيضاء
//
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: backgroundColor,
//       statusBarIconBrightness: iconBrightness, // أندرويد
//       statusBarBrightness: iconBrightness == Brightness.dark
//           ? Brightness.light
//           : Brightness.dark, // iOS
//     ));
//
//     return child;
//   }
// }
