import 'dart:ui';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_font.dart';
import '../../core/di/di_manager.dart';
import '../../core/shared_prefs/shared_prefs.dart';
import 'lbeena_colors.dart';

class AppColorSchemes {
  static final lightColorScheme = ColorScheme.fromSwatch().copyWith(
    primary: LbeenaColors.teal,
    primaryContainer: LbeenaColors.orange,
    secondaryContainer: LbeenaColors.teal,
    errorContainer: LbeenaColors.teal,
    onPrimary: LbeenaColors.white,
  );

  static final darkColorScheme = ColorScheme.fromSwatch().copyWith(
    primary: LbeenaColors.black,
    primaryContainer: LbeenaColors.orange,
    secondaryContainer: LbeenaColors.teal,
    errorContainer: LbeenaColors.orange,
    onPrimary: LbeenaColors.white,
  );
}

// Define the different primary colors for both light and dark themes
class PrimaryColors {
  Color get black900 => Color(0XFF000000);

  // Color get cyan600 => Color(0XFF00A1C4);

  // Color get cyan600 => Color(int.parse('0xff${DIManager.findDep<SharedPrefs>().getMainColorApp()}'));

  Color get cyan600 => LbeenaColors.teal;
  Color get containerCart => LbeenaColors.teal;
  Color get blue600 => LbeenaColors.teal;
  Color get cyan400 => LbeenaColors.teal;


  Color get baseColorShimmer => Colors.white;

  Color get highlightColorShimmer => Colors.grey;

  // Color get poing600 => Color(0xff20A868);
  Color get poing600 => LbeenaColors.orange;
  Color get buttonColor => LbeenaColors.orange;
  Color get buttonColorBorder => LbeenaColors.muted;
  Color get borderImageColor => LbeenaColors.orange;
  Color get defaultPrimaryColor => LbeenaColors.teal;
  Color get scaffoldBackgroundColor100 => LbeenaColors.lightBg;


  Color get blue100 => Color(0XFFC8EBFD);

  Color get blueGray80099 => Color(0X993C2C69);

  Color get blueGray800A3 => Color(0XA33B2C68);

  // Color get deepPurpleA100 => Color(0XFF9173F7);
  Color get deepPurpleA100 => LbeenaColors.orange;
  Color get deepPurpleAndYellow => LbeenaColors.orange;
  Color get deepPurpleA10001 => LbeenaColors.teal;
  Color get deepPurpleA10002 => LbeenaColors.orange;
  Color get textNew => LbeenaColors.teal;
  Color get lightBlue100 => LbeenaColors.fieldFill;
  Color get backgroundContainer => const Color(0xfff1f1f1);
  Color get backgroundUGC => Colors.grey.shade200;
  Color get colorAppBar => LbeenaColors.teal;
  Color get lightBlueBottomNavigatorBar => LbeenaColors.teal;
  Color get colorPoint => LbeenaColors.teal;
  // Color get lightBlueBottomNavigatorBar => Color(0XFFC8EBFD);
  Color get tooltip =>  Color(0XFF1F2328);

  // Color get lightBlue200 => Color(0XFF84D2FB);
  //#20A868 new ==> 377c2c old

  Color get greenColor => LbeenaColors.teal;
  Color get buttonNavigatorBarIcon => LbeenaColors.teal;
  Color get greenColorApp => LbeenaColors.teal;
  Color get activeButtonNavigatorBarIcon => LbeenaColors.orange;
  Color get lightBlue200 => LbeenaColors.teal;
  Color get lime200 => Color(0XFFEDE8A6);
  Color get whiteA100 => Color(0xffffffff);
  Color get red300 => Color(0XFFF56C74);
  Color get gray => Color(0x42000000);
  Color get grey => Colors.grey;

  Color get blueGray => Color(0X993C2C69);

  Color get whiteA700 => Color(0XFFFFFFFF);
  Color get white => Color(0XFFFFFFFF);
  Color get white2 => Color(0XFFFFFFFF);
  Color get deepPurpleOnly => LbeenaColors.teal;
}

class LightPrimaryColors extends PrimaryColors {
  @override
  Color get black900 => LbeenaColors.black;

  @override
  Color get cyan600 => LbeenaColors.teal;
}

