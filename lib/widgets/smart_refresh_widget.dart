import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../core/constants/app_colors.dart';
import '../ui/theme/theme_helper.dart';

class SmartRefreshWidget extends StatelessWidget {
  SmartRefreshWidget(
      {super.key, required this.onRefresh, required this.controller, required this.child,required this.onLoading,this.enablePullUp});

  final void Function() onRefresh;
  final void Function() onLoading;
  final RefreshController controller;
  bool? enablePullUp;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        onRefresh: onRefresh,
        enablePullDown: true,
        enablePullUp: enablePullUp?? true,
        scrollDirection: Axis.vertical,
        controller: controller,
        onLoading:onLoading ,
        physics: BouncingScrollPhysics(),
footer:   ClassicFooter(


    idleText: '',
  canLoadingText: 'اسحب لمشاهدة المزيد ..',
    loadingText: 'جاري التحميل ..',
  noDataText: 'انتهى ',

    textStyle: TextStyle(color:  appTheme.greenColor,),
    ),
        header: ClassicHeader(
          refreshingIcon: Container(
              width: 20.h,
              height: 20.h,
              child: CircularProgressIndicator(
                color: appTheme.greenColor,
                strokeWidth: 1.5,
              )),
          idleIcon: Center(
            child: Icon(
              Icons.arrow_downward,
              color: appTheme.greenColor,
            ),
          ),
          completeIcon: Center(
            child: Icon(
              Icons.check,
              color: appTheme.greenColor,
              size: 30.h,
            ),
          ),
          releaseIcon: Center(
            child: Icon(
              Icons.change_circle_sharp,
              color: appTheme.greenColor,
              size: 30.h,
            ),
          ),
          completeText: "",
          idleText: '',
          refreshingText: "",
          canTwoLevelText: '',
          releaseText: '',
          textStyle: TextStyle(color:  appTheme.greenColor,),
        ),
        child: child);
  }
}