import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';

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
            EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: LbeenaColors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 8.w),
                textNormal(
                  text: 'إحصاءات',
                  color: LbeenaColors.teal,
                  fontWeight: FontWeight.w800,
                ),
              ],
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: LbeenaColors.card,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statItem(
                      child: iconSvg(iconSvg: ImageConstant.iconEyes),
                      value: clicks == 0
                          ? '${int.parse(dataProduct.clicks ?? '0') + showAds}'
                          : '$clicks',
                    ),
                    sizeWidthNormal(width: 10.w),
                    Container(
                      height: 36.h,
                      width: 1,
                      color: LbeenaColors.fieldBorder,
                    ),
                    sizeWidthNormal(width: 10.w),
                    _statItem(
                      child: Icon(
                        Icons.favorite_border,
                        color: LbeenaColors.orange,
                        size: 22.sp,
                      ),
                      value: counterFavorite == null
                          ? dataProduct.favoritesCount.toString()
                          : counterFavorite.toString(),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    height: 1,
                    width: 200.w,
                    color: LbeenaColors.fieldBorder,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statItem(
                      child: iconSvg(iconSvg: ImageConstant.imgShare),
                      value: clicksShare ?? '0',
                    ),
                    sizeWidthNormal(width: 22.w),
                    _statItem(
                      child: CustomImageView(
                        imagePath: ImageConstant.imgChats,
                        height: 22.h,
                        width: 22.h,
                        color: LbeenaColors.teal,
                      ),
                      value: clicksChat ?? '0',
                    ),
                    sizeWidthNormal(width: 22.w),
                    _statItem(
                      child: CustomImageView(
                        imagePath: ImageConstant.iconWhatsapp,
                        height: 22.h,
                        color: LbeenaColors.orange,
                        width: 22.h,
                      ),
                      value: clicksWhatsapp?.toString() ?? '0',
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

  Widget _statItem({required Widget child, required String value}) {
    return Row(
      children: [
        child,
        SizedBox(width: 8.w),
        textNormal(
          text: value,
          color: LbeenaColors.black,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