class DarkPrimaryColors extends PrimaryColors {
  @override
  Color get black900 => LbeenaColors.white;
  @override
  Color get deepPurpleA10001 => LbeenaColors.orange;
  @override
  Color get deepPurpleA100 => LbeenaColors.orange;
  @override
  Color get deepPurpleAndYellow => LbeenaColors.orange;
  @override
  Color get colorPoint => LbeenaColors.orange;
  @override
  Color get grey => LbeenaColors.muted;
  @override
  Color get textNew => LbeenaColors.white;
  @override
  Color get cyan600 => LbeenaColors.white;
  @override
  Color get poing600 => LbeenaColors.orange;
  @override
  Color get lightBlue100 => LbeenaColors.surfaceDark;
  @override
  Color get white2 => Colors.white10;
  @override
  Color get backgroundContainer => LbeenaColors.cardDark;
  @override
  Color get backgroundUGC => LbeenaColors.cardDark;
  @override
  Color get containerCart => LbeenaColors.black;
  @override
  Color get buttonColor => LbeenaColors.orange;
  @override
  Color get buttonColorBorder => LbeenaColors.muted;
  @override
  Color get borderImageColor => LbeenaColors.orange.withOpacity(.4);
  @override
  Color get deepPurpleA10002 => LbeenaColors.orange;
  @override
  Color get lightBlueBottomNavigatorBar => LbeenaColors.surfaceDark;
  @override
  Color get tooltip => LbeenaColors.teal;
  @override
  Color get lightBlue200 => LbeenaColors.cardDark;
  @override
  Color get gray => const Color(0x42EAEAEA);
  @override
  Color get blueGray80099 => LbeenaColors.white;
  @override
  Color get activeButtonNavigatorBarIcon => LbeenaColors.orange;
  @override
  Color get whiteA700 => LbeenaColors.cardDark;
  @override
  Color get whiteA100 => const Color(0xffdfdfdf);
  @override
  Color get white => LbeenaColors.black;
  @override
  Color get colorAppBar => LbeenaColors.black;
  @override
  Color get blue600 => LbeenaColors.white;
  @override
  Color get scaffoldBackgroundColor100 => LbeenaColors.black;
}

// ThemeHelper class to manage theme switching
class ThemeHelper {
  static bool _isDarkMode = false;

  static void toggleDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
  }

  static ThemeData _getThemeData() {
    ColorScheme colorScheme = _isDarkMode
        ? AppColorSchemes.darkColorScheme
        : AppColorSchemes.lightColorScheme;

    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor100,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LbeenaColors.orange,
          foregroundColor: LbeenaColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadowColor: LbeenaColors.orange.withOpacity(0.35),
          elevation: 2,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  static PrimaryColors themeColor() =>
      _isDarkMode ? DarkPrimaryColors() : LightPrimaryColors();

  static ThemeData themeData() => _getThemeData();
}

// TextThemes class to define text styles based on the color scheme
class TextThemes {
  static String font = DIManager.findDep<SharedPrefs>().getFontType();
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_16,
      fontFamily: font,  // دالة لتحديد الخط المناسب
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_14,
      fontFamily: font,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_24,
      overflow: TextOverflow.ellipsis,
      fontFamily: font,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_20,
      fontFamily: font,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_15,
      fontFamily: font,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
    ),
    titleSmall: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_14,
      fontFamily: font,
      fontWeight: FontWeight.w700,
      overflow: TextOverflow.ellipsis,
    ),
    bodySmall: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_12,
      fontFamily: font,
      fontWeight: FontWeight.w800,
      overflow: TextOverflow.ellipsis,
    ),
    labelMedium: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_10,
      fontFamily: font,
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_10,
      overflow: TextOverflow.ellipsis,
      fontFamily:font,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      color: ThemeHelper._isDarkMode ? Colors.white : Colors.black,
      fontSize: AppFontSize.fontSize_11,
      overflow: TextOverflow.ellipsis,
      fontFamily: font,
      fontWeight: FontWeight.w600,
    ),
  );


}


PrimaryColors get appTheme => ThemeHelper.themeColor();
ThemeData get themeLite => ThemeHelper.themeData();
ThemeData get themeDark => ThemeHelper.themeData();
