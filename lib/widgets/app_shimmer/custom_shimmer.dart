import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../ui/theme/app_decoration.dart';
import '../../ui/theme/theme_helper.dart';
import '../components.dart';

Widget CustomShimmer ({required Widget child}){
  return Shimmer.fromColors(
      baseColor: appTheme.baseColorShimmer,
      highlightColor:
      appTheme.highlightColorShimmer,
  child: child,);
}

Widget usersFollowingShimmer(){
  return Padding(
    padding: EdgeInsets.all(4.sp),
    child: CustomShimmer(
      child: Container(
        decoration: AppDecoration.outlineContainer.copyWith(boxShadow: []),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CustomShimmer(
                child: Container(
                  width: 40.r,
                  height:  40.r,
                  decoration: AppDecoration.outlineContainer.copyWith(boxShadow: [],borderRadius: BorderRadiusStyle.circleBorder60),
                ),
              ),
              sizeWidthNormal(width: 5.w),
              CustomShimmer(
                child: Container(
                  width: 200.r,
                  height:  9.r,
                  decoration: AppDecoration.outlineContainer.copyWith(boxShadow: [],borderRadius: BorderRadiusStyle.circleBorder60),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}