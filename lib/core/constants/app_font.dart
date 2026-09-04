import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AppFontSize {
  AppFontSize._();

  // static double get _scaleFactor => 0.65;
  static double get _scaleFactor => 0.95;

  /// Font sizes
  static double get fontSize_6 => 6;
  static double get fontSize_7 => 7;
  static double get fontSize_8 => 8;

  static double get fontSize_9 => 9;

  static double get fontSize_10 => 10;
  static double get fontSize_10_2 => 10.2;
  static double get fontSize_11 => 11;
  static double get fontSize_12 => 12;
  static double get fontSize_13 => 13;
  static double get fontSize_14 => 14;
  static double get fontSize_15 => 15;
  static double get fontSize_16 => 16;
  static double get fontSize_18 => 18;
  static double get fontSize_20 => 20;
  static double get fontSize_22 => 22;
  static double get fontSize_24 => 24;
  static double get fontSize_30 => 30;
  static double get fontSize_40 => 40;
}


class AppHeightAndWidthSize {
  AppHeightAndWidthSize._();

  // static double get _scaleFactor => 0.65;
  static double get _scaleFactor => 0.95;

  /// Font sizes
  static double get heightSize_6 => 6.h;
  static double get heightSize_7 => 7.h;
  static double get heightSize_8 => 8.h;

  static double get heightSize_9 => 9.h;

  static double get heightSize_10 => 10.h;
  static double get heightSize_11 => 11.h;
  static double get heightSize_12 => 12.h;
  static double get heightSize_13 => 13.h;
  static double get heightSize_14 => 14.h;
  static double get heightSize_16 => 16.h;
  static double get heightSize_18 => 18.h;
  static double get heightSize_20 => 20.h;
  static double get heightSize_22 => 22.h;
  static double get heightSize_24 => 24.h;
  static double get heightSize_40 => 40.h;



  static double get widthSize_6 => 6.w;
  static double get widthSize_7 => 7.w;
  static double get widthSize_8 => 8.w;

  static double get widthSize_9 => 9.w;

  static double get widthSize_10 => 10.w;
  static double get widthSize_11 => 11.w;
  static double get widthSize_12 => 12.w;
  static double get widthSize_13 => 13.w;
  static double get widthSize_14 => 14.w;
  static double get widthSize_16 => 16.w;
  static double get widthSize_18 => 18.w;
  static double get widthSize_20 => 20.w;
  static double get widthSize_22 => 22.w;
  static double get widthSize_24 => 24.w;
  static double get widthSize_40 => 40.w;
}
/*

class AppFontSize {
  AppFontSize._();

  // static double get _scaleFactor => 0.65;
  static double get _scaleFactor => 0.95;

  /// Font sizes
  static double get fontSize_6 => 6 * _scaleFactor;
  static double get fontSize_7 => 7 * _scaleFactor;
  static double get fontSize_8 => 8 * _scaleFactor;

  static double get fontSize_9 => 9 * _scaleFactor;

  static double get fontSize_10 => 10 * _scaleFactor;

  static double get fontSize_11 => 11 * _scaleFactor;

  static double get fontSize_12 => 12 * _scaleFactor;

  static double get fontSize_13 => 13 * _scaleFactor;

  static double get fontSize_14 => 14 * _scaleFactor;

  static double get fontSize_16 => 16 * _scaleFactor;

  static double get fontSize_18 => 18 * _scaleFactor;

  static double get fontSize_20 => 20 * _scaleFactor;

  static double get fontSize_22 => 22 * _scaleFactor;

  static double get fontSize_24 => 24 * _scaleFactor;

  static double get fontSize_40 => 40 * _scaleFactor;
}

 */






class AppFontWeight {
  AppFontWeight._();

  static FontWeight light = FontWeight.w300;
  static FontWeight midLight = FontWeight.w400;
  static FontWeight semiBold = FontWeight.w600;
  static FontWeight midBold = FontWeight.w500;
  static FontWeight regular = FontWeight.normal;
  static FontWeight bold = FontWeight.bold;
}

class AppFontStyle {
  static TextStyle get normalTitle => TextStyle(
      color: Colors.black,
      fontWeight: AppFontWeight.bold,
      fontSize: AppFontSize.fontSize_16);

  static TextStyle get formFieldStyle => TextStyle(
      color:  Colors.black,
      fontWeight: AppFontWeight.regular,
      fontSize: AppFontSize.fontSize_13);

}
