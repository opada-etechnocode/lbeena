import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';

import '../../auth/login/model_home_page.dart';
import '../subscribe_ugc_page.dart';

class SubscribeUGCWidget extends StatelessWidget {
   SubscribeUGCWidget({super.key, required this.dateHomePage ,});

  HomePageLoginModel dateHomePage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CustomElevatedButton(

        buttonStyle:  ElevatedButton.styleFrom(
          backgroundColor: LbeenaColors.teal,
          foregroundColor: LbeenaColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular( 14.r),
          ),),
        buttonTextStyle: themeLite.textTheme.titleSmall!.copyWith(
          fontSize: 12.fSize,
          color: LbeenaColors.white,
        ),
        text: 'انضم إلى نظام المحتوى الذي يصنعه المستخدم (UGC)',
        onPressed: () {
          navigatorToPush(context: context, pageName: SubscribeSgcPage(
            dateHomePage: dateHomePage,
          ));
        },
      ),
    );
  }
}
