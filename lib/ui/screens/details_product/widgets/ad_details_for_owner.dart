import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';

class AdDetailsForOwnerWidget extends StatelessWidget {
  AdDetailsForOwnerWidget({super.key,
  required this.dataDetailsProduct,
    required this.isHaveAds,
    required this.clicks,
    required this.showAds,

  });

  final String? isHaveAds;
  final int clicks;
  final int showAds;
  final dynamic dataDetailsProduct;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 160.w,
              height: 60.h,
              decoration: AppDecoration.outlineWhiteB.copyWith(
                color: dataDetailsProduct.status == '0'
                    ? Colors.yellow
                    : dataDetailsProduct.status == '1'
                    ? Colors.green
                    : appTheme.activeButtonNavigatorBarIcon,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeHeightNormal(),
                    textNormal(
                        text: 'حالة الإعلان:', fontWeight: FontWeight.w100),
                    // data.status.toString() == '1'
                    //     ? textNormal(text: 'فعال')
                    //     : textNormal(text: 'غير فعال'),
                    textNormal(
                      color: dataDetailsProduct.status == '0'
                          ? Colors.black
                          : Colors.white,
                      text: dataDetailsProduct.status == '0'
                          ? 'قيد الانتظار'
                          : dataDetailsProduct.status == '1'
                          ? 'الإعلان فعال'
                          : dataDetailsProduct.status == '2'
                          ? 'مرفوض'
                          : "منتهي الصلاحية",
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              width: 160.w,
              height: 60.h,
              decoration: AppDecoration.outlineWhiteB,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Column(
                  crossAxisAlignment: dataDetailsProduct.status == '3' ||
                      dataDetailsProduct.status == '0'
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: dataDetailsProduct.status == '3' ||
                      dataDetailsProduct.status == '0'
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (dataDetailsProduct.status == '3') ...{
                      textNormal(
                          text: "منتهي الصلاحية",
                          fontSize: AppFontSize.fontSize_15,
                          color: appTheme.activeButtonNavigatorBarIcon,),
                    } else if (dataDetailsProduct.status == '0') ...{
                      textNormal(
                          text: "قيد الانتظار",
                          fontSize: AppFontSize.fontSize_15,
                          color: appTheme.activeButtonNavigatorBarIcon,),
                    } else ...{
                      sizeHeightNormal(),
                      textNormal(
                          text: 'ينتهي إعلانك بعد:',
                          fontWeight: FontWeight.w100),
                      textNormal(
                          text: dataDetailsProduct!.acceptDate != null
                              ? getComparedTimeTow(
                              dataDetailsProduct!.finishedAt ?? DateTime.now(),
                              // data!.createdAd.toString(),
                              dataDetailsProduct!.acceptDate.toString())
                              .toString()
                              : "",
                          fontSize: AppFontSize.fontSize_16,
                          color: appTheme.activeButtonNavigatorBarIcon,),
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
        sizeHeightNormal(),
        Row(
          children: [
            Container(
              width: 160.w,
              height: 60.h,
              decoration: AppDecoration.outlineWhiteB,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeHeightNormal(),
                    textNormal(text: 'المشاهدات', fontWeight: FontWeight.w100),
                    clicks == 0
                        ? textNormal(
                        text:
                        '${int.parse(dataDetailsProduct.clicks ?? '0') + showAds}' ??
                            '')
                        : textNormal(text: '$clicks' ?? ''),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              width: 160.w,
              height: 60.h,
              decoration: AppDecoration.outlineWhiteB.copyWith(
                  color: isHaveAds == '0'
                      ? appTheme.whiteA700
                      : appTheme.greenColor),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeHeightNormal(),
                    textNormal(
                        text: 'حالة الإعلان:', fontWeight: FontWeight.w100),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        isHaveAds == '1'
                            ? iconSvg(
                          iconSvg: ImageConstant.iconTrue,
                        )
                            : Container(),
                        isHaveAds == '1'
                            ? textNormal(
                          text: 'الإعلان مميز',
                        )
                            : textNormal(
                          text: 'الإعلان غير مميز',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
