import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/top_curved_circular_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/shared_prefs/shared_prefs.dart';
import '../ui/theme/app_decoration.dart';

class TopCurvedCirculartItem extends StatelessWidget {
  final String title;
  final double height;
  final bool isShowBack;
   bool isHaveIcons = false;
   bool isHaveOneIcons = false;
   void Function()? onPressed;
   void Function()? onPressed2;
   String?imagePath;
   TopCurvedCirculartItem({
    super.key,
    required this.title,
    this.isShowBack = true,
    this.isHaveIcons = false,
    this.isHaveOneIcons = false,
    this.onPressed,
    this.onPressed2,
    this.imagePath,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      // color: Colors.transparent,
      height: height.h,
      decoration: AppDecoration.appBar,

      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            size: Size(double.infinity, height.h),
            painter: TopCurvedCircularPainter(
                bgColor: DIManager.findDep<SharedPrefs>().getThemeApp() ==
                    'd'
                    ? appTheme.lightBlueBottomNavigatorBar
                    : appTheme.lightBlue100),
          ),
          isHaveIcons?
              Positioned(
                left: 10,
                bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap:onPressed2,child: CustomImageView(
                  height: 50.h,
                  width: 50.h,
                  imagePath: imagePath,
                )),
                IconButton(onPressed:onPressed,icon: Icon(Icons.search,size: 35,color: appTheme.black900,),),
              ],
            ),
          ):Container(),

          isHaveOneIcons?
          Positioned(
            left: 25,
            bottom: 50,
            child: InkWell(
                onTap:onPressed2,child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: AppDecoration.background,
                  width: 28.w,
                  height: 28.w,
                ),
                CustomImageView(
                  imagePath: imagePath,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.contain,color: Colors.white,
                  // color: appTheme.white,
                ),
              ],
            ),),
          ):Container(),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 60.w),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          if (isShowBack)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: lang =='ar'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Icon(Icons.arrow_back_ios_new)
                ),
              ),
            ),
        ],
      ),
    );
  }
}
