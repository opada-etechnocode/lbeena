
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import '../../../../core/utils/endpoints.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/home_page/home_page_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';

// ignore: must_be_immutable
class FilterItemWidget extends StatelessWidget {
   FilterItemWidget({Key? key,required this.icon,required this.title,required this.onTap})
      : super(
          key: key,
        );
  String icon;
  String title;
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
          height: 130.h,
          width: 130.h,
          decoration: BoxDecoration(
            color:      appTheme.lightBlue100,
            borderRadius: BorderRadius.circular(
              7.r,
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.all(4.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sizeHeightNormal(height: 2.h),
                CustomImageView(
                  imagePath: icon,
                  placeHolder: ImageConstant.imgCompanyD,
                  height: 60.h,
                  fit: BoxFit.fill,
                  width: 60.h,
                  radius: BorderRadius.circular(7.r),
                ),
                // sizeHeightNormal(height: 5.h),
                // textNormalTitleCompany(text:company!.companyName.toString(),
                // )
                sizeHeightNormal(height: 5.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width:100.w,
                        child: Center(child: textNormal(text: title,fontSize: 11.fSize))),
                    sizeHeightNormal(height: 2.h),
                    // Container(
                    //   decoration: AppDecoration.itemCart.copyWith(
                    //     color: appTheme.whiteA700.withOpacity(.4),
                    //     borderRadius: BorderRadius.all(Radius.circular(5.r)),),
                    //
                    //   child: Padding(
                    //     padding:
                    //     EdgeInsets.all(4.r),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Column(
                    //           children: [
                    //             textNormal(text: 'رقم البوث',fontSize: 8.fSize,fontWeight: FontWeight.w100),
                    //             textNormal(text:  company!.id.toString(),fontSize: 9.fSize,fontWeight: FontWeight.w100),
                    //           ],
                    //         ),
                    //         sizeWidthNormal(),
                    //         Column(
                    //           children: [
                    //             textNormal(text:'الإعلانات',fontSize: 8.fSize,fontWeight: FontWeight.w100),
                    //             textNormal(text:  company!.adsCount.toString(),fontSize: 9.fSize,fontWeight: FontWeight.w100),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
