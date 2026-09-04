import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HandelAndroidApp extends StatelessWidget {
   HandelAndroidApp({super.key,
   required this.child});
   Widget child;
  @override
  Widget build(BuildContext context) {
    return child;

    //   Platform.isIOS?SizedBox(
    //   child: child,
    // ): SafeArea(child: child);
  }
}
