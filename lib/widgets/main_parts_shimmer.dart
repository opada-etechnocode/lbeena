import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants/app_colors.dart';
import '../ui/theme/app_decoration.dart';

class MainPartsShimmer extends StatefulWidget {
   MainPartsShimmer({super.key,this.isFromAddAds =false});
bool  isFromAddAds =false;
  @override
  State<MainPartsShimmer> createState() => _MainPartsShimmerState();
}

class _MainPartsShimmerState extends State<MainPartsShimmer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // widget.isFromAddAds?Container():  Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 8.w),
        //   child: Shimmer.fromColors(
        //     baseColor: appTheme.baseColorShimmer,
        //     highlightColor: appTheme.highlightColorShimmer,
        //
        //     child: Container(
        //       padding:
        //       EdgeInsets.symmetric(horizontal: 2.w),
        //       height: 6.h,
        //       width: 90.w,
        //       decoration: BoxDecoration(
        //         border: Border.all(
        //             color: AppColorsController()
        //                 .defaultPrimaryColor,
        //             width: 0.2),
        //         color: AppColorsController()
        //             .defaultPrimaryColor,
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(12.r),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
       sizeHeightNormal(),
        Container(
          height: 40.h,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 104.w,
                child: Shimmer.fromColors(
                  baseColor: appTheme.baseColorShimmer,
                  highlightColor: appTheme.highlightColorShimmer,

                  child:  Container(
                    height: 30.h,
                    decoration: AppDecoration.outlineButton,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10.w,
              );
            },
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: 4,
            scrollDirection: Axis.horizontal,
          ),
        ),
        sizeHeightNormal()
      ],
    );
  }
}
