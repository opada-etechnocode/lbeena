import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


 Widget loaderNormal ({Color? color,double size =35, }){

  return LoadingAnimationWidget.staggeredDotsWave(
    // leftDotColor: const Color(0xFF1A1A3F),
    // rightDotColor: const Color(0xFFEA3799),
    color: color?? appTheme.greenColor,
    size: size,
  );
}
