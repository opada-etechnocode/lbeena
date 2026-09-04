import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/image_constant.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';

// ignore: must_be_immutable
class ViewCompanyItemWidget extends StatelessWidget {
   ViewCompanyItemWidget({Key? key,this.company})
      : super(
          key: key,
        );
   CompanyDatum? company;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        padding: EdgeInsets.all(2.r),
        decoration: AppDecoration.outlineBlueGrayA.copyWith(
          borderRadius: BorderRadiusStyle.circleBorder20,

        ),
        child: Container(
          // height: 30.fSize,
          // width: 30.fSize,
          decoration: BoxDecoration(
            // color: appTheme.poing600,
            borderRadius: BorderRadius.circular(
              17.r,
            ),
          ),
          child: Row(
            children: [
              CustomImageView(
                imagePath: company!.profilePic.toString().contains('http')?company!.profilePic.toString(): AppEndpoints.baseUrlWithoutApi +company!.profilePic.toString(),
                placeHolder: ImageConstant.imgCompanyD,
                height: 25.fSize,fit: BoxFit.cover,

                width: 25.fSize,radius: BorderRadius.circular(40.r),
              ),
              sizeWidthNormal(
                width: 5
              ),
              Expanded(
                child: textNormalTitleCompany(text:company!.companyName.toString(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
