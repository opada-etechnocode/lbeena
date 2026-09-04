import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/home_page/categorie_part.dart';
import 'package:syrians_in_uae/data/models/home_page/categories_main.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/image_constant.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';
import 'custom_image_view.dart';

// ignore: must_be_immutable
class MainPartsWidget extends StatelessWidget {
   MainPartsWidget({Key? key,
     this.categoriesMainModel,
     this.index,
     this.isFromCategoryPartPage =false,
     this.socialMedia,
   this.decoration ,
   })
      : super(
          key: key,
        );
bool isFromCategoryPartPage;
SocialMedia? socialMedia;
   CategoriesMainModel? categoriesMainModel;
   int? index;
   Decoration? decoration;
  @override
  Widget build(BuildContext context) {
    String? icon = '${AppEndpoints.baseUrlWithoutApi}${ categoriesMainModel?.data[index!].icon! ?? ''}';

    return Container(
      width: 86.w,
      // height: 10.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70.h,
            width: 70.h,
            decoration: AppDecoration.outlineWhiteA,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 70.h,width: 70.h,
                decoration:decoration ?? AppDecoration.outlineCircular2,
                  // color: AppColorsController().defaultPrimaryColor,
                ),
                if(isFromCategoryPartPage)...[
                  CustomImageView(
                    imagePath:socialMedia!.image!.contains('http')?socialMedia!.image ??'': '${AppEndpoints.baseUrlWithoutApi}${ socialMedia!.image ?? ''}',
                    height: 47.h,
                    width: 47.h,
                    radius: BorderRadius.circular(40.r),
                    placeHolder: ImageConstant.imgLogoApp,
                    alignment: Alignment.center,
                  ),
                ]else...[
                  CustomImageView(
                    imagePath:categoriesMainModel!.data[index!].icon.toString().contains('http')?categoriesMainModel?.data[index!].icon:icon,
                    height: 47.h,
                    width: 47.h,
                    radius: BorderRadius.circular(40.r),
                    placeHolder: ImageConstant.imgLogoApp,
                    alignment: Alignment.center,
                  ),
                ],

              ],
            ),
          ),
          // SizedBox(height: 8.h),
          sizeHeightNormal(
            height: 8.h
          ),
          isFromCategoryPartPage? Container():  Container(
            width: 120.w,
            child: Center(
              child: Text(
                '${categoriesMainModel!.data[index!].title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                // textAlign: TextAlign.center,
                style: themeLite.textTheme.bodySmall!.copyWith(
                  height: 1.90,fontSize: AppFontSize.fontSize_10_2
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
