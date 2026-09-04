import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../ui/theme/theme_helper.dart';
import 'ads_product_shimmer.dart';


// ignore: must_be_immutable
class CompanyInformationShimmer extends StatelessWidget {
  const CompanyInformationShimmer({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.w),
            child: Shimmer.fromColors(
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child: Container(
                height: 230.h,
                // width: 350.w,

                // child: Image.asset(ImageConstant.imgBox2),
                padding: EdgeInsets.symmetric(vertical: 14.w),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  color: appTheme.scaffoldBackgroundColor100,
                  // shape: BoxShape.rectangle,
                  //                           image: DecorationImage(
                  //                             image: fs.Svg(
                  //                                ImageConstant.imgBox
                  //                             )
                  //                           ),

                  // gradient: LinearGradient(
                  //   begin: Alignment.centerLeft,
                  //   end: Alignment.centerRight,
                  //   // stops: [23,9,7,4],
                  //   colors: [
                  //     theme.colorScheme.secondaryContainer,
                  //     Colors.white,
                  //     Colors.white,
                  //     theme.colorScheme.secondaryContainer,
                  //   ],
                  // ),

                  // border: Border.all(color: theme.colorScheme.secondaryContainer,width: 10.h,),

                  // boxShadow: [
                  //   BoxShadow(
                  //     blurRadius: 2.h,
                  //     spreadRadius: 2.h,
                  //     color: appTheme.whiteA700
                  //   ),
                  // ]
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context)
                .size
                .width ,
            // height: 300.h,
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder40,
              color: appTheme.highlightColorShimmer.withOpacity(.6),boxShadow: []
              // image: DecorationImage(
              //   image: AssetImage(
              //     ImageConstant.imgFrame4,
              //   ),
              //   fit: BoxFit.cover,
              // ),
            ),

            child: Shimmer.fromColors(
              baseColor: appTheme.baseColorShimmer,
              highlightColor: appTheme.highlightColorShimmer,

              child:  Container(
                width: MediaQuery.of(context)
                    .size
                    .width ,
                height: 50.h,
                decoration: BoxDecoration(

                    // color: appTheme
                    //     .deepPurpleA10001,
                    boxShadow: [
                      BoxShadow(
                          color :Colors.grey,
                          spreadRadius: 2.h,
                          blurRadius: 2.h,
                          offset: Offset(
                            0,
                            0,
                          )),
                    ]),

              ),
            ),
          ),
          sizeHeightNormal(),
          AdsProductShimmer(isNotNeedName: true,),
        ],
      ),
    );
  }
}




class NotificationsInformationShimmer extends StatelessWidget {
  const NotificationsInformationShimmer({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: appTheme.baseColorShimmer,
      highlightColor: appTheme.highlightColorShimmer,

      child: ListView.builder(
          itemCount: 10,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder:(context,index){
            return Padding(
              padding:  EdgeInsets.all(4.r),
              child: Container(
                height: 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  color: appTheme.lightBlueBottomNavigatorBar,
                  border: Border.all(
                    color: appTheme.lightBlueBottomNavigatorBar,
                    width: 0.2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Container(
                          width: 280.w,
                          child: Padding(
                            padding:  EdgeInsets.symmetric(vertical: 4.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // textNormal(text: notificationsModel!.data[index].title.toString(),fontSize: AppFontSize.fontSize_16),
                                sizeHeightNormal(
                                    height: 5.h
                                ),
                                // textNormal(text: notificationsModel!.data[index].body.toString()),
                              ],
                            ),
                          )),
                      // Spacer(),
                      // notificationsModel!.data[index].read.toString() == '0'?  textNormal(text: '*',fontSize: 25.sp,color: Colors.red):Container(),
                    ],
                  ),
                ),
              ),
            );
          } ),
    );
  }
}