import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/theme_helper.dart';

class SocialMediaWidget extends StatelessWidget {
  SocialMediaWidget({Key? key,required this.icon,required this.onTap})
      : super(
    key: key,
  );
  String icon;
  void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 4.w),
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
            child: CustomImageView(
              imagePath: icon,
              placeHolder: ImageConstant.imgCompanyD,
              height: 25.h,
              // fit: BoxFit.fill,
              width: 25.h,
              radius: BorderRadius.circular(7.r),
            ),
          ),
        ),
      ),
    );
  }
}
