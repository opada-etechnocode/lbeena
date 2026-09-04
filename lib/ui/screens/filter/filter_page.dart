import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/screens/cuopon/coupon_ads_screen.dart';
import 'package:syrians_in_uae/ui/screens/filter/widgets/filter_item_widget.dart';
import 'package:syrians_in_uae/widgets/components.dart';

import '../../../data/models/add_ad_new/category_model.dart';
import '../community/search_post_screen.dart';
import '../company/companies_page.dart';
import '../search/search.dart';

class FilterPage extends StatelessWidget {
   FilterPage({super.key,required this.categoriesMainModel});

  CategoriesAddPostModel? categoriesMainModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNormalWithIcon(
          text: 'بحث شامل', context: context, isShowBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          sizeHeightNormal(),
          Padding(
            padding:  EdgeInsets.only(right: 30.w,bottom: 10.h,top: 10.h),
            child: textNormal(text: 'أين تريد أن تبحث 🔍'),
          ),
          sizeHeightNormal(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterItemWidget(
                onTap: () {
                  navigatorToPush(context: context, pageName:  SearchPage(categoriesMainModel: categoriesMainModel,));
                },
                icon: ImageConstant.adIcon,
                title: 'إعلانات',
              ),
              sizeWidthNormal(),
              FilterItemWidget(
                onTap: () {
                  navigatorToPush(context: context, pageName:  SearchPostScreen());
                },
                icon: ImageConstant.relationsIcon,
                title: 'سوشال',
              ),
            ],
          ),
          sizeHeightNormal(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterItemWidget(
                onTap: () {
                  navigatorToPush(context: context, pageName:  CouponAdsScreen());

                },
                icon: ImageConstant.couponIcon,
                title: 'عروض وخصوم',
              ),
              sizeWidthNormal(),
              FilterItemWidget(
                onTap: () {
                  navigatorToPush(context: context, pageName:  CompaniesPage(isNeedBack: true,));

                },
                icon: ImageConstant.enterpriseIcon,
                title: 'الدليل',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
