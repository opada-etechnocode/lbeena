import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';

import '../core/utils/endpoints.dart';
import '../core/utils/image_constant.dart';
import '../ui/screens/company/info_company.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';
import 'components.dart';
import 'custom_image_view.dart';

class UserImageProfile extends StatelessWidget {
   UserImageProfile({super.key,required this.imageUrl
   ,
   this.height,
     this.width,
     this.onTap,
   });
String imageUrl;
   double? height;
   double? width;
   void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap?? () {
        if(imageUrl.toString() != "null"||
            imageUrl.toString() != '/img/user_pic.jpg')
        { navigatorToPush(
            context: context,
            pageName: ShowCommercialLicense(
              commercialLicense:
              imageUrl.toString().contains('http')
                  ? imageUrl.toString()
                  : AppEndpoints.baseUrlWithoutApi +
                  imageUrl.toString(),
              isPdf: false,
              isProfile: true,
            ));}

      },
      child: Container(
        height: height?? 35.sp,
        width: width?? 35.sp,
        decoration: AppDecoration.outlineWhiteA,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 40.sp, width: 40.sp,
              decoration: AppDecoration.outlineCircular
                  .copyWith(boxShadow: []
                  ,color: (imageUrl.toString() == "null"||
                      imageUrl.toString() == '/img/user_pic.jpg')?null: Colors.white,
              border:(imageUrl.toString() == "null"||
                  imageUrl.toString() == '/img/user_pic.jpg')? Border.all(
                color: appTheme.greenColorApp,
                width: 1.5.w,
              ):null),
              // color: AppColorsController().defaultPrimaryColor,
            ),
            if(imageUrl.toString() == "null"||
          imageUrl.toString() == '/img/user_pic.jpg')...{
              CustomImageView(
                imagePath: ImageConstant.imgSettings,
                width: 25.sp,
                height: 25.sp,
                alignment: Alignment.center,
                radius: BorderRadius.circular(30.r),
                placeHolder: ImageConstant.imgSettings,
                color: appTheme.greenColorApp,
                fit: BoxFit.contain,
              ),
            }else...{
              CustomImageView(
                imagePath:
                imageUrl.toString().contains('http')
                    ? imageUrl.toString()
                    : AppEndpoints.baseUrlWithoutApi +
                    imageUrl.toString(),
                width: 40.sp,
                height: 40.sp,
                alignment: Alignment.center,
                radius: BorderRadius.circular(30.r),
                placeHolder: ImageConstant.imgSettings,
                color: null,
                fit: BoxFit.cover,
              ),
            }

          ],
        ),
      ),
    );
  }
}
