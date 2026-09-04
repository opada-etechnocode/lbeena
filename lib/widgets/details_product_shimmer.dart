import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../ui/theme/theme_helper.dart';


// ignore: must_be_immutable
class DetailsProductShimmer extends StatelessWidget {
  const DetailsProductShimmer({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          // height: 300.h,
          decoration: AppDecoration.fillWhiteA.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder40,
            color: appTheme.highlightColorShimmer.withOpacity(.6),boxShadow: []
            // image: DecorationImage(
            //   image: AssetImage(
            //     ImageConstant.imgFrame4,
            //   ),
            //   fit: BoxFit.cover,
            // ),
          ),

          child: Shimmer.fromColors(
            baseColor: appTheme.baseColorShimmer,
            highlightColor: appTheme.highlightColorShimmer,

            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 190.h,
                  decoration: AppDecoration.outlineContainer
                      .copyWith(color: Colors.grey,boxShadow: []),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizeHeightNormal(),
                      Container(
                        width: 70.w,
                        height: 4.h,
                        decoration: AppDecoration.outlineContainer
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [

                          Spacer(),
                          Container(
                            width: 40.w,
                            height: 4.h,
                            decoration: AppDecoration.outlineContainer
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        width: 80.w,
                        height: 4.h,
                        decoration: AppDecoration.outlineContainer
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 38.h,
                                width: 100.w,
                                decoration: AppDecoration.outlineButtonLite,

                              ),
                              Container(
                                height: 38.h,
                                width: 100.w,
                                decoration: AppDecoration.outlineButtonLite,

                              ),
                              Container(
                                height: 38.h,
                                width: 100.w,
                                decoration: AppDecoration.outlineButtonLite,

                              ),
                            ],
                          ),
                          sizeHeightNormal(
                            height: 25.h
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        sizeHeightNormal(),
        Container(
          height: 88.h,
          width: MediaQuery.of(context).size.width,
          decoration: AppDecoration.outlineCircular.copyWith(color: appTheme.highlightColorShimmer,boxShadow: [],),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            child: Shimmer.fromColors(
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeHeightNormal(),
                  Container(
                    width: 70.w,
                    height: 4.h,
                    decoration: AppDecoration.outlineContainer
                        .copyWith(color: Colors.grey),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          // iconSvg(iconSvg: ImageConstant.iconEyes),
                          SizedBox(width: 8.w,),
                          Container(
                            width: 30.w,
                            height: 4.h,
                            decoration: AppDecoration.outlineContainer
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        height: 50.h,
                        width: 4.w,
                        decoration: AppDecoration.outlineContainer
                            .copyWith(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 4.h,
                            decoration: AppDecoration.outlineContainer
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
sizeHeightNormal(),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 7.w),
          child: Shimmer.fromColors(
            baseColor: appTheme.baseColorShimmer,
            highlightColor: appTheme.highlightColorShimmer,

            child: Container(
              width: 120.w,
              height: 4.h,
              decoration: AppDecoration.outlineContainer
                  .copyWith(color: Colors.grey,boxShadow: []),
            ),
          ),
        ),
        sizeHeightNormal(),
        Container(
          height: 88.h,
          width: MediaQuery.of(context).size.width,
          decoration: AppDecoration.outlineCircular.copyWith(color: appTheme.highlightColorShimmer,boxShadow: [],),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            child: Shimmer.fromColors(
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeHeightNormal(),
                  Container(
                    width: 70.w,
                    height: 4.h,
                    decoration: AppDecoration.outlineContainer
                        .copyWith(color: Colors.grey),
                  ),
                  sizeHeightNormal(
                    height: 20.h
                  ),
                  Container(
                    width: 120.w,
                    height: 4.h,
                    decoration: AppDecoration.outlineContainer
                        .copyWith(color: Colors.grey),
                  ),
                  sizeHeightNormal(
                      height: 20.h
                  ),
                  Container(
                    width: 220.w,
                    height: 4.h,
                    decoration: AppDecoration.outlineContainer
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
