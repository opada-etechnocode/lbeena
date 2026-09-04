import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';


// ignore: must_be_immutable
class BannerItemShimmer extends StatelessWidget {
   BannerItemShimmer({Key? key,this.baseColor,this.highlightColor})
      : super(
          key: key,
        );
Color? baseColor;
Color? highlightColor;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // baseColor: appTheme.cyan400,
      // highlightColor: appThe  me.blue600,
      baseColor:baseColor?? appTheme.baseColorShimmer,
      highlightColor:highlightColor?? appTheme.highlightColorShimmer,

      child: Container(
        width: 361.w,
        height: 154.h,
        margin: EdgeInsets.only(left: 2.w, right: 2.w),
        padding: EdgeInsets.symmetric(
          horizontal: 15.h,
          vertical: 1.w,
        ),
        decoration: AppDecoration.fillWhiteA.copyWith(
          borderRadius: BorderRadiusStyle.circleBorder7,
          // image: DecorationImage(
          //   image: AssetImage(
          //     ImageConstant.imgFrame4,
          //   ),
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}


