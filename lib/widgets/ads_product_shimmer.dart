import 'package:syrians_in_uae/core/constants/app_colors.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';

// ignore: must_be_immutable
class AdsProductShimmer extends StatelessWidget {
   AdsProductShimmer({Key? key,this.isNotNeedName =false})
      : super(
          key: key,
        );
bool isNotNeedName = false;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isNotNeedName?Container(): Shimmer.fromColors(
          baseColor: appTheme.baseColorShimmer,
          highlightColor: appTheme.highlightColorShimmer,

          child: Container(
            padding:
            EdgeInsets.only(left: 30.w,right: 30.w),
            height: 6.h,
            width: 90.w,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColorsController()
                      .defaultPrimaryColor,
                  width: 0.2),
              color: AppColorsController()
                  .defaultPrimaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(12.h),
              ),
            ),
          ),
        ),
        sizeHeightNormal(height: 20.h),
        ListView.builder(
            shrinkWrap: true,

        physics: NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
        return Padding(
          padding:  EdgeInsets.symmetric(vertical: 4.h),
          child: Container(
            height: 195.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                  boxShadow: [
                    // BoxShadow(
                    //     color: Colors.grey,
                    //     spreadRadius: 2.h,
                    //     blurRadius: 6.h,
                    //     offset: Offset(
                    //       -3,
                    //       -3,
                    //     )
                    // ),
                  ],
                // color: AppColorsController().defaultPrimaryColor,
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(40.r)
            ),
            child: Shimmer.fromColors(
              // baseColor: appTheme.cyan400,
              // highlightColor: appTheme.blue600,
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                // alignment: Alignment.bottomLeft,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120.h,
                            width:MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(

                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.r),
                                    topRight: Radius.circular(40.r)
                                )
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Container(
                            width: 109.w,height: 3.h,
                            margin: EdgeInsets.only(
                              left: 10.w,right: 10.w,
                              // bottom: 25.v,
                            ),
                      color: appTheme.scaffoldBackgroundColor100,
                          ),
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: 33.h),
                        child: Container(
                          height: 45.sp,
                          width: 45.sp,

                          decoration: AppDecoration.outlineCircular3.copyWith(color: Colors.grey),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 40.sp,width: 40.sp,
                                decoration: AppDecoration.outlineCircular3.copyWith(color: Colors.grey),
                                // color: AppColorsController().defaultPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                      sizeHeightNormal(),
                  Container(
                    width: 90.w,height: 3.h,
                    margin: EdgeInsets.only(
                      left: 10.w,right: 10.w,
                      // bottom: 25.v,
                    ),
                    color: appTheme.scaffoldBackgroundColor100,
                  ),
                  sizeHeightNormal(),
                  Container(
                    width: 70.w,height: 3.h,
                    margin: EdgeInsets.only(
                      left: 10.w,right: 10.w,
                      // bottom: 25.v,
                    ),
                    color: appTheme.scaffoldBackgroundColor100,
                  ),
                ],
              ),
            ),
          ),
        );}
        ),

      ],
    );
  }
}
