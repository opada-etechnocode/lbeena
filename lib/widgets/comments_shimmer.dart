import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_text_form_field.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/app_font.dart';
import '../core/di/di_manager.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../ui/theme/theme_helper.dart';
import 'custom_image_view.dart';
class CommentsShimmer extends StatefulWidget {
  CommentsShimmer({super.key});

  @override
  State<CommentsShimmer> createState() => _CommentsShimmerState();
}

class _CommentsShimmerState extends State<CommentsShimmer> {

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () =>FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              color: appTheme.scaffoldBackgroundColor100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Container(
                    height: 200.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd' ?appTheme.lightBlue100 :Colors.grey.shade400,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: appTheme.baseColorShimmer,
                                    highlightColor: appTheme.highlightColorShimmer,

                                    child: Container(
                                      width: 25.w,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                        color: appTheme.black900.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ),
                                  sizeWidthNormal(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        // baseColor: appTheme.cyan400,
                                        // highlightColor: appTheme.blue600,
                                        baseColor: appTheme.baseColorShimmer,
                                        highlightColor: appTheme.highlightColorShimmer,

                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100.w,
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                // color: appTheme.black900
                                                //     .withOpacity(0.2),
                                                borderRadius:
                                                BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            sizeWidthNormal(),
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
                                                width: 75.w,
                                                height: 4.h,
                                                decoration: BoxDecoration(
                                                  color: appTheme.black900
                                                      ,
                                                  borderRadius:
                                                  BorderRadius.circular(10.r),
                                                ),
                                              ),
                                              sizeHeightNormal(),

                                              Container(
                                                width: 150.w,
                                                height: 4.h,
                                                decoration: BoxDecoration(
                                                  color: appTheme.black900,
                                                  borderRadius:
                                                  BorderRadius.circular(10.r),
                                                ),
                                              ),

                                              sizeHeightNormal(),
                                              Container(
                                                width: 200.w,
                                                height: 4.h,
                                                decoration: BoxDecoration(
                                                  color: appTheme.black900,
                                                  borderRadius:
                                                  BorderRadius.circular(10.r),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Shimmer.fromColors(
                                    // baseColor: appTheme.cyan400,
                                    // highlightColor: appTheme.blue600,
                                    baseColor: appTheme.baseColorShimmer,
                                    highlightColor: appTheme.highlightColorShimmer,

                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.grey,
                                          size: 15.sp,
                                        ),
                                        sizeHeightNormal(height: 4.h),
                                        textNormal(
                                          text: ' ',
                                          fontSize: AppFontSize.fontSize_8,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

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
