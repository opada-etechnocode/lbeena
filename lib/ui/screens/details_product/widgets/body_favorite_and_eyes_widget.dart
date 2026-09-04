import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';

class BodyFavoriteAndEyesWidget extends StatelessWidget {
   BodyFavoriteAndEyesWidget({super.key,required this.dataProduct, required this.showAds, this.counterFavorite, this.clicksShare, this.clicksChat, this.clicksWhatsapp});
int clicks = 0;
final int showAds;
final dynamic dataProduct;
final int? counterFavorite;
final String? clicksShare;
final String? clicksChat;
final String? clicksWhatsapp;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: textNormal(text: 'إحصاءات:')),
        Container(
          // height: 88.h,
          width: MediaQuery.of(context).size.width,
          // height: isIpad(context) ?  160.h:100.h,
          decoration: AppDecoration.outlineWhiteB,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        iconSvg(iconSvg: ImageConstant.iconEyes),
                        SizedBox(
                          width: 8.w,
                        ),
                        clicks == 0
                            ? textNormal(
                            text:
                            '${int.parse(dataProduct.clicks ?? '0') + showAds}' ??
                                '')
                            : textNormal(text: '$clicks' ?? ''),
                      ],
                    ),
                    sizeWidthNormal(width: 10.w),
                    Container(
                      height: 50.h,
                      width: 4.w,
                      color: appTheme.deepPurpleA10001.withOpacity(.3),
                    ),
                    sizeWidthNormal(width: 10.w),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color:  appTheme.deepPurpleA100,
                          size: 25.sp,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        counterFavorite == null
                            ? textNormal(
                            text: dataProduct.favoritesCount
                                .toString() ??
                                '0')
                            : textNormal(
                            text: counterFavorite.toString() ?? ''),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    height: 4.h,
                    width: 200.w,
                    color: appTheme.deepPurpleA10001.withOpacity(.3),
                  ),
                ),
                sizeHeightNormal(height: 15.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        iconSvg(iconSvg: ImageConstant.imgShare),
                        SizedBox(
                          width: 8.w,
                        ),
                        textNormal(text: clicksShare!)
                      ],
                    ),
                    sizeWidthNormal(width: 25.w),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgChats,
                          height: 24.h,
                          width: 24.h,
                          color: appTheme.deepPurpleA100,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        textNormal(
                          text: clicksChat!,
                        )
                      ],
                    ),
                    sizeWidthNormal(width: 25.w),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.iconWhatsapp,
                          height: 24.h,
                          color: appTheme.deepPurpleA100,
                          width: 24.h,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        textNormal(text: clicksWhatsapp.toString() ?? ''),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
