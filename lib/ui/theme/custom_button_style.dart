import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Outline button style
  static ButtonStyle get outlineCyan => ElevatedButton.styleFrom(
        backgroundColor: LbeenaColors.teal,
        foregroundColor: LbeenaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.r),
        ),
        elevation: 0,
      );
  static ButtonStyle get baseBorderButton => ElevatedButton.styleFrom(
        backgroundColor: LbeenaColors.teal,
        foregroundColor: LbeenaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.r),
        ),
        elevation: 0,
      );
  static ButtonStyle get buttonGeneral => ElevatedButton.styleFrom(
        backgroundColor: LbeenaColors.teal,
        foregroundColor: LbeenaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.r),
        ),
        elevation: 0,
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
