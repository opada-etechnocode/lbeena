import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../widgets/components.dart';
import '../../widgets/custom_image_view.dart';
import '../theme/lbeena_colors.dart';

class BackGroundAuth extends StatelessWidget {
  BackGroundAuth({super.key, this.text});
  String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 220.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            LbeenaColors.tealDark,
            LbeenaColors.teal,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            sizeHeightNormal(height: 8.h),
            CustomImageView(
              imagePath: ImageConstant.logoAppWhite,
              height: 72.fSize,
              fit: BoxFit.contain,
            ),
            sizeHeightNormal(height: 8.h),
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: LbeenaColors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            sizeHeightNormal(height: 10.h),
            textNormal(
              text: AppLocalizations.of(context)!.welcome_to_company,
              fontWeight: FontWeight.w700,
              color: LbeenaColors.white,
              fontSize: AppFontSize.fontSize_22,
            ),
            sizeHeightNormal(height: 4.h),
            textNormal(
              text: text ?? AppLocalizations.of(context)!.login_to_continue,
              fontWeight: FontWeight.w400,
              color: LbeenaColors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class BackGroundAuthNotAllScreen extends StatelessWidget {
  BackGroundAuthNotAllScreen({super.key, this.text});
  String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Container(
        height: 170.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [LbeenaColors.tealDark, LbeenaColors.teal],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.h, left: 5.w, right: 5.w),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 22.h,
                    color: LbeenaColors.white,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.logoAppWhite,
                      height: 56.fSize,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalizations.of(context)!.welcome_to_company,
                      style: const TextStyle(
                        color: LbeenaColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      text ??
                          AppLocalizations.of(context)!.company_registration,
                      style: TextStyle(
                        color: LbeenaColors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
