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

bool isEmptyProfileImage(String? imageUrl) {
  final value = imageUrl?.toString().trim() ?? '';
  if (value.isEmpty ||
      value == 'null' ||
      value == 'default_image_url' ||
      value == '/img/user_pic.jpg') {
    return true;
  }
  return value.endsWith('/null') || value.endsWith('user_pic.jpg');
}

class UserImageProfile extends StatelessWidget {
  UserImageProfile({
    super.key,
    required this.imageUrl,
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
    final hasNoPhoto = isEmptyProfileImage(imageUrl);
    final size = height ?? 35.sp;
    final sizeW = width ?? 35.sp;
    return GestureDetector(
      onTap: onTap ??
          () {
            if (!hasNoPhoto) {
              navigatorToPush(
                  context: context,
                  pageName: ShowCommercialLicense(
                    commercialLicense: imageUrl.toString().contains('http')
                        ? imageUrl.toString()
                        : AppEndpoints.baseUrlWithoutApi + imageUrl.toString(),
                    isPdf: false,
                    isProfile: true,
                  ));
            }
          },
      child: Container(
        height: size,
        width: sizeW,
        decoration: AppDecoration.outlineWhiteA,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size,
              width: sizeW,
              decoration: AppDecoration.outlineCircular.copyWith(
                boxShadow: [],
                color: hasNoPhoto ? null : Colors.white,
                border: hasNoPhoto
                    ? Border.all(
                        color: appTheme.greenColorApp,
                        width: 1.5.w,
                      )
                    : null,
              ),
            ),
            if (hasNoPhoto) ...{
              CustomImageView(
                imagePath: ImageConstant.imgPerson,
                width: sizeW,
                height: size,
                alignment: Alignment.center,
                radius: BorderRadius.circular(30.r),
                placeHolder: ImageConstant.imgPerson,
                fit: BoxFit.cover,
              ),
            } else ...{
              CustomImageView(
                imagePath: imageUrl.toString().contains('http')
                    ? imageUrl.toString()
                    : AppEndpoints.baseUrlWithoutApi + imageUrl.toString(),
                width: sizeW,
                height: size,
                alignment: Alignment.center,
                radius: BorderRadius.circular(30.r),
                placeHolder: ImageConstant.imgPerson,
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
