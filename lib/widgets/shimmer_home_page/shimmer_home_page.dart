import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../ui/theme/theme_helper.dart';
import '../components.dart';
import '../custom_page_shimmer.dart';

class ShimmerHomePage extends StatelessWidget {
  const ShimmerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 58.sp,
            padding: EdgeInsets
                .symmetric(
                horizontal:
                10.w,
                vertical:
                5.h),
            width:
            MediaQuery.of(
                context)
                .size
                .width,
            decoration:
            BoxDecoration(
              color: appTheme
                  .highlightColorShimmer
                  .withOpacity(
                  .8),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Shimmer
                    .fromColors(
                  baseColor:
                  appTheme
                      .baseColorShimmer,
                  highlightColor:
                  appTheme
                      .highlightColorShimmer,
                  child:
                  Container(
                    height: 8.h,
                    width:
                    100.w,
                    decoration: BoxDecoration(
                        color: appTheme
                            .baseColorShimmer,
                        borderRadius:
                        BorderRadius.circular(8.r)),
                  ),
                ),
                sizeHeightNormal(
                    height:
                    6.h),
                Shimmer
                    .fromColors(
                  baseColor:
                  appTheme
                      .baseColorShimmer,
                  highlightColor:
                  appTheme
                      .highlightColorShimmer,
                  child:
                  Container(
                    height: 6.h,
                    width:
                    150.w,
                    decoration: BoxDecoration(
                        color: Colors
                            .grey,
                        borderRadius:
                        BorderRadius.circular(8.r)),
                  ),
                ),
                sizeHeightNormal(
                    height:
                    5.h),
                Shimmer
                    .fromColors(
                  baseColor:
                  appTheme
                      .baseColorShimmer,
                  highlightColor:
                  appTheme
                      .highlightColorShimmer,
                  child:
                  Container(
                    height: 6.h,
                    width:
                    200.w,
                    decoration: BoxDecoration(
                        color: Colors
                            .grey,
                        borderRadius:
                        BorderRadius.circular(8.r)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(
                top: 10.h),
            child:
            const CustomPageShimmer(),
          ),
        ],
      ),
    );
  }
}
