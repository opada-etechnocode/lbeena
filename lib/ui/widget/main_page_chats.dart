import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/cubit.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_consts.dart';
import '../../core/constants/app_font.dart';
import '../../core/di/di_manager.dart';
import '../../core/shared_prefs/shared_prefs.dart';
import '../../data/models/chats/ads_chats_model.dart';
import '../screens/chats/cubit/states.dart';
import '../screens/details_product/details_product.dart';
import '../theme/app_decoration.dart';
import '../theme/theme_helper.dart';


class MainPageChat extends StatefulWidget {
  final AdsChatsModel? adsData;
  final String? index;
  final String? type;


  MainPageChat({Key? key, this.adsData,this.index,required this.type}) : super(key: key);

  @override
  State<MainPageChat> createState() => _MainPageChatState();
}

// final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

class _MainPageChatState extends State<MainPageChat> {
  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  String? userId = DIManager.findDep<SharedPrefs>().getUserID();

  @override
  Widget build(BuildContext context) {
    print('imagechat :${widget.adsData?.imageAds.toString()}');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
      child: Container(
        decoration: AppDecoration.card3d,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(40.r)),
                      child: (widget.adsData?.imageAds.toString() == 'null' ||widget.adsData?.imageAds.toString() == 'https://syriansinuae.comnull'
                          ||widget.adsData?.imageAds.toString() == 'https://syriansinuae.com'||widget.adsData?.imageAds.toString() == 'https://www.syriansinuae.com')
                          ? Container():CustomImageView(
                        imagePath: widget.adsData!.imageAds.toString(),
                        fit: BoxFit.fill,
                        height: 50.h,
                        width: 50.h,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w,
                          child: Text(

                            userId == widget.adsData!.user_id.toString()
                                ? widget.adsData!.nameOwnerAds.toString()
                                :     widget.adsData!.userNamePersonSender.toString(),
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: AppFontSize.fontSize_12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 200.w,
                          child: Text(
                            widget.adsData!.nameAds.toString(),
                                         maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if( widget.adsData!.type == 'image')...[
                          CustomImageView(
                            imagePath: widget.adsData!.massage,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.fill,
                          ),
                        ]else
                          if( widget.adsData!.type == 'record')...[
                            textNormal(text: 'تسجيل صوتي ..',fontSize: AppFontSize.fontSize_12,fontWeight: FontWeight.bold),
                          ]else...[
                          Container(
                            width: 150.sp,
                            child: Container(
                              height: 25.sp,
                              width: 20.sp,
                              child: Text(
                                widget.adsData!.massage?? '',
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: AppFontSize.fontSize_14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ]


                      ],
                    ),
                    Spacer(),
                    widget.adsData!.read == DIManager.findDep<SharedPrefs>()
                        .getUserID()
                        .toString()?Container(

                    ):Container(
                      height: 10.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        color: appTheme.red300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.adsData!.dateTime != null
                              ? getComparedTime(DateTime.parse(
                              widget.adsData!.dateTime.toString()))
                              .toString()
                              : "",
                        ),
                        BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
                          bloc: chatBlocFirebase,
                          listener: (context, state) {},

  builder: (context, state) {
    final isLoading = chatBlocFirebase.isLoading(widget.adsData!.ad_id!);

    if(isLoading){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(

            width:15.w,height:15.w,child: CircularProgressIndicator()),
      );
    }
    return IconButton(
                            onPressed: () {
                              chatBlocFirebase.deleteChat(
                                user_id: DIManager.findDep<SharedPrefs>().getUserID()!,
                                ad_id: widget.adsData!.ad_id!.toString(),
                                user_id_2: widget.adsData!.user_id_2.toString() ==
                                    DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString()
                                    ? widget.adsData!.user_id.toString()
                                    : widget.adsData!.user_id_2.toString(),
                                  type: widget.type!,
                                receiverId: widget.adsData!.user_id_2.toString(),
                              );
                            },
                            icon: Icon(Icons.delete,color: appTheme.black900,));
  },
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
    );
  }
}



