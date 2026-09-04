import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/comments_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_text_form_field.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../core/di/di_manager.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../core/utils/image_constant.dart';
import '../ui/theme/app_decoration.dart';
import '../ui/theme/theme_helper.dart';
import 'custom_image_view.dart';

class CommunityShimmer extends StatefulWidget {
  CommunityShimmer({super.key,reload, this.isFromPostPage = false}) ;
  bool isFromPostPage= false;

  @override
  State<CommunityShimmer> createState() => _CommunityShimmerState();
}

class _CommunityShimmerState extends State<CommunityShimmer> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              // decoration: AppDecoration.fillWhiteA,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // const SizedBox(height: 20),
                  if(widget.isFromPostPage)...{
                    Container(
                      // height: 48.h,
                      width: MediaQuery.of(context).size.width,
                      // decoration: AppDecoration.outlineBlueGray,
                      decoration: BoxDecoration(
                        boxShadow: [
                          // BoxShadow(
                          //     color: Colors.grey,
                          //     spreadRadius: 2.h,
                          //     blurRadius: 6.h,
                          //     offset: Offset(
                          //       -3,
                          //       -3,
                          //     )
                          // ),
                        ],
                        // color: AppColorsController().defaultPrimaryColor,
                        color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd' ?appTheme.lightBlue100 :Colors.grey.withOpacity(0.2),

                      ),
                      // color: Colors.grey.withOpacity(0.2),
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: appTheme.baseColorShimmer,
                              highlightColor:
                              appTheme.highlightColorShimmer,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 30.r,
                                  ),
                                  SizedBox(
                                    width: 5.sp,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100.w,
                                        height: 5.h,
                                        decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                      ),
                                      sizeHeightNormal(),
                                      Container(
                                        width: 40.w,
                                        height: 4.h,
                                        decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: appTheme.baseColorShimmer,
                              highlightColor:
                              appTheme.highlightColorShimmer,
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 5.h),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.4,
                                      height: 4.h,
                                      decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                    ),
                                    sizeHeightNormal(),

                                    Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.6,
                                      height: 4.h,
                                      decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                    ),

                                    sizeHeightNormal(),
                                    Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: 4.h,
                                      decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: appTheme.baseColorShimmer,
                              highlightColor:
                              appTheme.highlightColorShimmer,
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 5.h),
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width,
                                  height: 214.h,
                                  decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                ),
                              ),
                            ),
                            Container(
                              width: 270.w,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor:
                                        appTheme.baseColorShimmer,
                                        highlightColor: appTheme
                                            .highlightColorShimmer,
                                        child: CustomImageView(
                                          imagePath:
                                          ImageConstant.likeIcon,
                                          color:
                                          appTheme.deepPurpleA100,
                                          height: 30.sp,
                                          width: 30.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor:
                                        appTheme.baseColorShimmer,
                                        highlightColor: appTheme
                                            .highlightColorShimmer,
                                        child: Container(
                                          width: 50.w,
                                          height: 4.h,
                                          decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),

                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor:
                                          appTheme.baseColorShimmer,
                                          highlightColor: appTheme
                                              .highlightColorShimmer,
                                          child: Icon(Icons.chat)),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor:
                                        appTheme.baseColorShimmer,
                                        highlightColor: appTheme
                                            .highlightColorShimmer,
                                        child: Container(
                                          width: 50.w,
                                          height: 4.h,
                                          decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CommentsShimmer(),
                  }else...{
                    Container(
                      // height: 100000.h,
                      // flex: 3,

                      child: ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              // height: 48.h,
                              width: MediaQuery.of(context).size.width,
                              // decoration: AppDecoration.outlineBlueGray,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  // BoxShadow(
                                  //     color: Colors.grey,
                                  //     spreadRadius: 2.h,
                                  //     blurRadius: 6.h,
                                  //     offset: Offset(
                                  //       -3,
                                  //       -3,
                                  //     )
                                  // ),
                                ],
                                // color: AppColorsController().defaultPrimaryColor,
                                color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd' ?appTheme.lightBlue100 :Colors.grey.withOpacity(0.2),

                              ),
                              // color: Colors.grey.withOpacity(0.2),
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              child: Padding(
                                padding: EdgeInsets.all(10.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: appTheme.baseColorShimmer,
                                      highlightColor:
                                      appTheme.highlightColorShimmer,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 30.r,
                                          ),
                                          SizedBox(
                                            width: 5.sp,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100.w,
                                                height: 5.h,
                                                decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                              ),
                                              sizeHeightNormal(),
                                              Container(
                                                width: 40.w,
                                                height: 4.h,
                                                decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: appTheme.baseColorShimmer,
                                      highlightColor:
                                      appTheme.highlightColorShimmer,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.4,
                                              height: 4.h,
                                              decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                            ),
                                            sizeHeightNormal(),

                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.6,
                                              height: 4.h,
                                              decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                            ),

                                            sizeHeightNormal(),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 4.h,
                                              decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: appTheme.baseColorShimmer,
                                      highlightColor:
                                      appTheme.highlightColorShimmer,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          height: 214.h,
                                          decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 270.w,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor:
                                                appTheme.baseColorShimmer,
                                                highlightColor: appTheme
                                                    .highlightColorShimmer,
                                                child: CustomImageView(
                                                  imagePath:
                                                  ImageConstant.likeIcon,
                                                  color:
                                                  appTheme.deepPurpleA100,
                                                  height: 30.sp,
                                                  width: 30.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Shimmer.fromColors(
                                                baseColor:
                                                appTheme.baseColorShimmer,
                                                highlightColor: appTheme
                                                    .highlightColorShimmer,
                                                child: Container(
                                                  width: 50.w,
                                                  height: 4.h,
                                                  decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),

                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Shimmer.fromColors(
                                                  baseColor:
                                                  appTheme.baseColorShimmer,
                                                  highlightColor: appTheme
                                                      .highlightColorShimmer,
                                                  child: Icon(Icons.chat)),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Shimmer.fromColors(
                                                baseColor:
                                                appTheme.baseColorShimmer,
                                                highlightColor: appTheme
                                                    .highlightColorShimmer,
                                                child: Container(
                                                  width: 50.w,
                                                  height: 4.h,
                                                  decoration: AppDecoration.outlineButtonLite.copyWith(boxShadow: []),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getItem(context, onClick, label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor,
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        onTap: onClick,
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(
          Icons.navigate_next_rounded,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}
