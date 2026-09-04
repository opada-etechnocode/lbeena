import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';

import '../../../../data/models/following/following_general_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../company_details_page.dart';

class UserCardFollowing extends StatelessWidget {
  FollowingList dataList;

  UserCardFollowing({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigatorToPush(
            context: context,
            pageName: CompanyDetailsPage(
              idCompany: int.parse(dataList.id.toString()),
            ));
      },
      child: Padding(
        padding: EdgeInsets.all(4.sp),
        child: Container(
          decoration: AppDecoration.outlineContainer.copyWith(boxShadow: []),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: AppDecoration.outlineCircular4,
                    child: dataList.profilePic == null
                        ? CustomImageView(
                            width: 35.r,
                            height: 35.r,
                            color: appTheme.greenColor,
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            radius: BorderRadius.circular(30.h),
                            imagePath: ImageConstant.imgPerson,
                          )
                        : CustomImageView(
                            imagePath: dataList.profilePic,
                            width: 35.r,
                            height: 35.r,
                            alignment: Alignment.center,
                            radius: BorderRadius.circular(30.h),
                            fit: BoxFit.cover,
                            placeHolder: ImageConstant.imgPerson,

                          ),
                  ),
                ),
                sizeWidthNormal(width: 10.w),
                Container(
                    width: 240.w,
                    child: textNormal(text: dataList.companyName ?? '')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
