import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/theme_helper.dart';

class NotFoundInternet extends StatelessWidget {
  const NotFoundInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // decoration: AppDecoration.fillGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgInternetNotHave,
            height: 300.h,
            width: 300.h,
            radius: BorderRadius.circular(300.r),
          ),
          sizeHeightNormal(height: 15.h),
          textNormal(text: 'لايوجد اتصال بالإنترنت ..')
        ],
      ),
    );
  }
  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: appTheme.lightBlue100,
              spreadRadius: 6,
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            appTheme.colorAppBar.withOpacity(0.7), // لون الأسفل
            appTheme.whiteA700,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 25.h),
        child: Column(
          children: [
            sizeHeightNormal(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // sizeWidthNormal(width: 100.w),
                Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgLogoApp,
                  height: 50.h,
                  // width: 60.h,
                ),
              ],
            ),
            sizeHeightNormal(),
          ],
        ),
      ),
    );
  }

}
