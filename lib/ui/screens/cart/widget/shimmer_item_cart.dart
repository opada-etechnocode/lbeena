import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/lbeena_colors.dart';

class ShimmerItemCart extends StatelessWidget {
  ShimmerItemCart({super.key, this.isOrderPage = false});
  bool isOrderPage = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: isOrderPage
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            decoration: LbeenaColors.cardWith(),
            padding: EdgeInsets.all(10.w),
            child: Shimmer.fromColors(
              baseColor: LbeenaColors.fieldBorder,
              highlightColor: LbeenaColors.lightBg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 78.w,
                    height: 78.w,
                    decoration: BoxDecoration(
                      color: LbeenaColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140.w,
                          height: 10,
                          decoration: BoxDecoration(
                            color: LbeenaColors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 90.w,
                          height: 8,
                          decoration: BoxDecoration(
                            color: LbeenaColors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 70.w,
                          height: 10,
                          decoration: BoxDecoration(
                            color: LbeenaColors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
