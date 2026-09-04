import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/di/di_manager.dart';
import '../../core/shared_prefs/shared_prefs.dart';
import 'lbeena_colors.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.scaffoldBackgroundColor100,
      );

  // Outline decorations
  static BoxDecoration get outlineCyan => BoxDecoration(
        borderRadius: BorderRadiusStyle.circleBorder7,
        color: LbeenaColors.fieldFill,
        border: Border.all(color: LbeenaColors.fieldBorder),
      );
  static BoxDecoration get itemCartNew => BoxDecoration(
    color: appTheme.gray.withOpacity(.15),
    borderRadius: BorderRadius.all(Radius.circular(7.r)),
  );

  static BoxDecoration get itemIcon => BoxDecoration(
    color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'?appTheme.scaffoldBackgroundColor100: Colors.grey.shade200,
    border:DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'? Border.all(color: appTheme.greenColor,
      width: 0.5,):null,
    borderRadius: BorderRadius.circular(16),);

  static BoxDecoration get itemCart => BoxDecoration(
    color: appTheme.whiteA700,
    borderRadius: BorderRadius.all(Radius.circular(16.r)),
    border: Border.all(
      color: appTheme.containerCart.withOpacity(0.18),
      width: 0.8,
    ),
    boxShadow: [
      BoxShadow(
        color: LbeenaColors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
  static BoxDecoration get outlineButtonLite => BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
                color: appTheme.whiteA700,
                spreadRadius: 2.h,
                //blurRadius: 2.h,
                offset: Offset(
                  0,
                  0,
                ))
          ]);

  static BoxDecoration get outlineSelectedLite => BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
                color: appTheme.whiteA700,
                spreadRadius: 0.2.h,
                //blurRadius: 0.2.h,
                offset: Offset(
                  0,
                  0,
                ))
          ]);

  static BoxDecoration get outlinePurple => BoxDecoration(
          color: appTheme.white.withOpacity(.82),
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
                color: appTheme.deepPurpleA100,
                spreadRadius: 2.h,
                //blurRadius: 2.h,
                offset: Offset(
                  0,
                  0,
                ))
          ]);

  static BoxDecoration get outlineCompanies => BoxDecoration(
      color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'?appTheme.lightBlue200: Colors.grey.shade100,
      border: Border.all(color: LbeenaColors.fieldBorder),
      borderRadius: BorderRadius.circular(20)

  );
  static BoxDecoration get outlineSelectedPurple => BoxDecoration(
          // color: Colors.grey.shade100,
          color: appTheme.scaffoldBackgroundColor100,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
                color: appTheme.deepPurpleA100,
                spreadRadius: 2.h,
                //blurRadius: 2.h,
                offset: Offset(
                  0,
                  0,
                ))
          ]);

  static BoxDecoration get outlineCyan2 => BoxDecoration(
        color: LbeenaColors.fieldFill,
        borderRadius: BorderRadiusStyle.circleBorder7,
        border: Border.all(color: LbeenaColors.fieldBorder),
      );

  // Outline Ci decorations
  static BoxDecoration get outlineCircular => BoxDecoration(
        color: appTheme.lightBlue100,
        borderRadius: BorderRadius.all(Radius.circular(40.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.lightBlue100,
            spreadRadius: 2.h,
            //blurRadius: 2.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get appBar => BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(1111.r),
            bottomLeft: Radius.circular(1111.r)),
      );

  // Outline Ci decorations
  static BoxDecoration get outlineCircular2 => BoxDecoration(
        color: appTheme.lightBlue100,
        borderRadius: BorderRadius.all(Radius.circular(60.r)),
        boxShadow: [
          // BoxShadow(
          //   color:appTheme.lightBlue100,
          //   spreadRadius: 2.h,
          //   //blurRadius: 2.h,
          //   offset: Offset(
          //     0,
          //     0,
          //   ),
          // ),
        ],
      );

  static BoxDecoration get outlineCircular10 => BoxDecoration(
        color: appTheme.lightBlue100,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          // BoxShadow(
          //   color:appTheme.lightBlue100,
          //   spreadRadius: 2.h,
          //   //blurRadius: 2.h,
          //   offset: Offset(
          //     0,
          //     0,
          //   ),
          // ),
        ],
      );

  // Outline Ci decorations
  static BoxDecoration get outlineCircular3 => BoxDecoration(
        color: appTheme.greenColor,
        borderRadius: BorderRadius.all(Radius.circular(60.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.greenColor,
            spreadRadius: 0.5.h,
            //blurRadius: 0.5.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  // Outline Ci decorations
  static BoxDecoration get outlineButton => BoxDecoration(
        color: appTheme.buttonColor,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      );

  // Outline Ci decorations
  static BoxDecoration get outlineContainer => BoxDecoration(
        color: appTheme.borderImageColor,
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        border: Border.all(    color: Colors.grey, ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2.h,
            //blurRadius: 0,
            offset: Offset(
              2,
              2,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineTimer => BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.all(Radius.circular(2.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.deepPurpleA10001,
            spreadRadius: 1.h,
            //blurRadius: 6.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  // Outline Ci decorations
  static BoxDecoration get outlineCircular4 => BoxDecoration(
        color: appTheme.lightBlueBottomNavigatorBar,
        borderRadius: BorderRadius.all(Radius.circular(60.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.lightBlueBottomNavigatorBar,
            spreadRadius: 1,
            //blurRadius: 1,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
        border: Border.all(
          color: appTheme.lightBlueBottomNavigatorBar, // تحديد اللون كأسود هنا
          width: 1.0, // يمكنك تعديل عرض الحدود حسب الرغبة
        ),
      );


  static BoxDecoration get card3d => BoxDecoration(
    color: appTheme.lightBlueBottomNavigatorBar,
    borderRadius: BorderRadius.all(Radius.circular(7.r)),
    border: Border.all(color: appTheme.grey),
    boxShadow: [
      BoxShadow(
        color:  appTheme.grey,
        spreadRadius: 1,
        offset:const Offset(
          2,
          2,
        ),
      ),

    ],
  );
  static BoxDecoration get pointCyan => BoxDecoration(
        color: appTheme.lightBlue100,
        boxShadow: [
          BoxShadow(
            color: appTheme.poing600,
            spreadRadius: 2.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get pointChoose => BoxDecoration(
        color: appTheme.scaffoldBackgroundColor100,
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.poing600,
            spreadRadius: 1,
            //blurRadius: 0,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get cardPrice => BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(7.r)),
      color: appTheme.scaffoldBackgroundColor100.withOpacity(.6),
    border: Border.all(color: appTheme.black900)
  );

  static BoxDecoration get pointSelected => BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.poing600,
            spreadRadius: 1,
          
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get pointNotSelected => BoxDecoration(
        color: appTheme.scaffoldBackgroundColor100,
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.poing600,
            spreadRadius: 1,
            //blurRadius: 0,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get background => BoxDecoration(
        color: appTheme.deepPurpleA10001,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        boxShadow: [
          BoxShadow(
            color: appTheme.poing600,
            spreadRadius: 1,
            //blurRadius: 0,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get dropdownButtonChoose => BoxDecoration(
        color: appTheme.scaffoldBackgroundColor100,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      );

  static BoxDecoration get profileUi => BoxDecoration(
        color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'
            ? appTheme.lightBlueBottomNavigatorBar.withOpacity(.7)
            : appTheme.whiteA100.withOpacity(.9),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        // border: Border.all(
        //   color: appTheme
        //       .greenColor,
        //   width: 2,
        // ),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorAppBar,
            spreadRadius: 1,
            //blurRadius: 1,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get createPostUi => BoxDecoration(
        color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'
            ? appTheme.borderImageColor
            : Colors.white.withOpacity(.7),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r)),
        border: Border.all(
          color: appTheme.greenColor,
          width: 1.6,
        ),
      );
  static BoxDecoration get couponsUi => BoxDecoration(
    color: Colors.amber,
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15.r),
        topRight: Radius.circular(15.r)),
    // border: Border.all(
    //   color: appTheme.deepPurple,
    //   width: 1.6,
    // ),
  );

  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );

  // Gradient decorations
  static BoxDecoration get gradientPackage => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.84, 0.17),
          end: Alignment(0.18, 0.83),
          colors: [
            appTheme.whiteA700,
            appTheme.lime200,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        color: appTheme.lightBlue100,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: appTheme.black900.withOpacity(0.2),
          width: 0.2,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.5),
            spreadRadius: 0.2,
            // //blurRadius: 3,
            offset: Offset(
              -4,
              -4,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlueGrayA => BoxDecoration(
        // color: appTheme.deepPurpleA10001,
        boxShadow: [
          BoxShadow(
            color: appTheme.greenColorApp,
            spreadRadius: 1.h,
            //blurRadius: 1.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineWhiteA => BoxDecoration();

  static BoxDecoration get outlineWhiteB => BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: appTheme.deepPurpleA10001,
            spreadRadius: 1.h,
            //blurRadius: 6.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineWhiteA700 => BoxDecoration();
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder24 => BorderRadius.circular(
        24.r,
      );

  // Circle borders
  static BorderRadius get circleBorder7 => BorderRadius.circular(
        7.r,
      );

  // Circle borders
  static BorderRadius get circleBorder10 => BorderRadius.circular(
    10.r,
  );

  static BorderRadius get circleBorder60 => BorderRadius.circular(
        60.r,
      );

  // Circle borders
  static BorderRadius get circleBorder16 => BorderRadius.circular(
        16.r,
      );

  static BorderRadius get circleBorder40 => BorderRadius.circular(
        40.r,
      );

  static BorderRadius get circleBorder26 => BorderRadius.circular(
        70.r,
      );

  static BorderRadius get circleBorder20 => BorderRadius.circular(
        20.r,
      );

  static BorderRadius get circleBorder35 => BorderRadius.circular(
        35.r,
      );

  // Custom borders
  static BorderRadius get customBorderTL32 => BorderRadius.vertical(
        top: Radius.circular(32.r),
      );

  // Rounded borders
  static BorderRadius get roundedBorder32 => BorderRadius.circular(
        32.r,
      );
  // Rounded borders
  static BorderRadius get roundedBorder60 => BorderRadius.circular(
    60.r,
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
