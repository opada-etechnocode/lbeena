import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';

import '../../../../data/models/community/hashtag_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../hashtag_screen.dart';

class HashtagWidget extends StatelessWidget {
   HashtagWidget({super.key,required this.hashtagList});
  List<Hashtag> hashtagList=[];
  @override
  Widget build(BuildContext context) {
    return   hashtagList.isEmpty?Container():   Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textNormal(text: 'أقسام المجتمع'),
        sizeHeightNormal(height: 5.h),
        Container(
          width: 350.w,
          height: 106.h,
          child: ListView.builder(
              itemCount:hashtagList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return Padding(
                  padding:  EdgeInsets.only(left: 4.w),
                  child: InkWell(
                    onTap: (){
                      navigatorToPush(
                          context: context,
                          pageName: HashtagScreen(
                            hashtagName: hashtagList[index]
                                .hashtag
                                .toString(),
                          ));
                    },
                    child: Container(
                      height: 90.h,
                      width: 88.h,
                      decoration: AppDecoration.itemCartNew,
                      child:  Column(
                        children: [
                          sizeHeightNormal(height: 8.h),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              hashtagList[index].isImage =='0'? CustomImageView(
                                imagePath: hashtagList[index].image,
                                height: 70.h,
                                width: 70.h,
                                fit: BoxFit.fill,
                                radius: BorderRadiusStyle.circleBorder7,
                              ):Container(
                                height: 70.h,
                                width: 70.h,
                                decoration: AppDecoration.itemCartNew.copyWith(
                                  color:  hashtagList[index].color!=null? Color(int.parse('0xff${colorWithoutHashtag(   hashtagList[index].color!)}')):appTheme.containerCart.withOpacity(.2),
                                ),

                              ),

                              Container(
                                  width: 70.h,
                                  decoration: AppDecoration.itemCartNew.copyWith(
                                    color: appTheme.containerCart.withOpacity(.9),

                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(7.r), bottomRight: Radius.circular(7.r)
                                    ),
                                  ),
                                  child: Center(child: textNormal(text:'${hashtagList[index].postCount}' ,fontSize: 9.fSize))),
                            ],
                          ),

                          sizeHeightNormal(height: 4.h),
                          Container(      width: 70.h,height: 15.h,
                              decoration: AppDecoration.itemCartNew.copyWith(
                                color: appTheme.containerCart.withOpacity(.6),

                              ),
                              child: Center(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 5.w),
                                  child: textNormal(text:hashtagList[index].hashtag ??'' ,fontSize: 9.fSize),
                                ),
                              )),
                        ],
                      ),
                      // color: Colors.red,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
