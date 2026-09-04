import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/events/effectiveness.dart';
import '../../../theme/theme_helper.dart';

class EffectivenessWidget extends StatelessWidget {
   EffectivenessWidget({super.key,required this.effectivenessData});
  Effectiveness effectivenessData;
  @override
  Widget build(BuildContext context) {
    String shortDescription = effectivenessData.shortDescription.toString().replaceAll('&nbsp;', '');
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150.h,
        decoration: BoxDecoration(
          color:      appTheme.lightBlue100,
          borderRadius: BorderRadius.circular(
            7.r,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              Container(
              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7.r),
                  bottomRight: Radius.circular(7.r),
                )
                // border: Border.all(color: appTheme.black900)
              ),
                height: 150.h,
              width: 100.w,
              child: effectivenessData.featuredImageOne ==null ?  Padding(
                padding:  EdgeInsets.all(4.r),
                child: CustomImageView(
                  imagePath:DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'?  ImageConstant.logoAppWhite: ImageConstant.logoApp,
                  height: 90.h,
                  width: 90.h,
                  radius: BorderRadius.only(
                    topRight: Radius.circular(7.r),
                    bottomRight: Radius.circular(7.r),
                  ),
                  fit: BoxFit.cover,

                ),
              ) :CustomImageView(
              imagePath: effectivenessData.featuredImageOne ,
              height: 120.h,
              width: 100.w,
              radius: BorderRadius.only(
                topRight: Radius.circular(7.r),
                bottomRight: Radius.circular(7.r),
              ),
              fit: BoxFit.cover,

                            ),
            ),
            sizeWidthNormal(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sizeHeightNormal(height: 5.h),
                Container(width: 240.w,
                  child: Row(
                    children: [
                      Container(width: 170.w,
                          child: textNormal(text: effectivenessData.title.toString(),)),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: textNormal(text: effectivenessData.date == null?'':  convertDateTime(dataTimeValue: effectivenessData.date.toString()),maxLines: 2,overflow: TextOverflow.ellipsis,fontSize: 10.fSize),
                      ),
                    ],
                  ),
                ),

                sizeHeightNormal(height: 5.h),
                Container(width: 240.w,
                    child: textNormal(text:
                    shortDescription,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 11.fSize
                    )),
                Spacer(),

               Container(width: 240.w,
                  child: Row(
                    children: [
Container(),
                      Spacer(),
                      effectivenessData?.link ==null?Container(): mapIcon(),

                      effectivenessData.number == null?Container():       InkWell(
                        onTap: (){
                          if(effectivenessData.number !=null){
                            final Uri url = Uri.parse(
                                'https://wa.me/+${effectivenessData.number}');
                            launchUrl(url,mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.iconWhatsapp,
                            height: 25.h,
                            width: 25.h,
                            color: appTheme.greenColorApp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

   Widget mapIcon() {
     return InkWell(
       onTap:() async {
         final url = effectivenessData!.link!;
         if (await canLaunchUrl(Uri.parse(url))) {
           await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
         }
       },
       child: Padding(
         padding:  EdgeInsets.symmetric(horizontal: 4.w),
         child: Icon( Icons.link,
           size: 25.fSize,
           color: appTheme.greenColorApp,
         ),
       ),
     );
   }
}
