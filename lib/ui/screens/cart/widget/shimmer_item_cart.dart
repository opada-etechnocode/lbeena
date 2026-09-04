
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';

class ShimmerItemCart extends StatelessWidget {
   ShimmerItemCart({super.key,this.isOrderPage =false});
bool isOrderPage =false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      child: ListView.builder(
          shrinkWrap: true,
          physics: isOrderPage?NeverScrollableScrollPhysics():BouncingScrollPhysics(),
          itemCount: 5,

          itemBuilder: (context,index){

        return Padding(
          padding:  EdgeInsets.symmetric(vertical: 5.h),
          child: Container(
            decoration: AppDecoration.itemCart,
            child: Padding(
              padding:  EdgeInsets.all(12.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Shimmer.fromColors(

                    baseColor: appTheme.baseColorShimmer,
                    highlightColor: appTheme.highlightColorShimmer,

                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: AppDecoration.itemCart,
                    ),
                  ),

                  SizedBox(
                    width: 15.w,
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(

                          baseColor: appTheme.baseColorShimmer,
                          highlightColor: appTheme.highlightColorShimmer,

                          child: Container(
                              width: 50.w,
                          height: 2.h,
                            decoration: AppDecoration.itemCart,),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Shimmer.fromColors(

                          baseColor: appTheme.baseColorShimmer,
                          highlightColor: appTheme.highlightColorShimmer,

                          child: Container(
                            width: 100.w,
                            height: 2.h,
                            decoration: AppDecoration.itemCart,),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Shimmer.fromColors(

                          baseColor: appTheme.baseColorShimmer,
                          highlightColor: appTheme.highlightColorShimmer,

                          child: Container(
                            width: 150.w,
                            height: 2.h,
                            decoration: AppDecoration.itemCart,),
                        ),
                      ],
                    ),
                  ),
                  if(!isOrderPage)...{
                    Spacer(),
                    Shimmer.fromColors(

                      baseColor: appTheme.baseColorShimmer,
                      highlightColor: appTheme.highlightColorShimmer,

                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: IconButton(onPressed: (){
                        }, icon: Icon(Icons.delete_outline)),
                      ),
                    ),
                  }

                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
