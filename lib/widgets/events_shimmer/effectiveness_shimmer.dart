import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

import '../../../../data/models/events/effectiveness.dart';
import '../../ui/theme/theme_helper.dart';


class EffectivenessShimmer extends StatelessWidget {
   EffectivenessShimmer({super.key,});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 10,
      scrollDirection: Axis.vertical,
    itemBuilder: (context,index){
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
          child: Shimmer.fromColors(
            baseColor: appTheme.baseColorShimmer,
            highlightColor: appTheme.highlightColorShimmer,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120.h,
              decoration: BoxDecoration(
                color:      appTheme.lightBlue100,
                borderRadius: BorderRadius.circular(
                  7.r,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomImageView(
                    height: 120.h,
                    width: 100.w,
                    radius: BorderRadius.circular(7.r),
                    fit: BoxFit.fill,
                  ),
                  sizeWidthNormal(),


                ],
              ),
            ),
          ),
        );
    },
    );
  }
}
