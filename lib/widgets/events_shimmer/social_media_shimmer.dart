import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/theme/theme_helper.dart';
class SocialMediaShimmer extends StatelessWidget {
  SocialMediaShimmer({Key? key,})
      : super(
    key: key,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return  Padding(
            padding:  EdgeInsets.symmetric(horizontal: 4.w),
            child:  Shimmer.fromColors(
              baseColor: appTheme.baseColorShimmer,
              highlightColor:
              appTheme.highlightColorShimmer,
              child: Container(
                height: 70.h,
                width: 70.h,
                decoration: BoxDecoration(
                  color:      appTheme.lightBlue100,
                  borderRadius: BorderRadius.circular(
                    12.r,
                  ),
                ),
                child: Padding(
                  padding:  EdgeInsets.all(4.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color:      appTheme.lightBlue100,
                      borderRadius: BorderRadius.circular(
                        7.r,
                      ),
                    ),
                    height: 25.h,
                    // fit: BoxFit.fill,
                    width: 25.h,


                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
