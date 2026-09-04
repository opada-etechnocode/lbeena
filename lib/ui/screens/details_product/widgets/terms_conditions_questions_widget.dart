import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/components.dart';
import '../../../theme/app_decoration.dart';
import '../../../widget/url_webview.dart';

class TermsConditionsQuestionsWidget extends StatelessWidget {
  const TermsConditionsQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: isIpad(context) ? 160.h : 100.h,
      decoration: AppDecoration.outlineWhiteB,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                navigatorToPush(
                    context: context,
                    pageName: UrlWebViewPage(
                      urlPage: DIManager.findDep<SharedPrefs>().getSafetyLink(),
                      titleAppBer: 'نصائح السلامة',
                    ));
              },
              child: Row(
                children: [
                  iconSvg(iconSvg: ImageConstant.iconAdvice),
                  sizeWidthNormal(),
                  textNormal(text: 'نصائح السلامة'),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                navigatorToPush(
                    context: context,
                    pageName: UrlWebViewPage(
                      urlPage: DIManager.findDep<SharedPrefs>().getTermsLink(),
                      titleAppBer: 'الأحكام والشروط',
                    ));
              },
              child: Row(
                children: [
                  iconSvg(iconSvg: ImageConstant.iconCondition),
                  sizeWidthNormal(),
                  textNormal(text: 'الأحكام والشروط'),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                navigatorToPush(
                    context: context,
                    pageName: UrlWebViewPage(
                      urlPage: DIManager.findDep<SharedPrefs>().getFaqLink(),
                      titleAppBer: 'أسئلة مكررة',
                    ));
              },
              child: Row(
                children: [
                  iconSvg(iconSvg: ImageConstant.iconQuestion),
                  sizeWidthNormal(),
                  textNormal(text: 'أسئلة مكررة'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
