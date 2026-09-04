
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';


// ignore: must_be_immutable
class BoothShimmer extends StatelessWidget {
  const BoothShimmer({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,padding: EdgeInsets.zero,
        itemBuilder: (context,index){
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 7.w,vertical: 10.h),
            child: Shimmer.fromColors(
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child: Container(
                width: (400.w) ,
                height: 6 .h,
                decoration: AppDecoration.outlineContainer
                    .copyWith(color: Colors.grey,boxShadow: []),
              ),
            ),
          );
        });
  }
}
