import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../di/di_manager.dart';
import '../shared_prefs/shared_prefs.dart';

// import '../../../../blocs/application/application_bloc.dart';

class AppColorsController {
  AppColorsController();

  Rx<Color?> _primaryColor = Color(0xff79C3E3).obs;
  String _primaryColorStr = '#' + Color(0xfffcd6d5).value.toRadixString(16);

  Color get primaryColor => _primaryColor.value ?? this.defaultPrimaryColor;

  String get primaryColorStr => _primaryColorStr;

  setPrimaryColor(Color? color) {
    // print('setPrimaryColor $color');
    if (color == null) {
      _primaryColor.value = defaultPrimaryColor;
      _primaryColorStr = '#' + Color(0xff79C3E3).value.toRadixString(16);
      // ThemeProvider().refreshColor();
      return;
    }
    // _primaryColorStr = "#" + color.toString().split('(0x')[1].split(')')[0];
    _primaryColorStr = '#' + color.value.toRadixString(16);
    _primaryColor.value = color;
    // ThemeProvider().refreshColor();
  }

  void resetPrimaryColor() {
    setPrimaryColor(defaultPrimaryColor);
  }

  Color defaultPrimaryColor  = appTheme.defaultPrimaryColor;
  Color white  = Colors.white;


  Color black = Colors.black ;
  // Color dropdown =
  // ThemeProvider().appMode == "light" ? Color(0xFF78181C) : Colors.black;
  // Color greyTextColor = Color(0xFFACB1C0);
  // Color scaffoldBGColor = ThemeProvider().appMode == "light"
  //     ? Color(0xFFFCD6D5)
  //     : Color(0xFF191D20);
  //
  // Color pobColor =
  //      Color(0xFFEAE5E5);
  //
  //
  // Color scaffoldBGColorAdds = ThemeProvider().appMode == "light"
  //     ? Color(0xFFF5F1F2)
  //     : Color(0xFF191D20);
  //
  // Color borderColor =
  //     ThemeProvider().appMode == "light" ? Color(0xFF460003) : Colors.white;
  // Color borderGrayColor = Color(0xFF707070);
  // Color buttonRedColor = Color(0xFF89393D);
  // Color iconColor =
  //     ThemeProvider().appMode == "light" ? Color(0xFFDE0F17) : Colors.white;
  // Color iconColor2 =
  // ThemeProvider().appMode == "light" ? Color(0xFFDE0F17) : Colors.black54;
  // Color selectIconColor = Color(0xFFDE0F17);
  // Color unSelectIconColor =
  //     ThemeProvider().appMode == "light" ? Color(0xFFDE0F17) : Colors.white;
  // Color textPrimaryColor =
  //     ThemeProvider().appMode == "light" ? Color(0xFF650101) : Colors.white;
  // Color textButtonBackground = Color(0x00000000);
  // Color defaultPrimaryColor = ThemeProvider().appMode == "light"
  //     ? Color(0xfffcd6d5)
  //     : Color(0xFF191D20);
  // Color chatPrimaryColor = ThemeProvider().appMode == "light"
  //     ? Color(0x80fcddd5)
  //     : Color(0xFF18171C);
  // Color containerPrimaryColor = ThemeProvider().appMode == "light"
  //     ? Color(0x4DFCD6D5)
  //     : Color(0xFF18171C);
  // Color buttonPrimaryColor = Color(0x26FCD6D5);
  // Color secondaryColor =
  //     ThemeProvider().appMode == "light" ? Color(0xffcd0300) : Colors.white;
  // Color darkGreyTextColor =
  //     ThemeProvider().appMode == "light" ? Color(0xFF595959) : Colors.white;
  // Color greyIconColor = Color(0xFFD9D9D9);
  // Color naveTextColor =
  //     ThemeProvider().appMode == "light" ? Color(0xF5001831) : Colors.white;
  // Color red =
  //     ThemeProvider().appMode == "light" ? Color(0xFFF44336) : Colors.white;
  // Color greyBackground = ThemeProvider().appMode == "light"
  //     ? Color(0xFFFAE6E5)
  //     : Color(0x26FCD6D5);
  // Color notSelectedGrey = Color(0xFF7A8FA6);
  // Color white =
  //     ThemeProvider().appMode == "light" ? Colors.white : Color(0xFF191D20);
  //
  // Color whiteBackground =
  // ThemeProvider().appMode == "light" ? Color(0xFFFFFBFA) : Color(0xFF191D20);
  //
  // Color grey =
  // ThemeProvider().appMode == "light" ? Color(0xFFD7D3D2) : Color(0xFFD7D3D2);
  //
  // Color lightGrey =
  // ThemeProvider().appMode == "light" ? Color(0xFFF2ECEC) : Color(0xFFF2ECEC);
  //
  // Color darkRed = Color(0xFF8E3C40);
  // Color lightRed = Color(0xFFB88389);
  // Color colorBarRed = Color(0xFFF6BFBE);
  // Color card = ThemeProvider().appMode == "light" ? Color(0xFFFEF0F0):Colors.black26;
  Color dialog = Color(0xFFE8E1E1);
  Color textColor = Color(0xFF040000);
}


Color primaryColor = const Color(0xfffff5fb);
Color darkPrimaryColor = const Color(0xff353A40);
Color bottomNavColorDark = const Color(0xff1F2328);
Color bottomNavColorLight = appTheme.lightBlueBottomNavigatorBar;

Color secondaryColor = appTheme.lightBlue100;
Color secondaryColorDark = const Color(0xff9174F7);

Color grey = const Color(0xff9B9C9F);
Color canvasDarkGrey = const Color(0xffb7b7b7);
Color bottomBarUnselectedColor = const Color(0xff06080F);
Color bottomBarUnselectedColorDark = const Color(0xffbebebe);

Color dividerColor = const Color(0xffC8CAD2);
Color dividerColorDark = const Color(0xa6a3a4b4);

Color black = Colors.black;
Color darkBlack = Colors.white;

Color cardColor = secondaryColor;

Color darkCardColor = const Color(0xff2A2C35);

Color shimmerBaseColor = Colors.white;
Color shimmerDarkBaseColor = const Color(0xff3d3d4e);

Color shimmerHighlightColorLight = const Color(0xa5acafc3);
Color shimmerHighlightColorDark = const Color(0xa8acafc3);

Color textFieldFillColorLight = appTheme.lightBlue100;
Color textFieldFillColorDark = const Color(0xff1A1C1F);

Color darkGrey = const Color(0xff9095A5);

Color bodyTextColorLight = const Color(0xff9095A5);
Color solidGrey = const Color(0xff494E58);

Color bodyTextColorDark = const Color(0xffb7b7b7);
Color bodyMTextColorDark = const Color(0xffeaeaea);

Color iconColorDark = secondaryColorDark;
Color iconColorLight = secondaryColor;

Color cardShadowColor = const Color(0xff06080F);
Color cardShadowColorDark = const Color(0xff06080F);

Color blueShadowColor = const Color(0xff00A1C4);
Color purpleShadowColor = appTheme.deepPurpleA10001;
Color blackShadowColor = const Color(0xff101012);


NeumorphicStyle getNeumorphicStyle() {
  return NeumorphicStyle(
    shape: NeumorphicShape.flat,
    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
    shadowLightColor:
    DIManager.findDep<SharedPrefs>().appMode =='d' ? blackShadowColor : appTheme.cyan600,
    shadowDarkColor:  DIManager.findDep<SharedPrefs>().appMode =='d'
        ? blackShadowColor
        : blueShadowColor.withOpacity(0.4),
    lightSource: LightSource.bottomRight,
  );
}
