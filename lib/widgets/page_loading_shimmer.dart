import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../ui/theme/theme_helper.dart';

class PageLoadingShimmer extends StatelessWidget {
  const PageLoadingShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.r),
                ),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      for (int i = 0; i < 3; i++) ...{
                        Shimmer.fromColors(
                          baseColor: appTheme.baseColorShimmer,
                          highlightColor: appTheme.highlightColorShimmer,

                          direction: ShimmerDirection.ltr,
                          child: Padding(
                            padding:  EdgeInsets.all(8.h),
                            child: Container(
                              height: 8.h,
                              color: Theme.of(context).cardColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      for (int i = 0; i < 3; i++) ...{
                        Shimmer.fromColors(
                          baseColor: appTheme.baseColorShimmer,
                          highlightColor: appTheme.highlightColorShimmer,
                          direction: ShimmerDirection.ltr,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 8,
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Column(
                  children: [
                    for (int i = 0; i < 10; i++) ...{
                      Shimmer.fromColors(
                        baseColor: appTheme.baseColorShimmer,
                        highlightColor: appTheme.highlightColorShimmer,
                        direction: ShimmerDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 8,
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
