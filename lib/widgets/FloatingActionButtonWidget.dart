import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/di/di_manager.dart';
import '../core/helper/snack_bar_helper.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../ui/screens/auth/login/login_screen.dart';
import '../ui/screens/community/community.dart';
import '../ui/screens/home/widget/create_post.dart';
import '../ui/theme/lbeena_colors.dart';
import 'components.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  @override
  _FloatingActionButtonWidgetState createState() => _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> {
  // دالة لحساب القياسات النسبية
  double _responsiveSize(double size, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return size * (screenWidth / 375); // 375 هو عرض شاشة iPhone 8 كمرجع
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = _responsiveSize(isTypeIpad(context) ? 10 : 35, context);
    final textSize = _responsiveSize(11, context);
    final paddingValue = _responsiveSize(isTypeIpad(context) ?0:5, context);
    return Padding(
      padding: EdgeInsets.only(bottom: isTypeIpad(context) ? 140.h : (Platform.isIOS ? 52.h : 72.h)),
      child: SpeedDial(
        overlayColor: Colors.black12.withOpacity(.6),
        buttonSize: Size(
          _responsiveSize(isTypeIpad(context) ? 30 : 45, context),
          _responsiveSize(isTypeIpad(context) ? 30 : 45, context),
        ),
        iconTheme: IconThemeData(size: iconSize, color: Colors.white),
        backgroundColor: LbeenaColors.orange,
        foregroundColor: LbeenaColors.white,
        activeBackgroundColor: LbeenaColors.teal,
        activeForegroundColor: LbeenaColors.white,
        activeIcon: FontAwesomeIcons.xmark,
        children: [
          ///
          // SpeedDialChild(
          //   elevation: 0,
          //   child: Container(),
          //   backgroundColor: Colors.transparent,
          //   labelWidget: Row(
          //     children: [
          //       SizedBox(width: paddingValue),
          //       Container(
          //         height: iconSize,
          //         width: iconSize,
          //         decoration: AppDecoration.outlineWhiteA,
          //         child: Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             Container(
          //               height: iconSize,
          //               width: iconSize,
          //               decoration: AppDecoration.outlineCircular2,
          //             ),
          //             CustomImageView(
          //               imagePath: ImageConstant.currencies,
          //               height: smallIconSize,
          //               width: smallIconSize,
          //               color: appTheme.greenColorApp,
          //               alignment: Alignment.center,
          //             ),
          //           ],
          //         ),
          //       ),
          //       sizeWidthNormal(width: 4.w),
          //       textNormal(
          //         text:Platform.isIOS?  ' العملات':'العملات ',
          //         fontWeight: FontWeight.w800,
          //         color: Colors.white,
          //         fontSize: textSize,
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     navigatorToPush(context: context, pageName: CurrencyPage());
          //   },
          // ),
          // باقي العناصر بنفس النمط...
          SpeedDialChild(
            elevation: 0,
            child: Container(),
            backgroundColor: Colors.transparent,
            labelWidget: Row(
              children: [
                SizedBox(width: paddingValue),
                Container(
                  height: isTypeIpad(context) ? 60.sp : iconSize,
                  width: isTypeIpad(context) ? 60.sp : iconSize,
                  decoration: const BoxDecoration(
                    color: LbeenaColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.users,
                      size: 16,
                      color: LbeenaColors.teal,
                    ),
                  ),
                ),
                sizeWidthNormal(width: 4.w),
                textNormal(
                  text: 'انشر بوست',
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: textSize,
                ),
              ],
            ),
            onTap: () {
              navigatorToPush(context: context, pageName: CommunityPage());
            },
          ),
          SpeedDialChild(
            elevation: 0,
            child: Container(),
            backgroundColor: Colors.transparent,
            labelWidget: Row(
              children: [
                SizedBox(width: paddingValue),
                Container(
                  height: isTypeIpad(context) ? 60.sp : iconSize,
                  width: isTypeIpad(context) ? 60.sp : iconSize,
                  decoration: const BoxDecoration(
                    color: LbeenaColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.bullhorn,
                      size: 16,
                      color: LbeenaColors.orange,
                    ),
                  ),
                ),
                sizeWidthNormal(width: 4.w),
                textNormal(
                  text: 'انشر إعلان  ',
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: textSize,
                ),
              ],
            ),
            onTap: () {

              if (DIManager.findDep<SharedPrefs>().getToken() == null) {
                navigatorToPush(context: context, pageName: LoginScreen());
              } else {
                if(DIManager.findDep<SharedPrefs>().getStatusUser() =='2')
                {
                  SnackBarHelper.mySnackBarError(
                      ' تم رفض حسابك الرجاء مراجعة الدعم ..', context);
                  return;
                }
                if(DIManager.findDep<SharedPrefs>().getStatusUser() =='0')
                {
                  SnackBarHelper.mySnackBarPending(
                      'حساب شركتك قيد المراجعة يرجى الانتظار ..',
                      context);
                  return;
                }
                navigatorToPush(context: context, pageName: CreatePost());
              }
            },
          ),
        ],
        child: const FaIcon(FontAwesomeIcons.plus, size: 20, color: Colors.white),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         _buildDot(context),
        //         SizedBox(width: _responsiveSize(4, context)),
        //         _buildDot(context),
        //       ],
        //     ),
        //     SizedBox(height: _responsiveSize(4, context)),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         _buildDot(context),
        //         SizedBox(width: _responsiveSize(4, context)),
        //         _buildDot(context),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }
  Widget _buildDot(BuildContext context) {
    return Container(
      width: _responsiveSize(isTypeIpad(context)?4:8, context),
      height: _responsiveSize(isTypeIpad(context)?4:8, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}