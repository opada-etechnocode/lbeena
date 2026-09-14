import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';

class AdsStoreShimmer extends StatelessWidget {
  const AdsStoreShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizeHeightNormal(height: 5.h),
          BannerItemShimmer(
            baseColor: LbeenaColors.fieldBorder,
            highlightColor: LbeenaColors.lightBg,
          ),
          sizeHeightNormal(),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        mainAxisExtent: 228,
      ),
      itemCount: 4,
      padding: EdgeInsets.only(top: 2.h),
      itemBuilder: (context, index) => _buildProductItem(),
    );
  }

  Widget _buildProductItem() {
    return Container(
      decoration: LbeenaColors.cardWith(),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: LbeenaColors.fieldBorder,
        highlightColor: LbeenaColors.lightBg,
        period: const Duration(milliseconds: 1500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: LbeenaColors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: LbeenaColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 72,
                    height: 8,
                    decoration: BoxDecoration(
                      color: LbeenaColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 96,
                    height: 8,
                    decoration: BoxDecoration(
                      color: LbeenaColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: LbeenaColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
