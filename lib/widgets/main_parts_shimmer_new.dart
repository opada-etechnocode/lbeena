import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants/app_colors.dart';
import '../ui/theme/app_decoration.dart';

class MainPartsShimmerNew extends StatefulWidget {
   MainPartsShimmerNew({super.key,});

  @override
  State<MainPartsShimmerNew> createState() => _MainPartsShimmerNewState();
}

class _MainPartsShimmerNewState extends State<MainPartsShimmerNew> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 190.h,width: MediaQuery.of(context).size.width,
      child:    GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 60.h,
        crossAxisCount: 4,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 2.h,
      ),
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 12, // يمكن تعديل العدد حسب احتياجك
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Shimmer.fromColors(
            baseColor: appTheme.baseColorShimmer,
            highlightColor: appTheme.highlightColorShimmer,
            child: Container(
              height: 60.h,
              width: 60.h,
              decoration: BoxDecoration(
                color: appTheme.lightBlue100,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(2.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      width: 50.w,
                      height: 12.h, // ارتفاع النص التقريبي
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )

    );
  }
}
