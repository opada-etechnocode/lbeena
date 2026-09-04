import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';

class AdsStoreShimmer extends StatelessWidget {
  const AdsStoreShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizeHeightNormal(height: 5.h),
          BannerItemShimmer(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
          ),
          sizeHeightNormal(),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.75,
        ),
        itemCount: 3,
        padding: EdgeInsets.only(top: 5.h,left: 10.w,right: 10.w),
        itemBuilder: (context, index) => _buildProductItem(),
      ),
    );
  }

  Widget _buildProductItem() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
            color: Colors.grey[300]!,
          )),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: Duration(milliseconds: 1500), // إضافة تأثير أكثر سلاسة
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(7.r),
                ),
              ),
            ),

            // معلومات المنتج
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم
                  Container(
                    width: double.infinity,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
sizeHeightNormal(height: 5.h),
                  // السعرs
                  Container(
                    width: 60.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // التقييم
                  Row(
                    children: [
                      Container(
                        width: 16.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        width: 30.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3.r)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
