import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'dart:ui' as ui;
import 'package:syrians_in_uae/ui/screens/reminders/cubit/reminder_state.dart';
import 'package:syrians_in_uae/ui/screens/reminders/widget/build_package_Item.dart';
import 'package:syrians_in_uae/ui/screens/reminders/widget/timer_widget.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../data/models/add_ads/add_ads_model.dart';
import '../../../data/models/reminders/reminders_model.dart';
import '../../../widgets/components.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import 'add_reminder_page.dart';
import 'cubit/reminder_cubit.dart';

class ArchiveRemindersPage extends StatefulWidget {
  ArchiveRemindersPage({super.key,});

  @override
  State<ArchiveRemindersPage> createState() => _ArchiveRemindersPageState();
}

class _ArchiveRemindersPageState extends State<ArchiveRemindersPage> {

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
@override
  void initState() {
    ReminderCubit.get(context).archiveRemindersList.clear();
      ReminderCubit.get(context).getReminder(page: 1,
        status: 'finished');

    super.initState();
  }
  int page =1;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderCubit, ReminderState>(
      listener: (context, state) {
        // if (state is DeleteRemindersSuccessState) {
        //   SnackBarHelper.mySnackBarSuccess(
        //       state.remindersModel.message, context,
        //       behavior: SnackBarBehavior.floating);
        // }
        //
        // if (state is DeleteRemindersErrorState) {
        //   SnackBarHelper.mySnackBarError(state.error, context,
        //       behavior: SnackBarBehavior.floating);
        // }
      },
      builder: (context, state) {
        return HandelAndroidApp(
          child: Scaffold(
            appBar: appBarNormalWithIcon(text:  'الأرشيف', context: context,isShowBack: true),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerDocked,
            // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            body: SmartRefreshWidget(
              onRefresh: () async {
                page =1;
                ReminderCubit.get(context).archiveRemindersList.clear();
                ReminderCubit.get(context).getReminder(page: 1,
                    status: 'finished');
                setState(() {
                });
                _refreshController.refreshCompleted();
              },
              onLoading: () async {
                setState(() {
                  page ++;

                  ReminderCubit.get(context).getReminder(page:page,
                      status: 'finished',isNotNeedLoading: false);
                });
                _refreshController.loadComplete();
              },
              controller: _refreshController,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.h),
                  child: Column(
                    children: [

                      // state is LoadingPackageCompanyState
                      //     ? ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: 5,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding:  EdgeInsets.symmetric(
                      //             vertical: 8.h
                      //         ),
                      //         child: BannerItemShimmer(),
                      //       );
                      //     })
                      //     :

                        state is GetRemindersLoadingState?Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            sizeHeightNormal(
                              height: 250.h
                            ),
                            LoadingAnimationWidget.beat(
                              color: appTheme.cyan400,
                              size: 100,
                            ),
                          ],
                        ):
                        ReminderCubit.get(context).archiveRemindersList.length == 0
                            ? Column(
                          children: [
                            sizeHeightNormal(height: 160.h),
                            Container(
                              child: CustomImageView(
                                imagePath: ImageConstant.bellIcon,
                                width: 150.w,
                                height: 160.w,
                              ),
                            ),
                            textNormal(
                                text: 'لايوجد تذكيرات مؤرشفة بعد..',
                                fontWeight: FontWeight.w100)
                          ],
                        )
                            :  ListView.builder(
                          shrinkWrap: true,
                          itemCount:ReminderCubit.get(context).archiveRemindersList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BuildPackageItem(
                              data:       ReminderCubit.get(context)
                                  .archiveRemindersList[index],
                              index:index ,
                              isArchiveReminder: true,
                            );
                          }),


                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  //
  // void deleteReminder(
  //     BuildContext context, {
  //       required int idReminder,
  //       required int index,
  //
  //     }) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context2) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context1, StateSetter setState) {
  //             return AlertDialog(
  //               backgroundColor: appTheme.buttonColor,
  //               title: Text(
  //                 'هل أنت متأكد من حذف التذكير ؟',
  //                 style: themeLite.textTheme.titleSmall,
  //               ),
  //               content: Container(
  //                 height: 80.h,
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     InkWell(
  //                       onTap: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Center(
  //                           child: Container(
  //                             width: 100.h,
  //                             height: 40.h,
  //                             decoration: AppDecoration.outlineSelectedLite
  //                                 .copyWith(borderRadius: BorderRadius.circular(30.h)),
  //                             child: Center(
  //                               child: textNormal(text: 'إلغاء'),
  //                             ),
  //                           )),
  //                     ),
  //                     sizeWidthNormal(),
  //                     InkWell(
  //                       onTap: () {
  //                         Navigator.of(context).pop();
  //                         ReminderCubit.get(context)
  //                             .deleteReminder(idReminder: idReminder, index: index,isArchiveReminder: true);
  //                       },
  //                       child: Center(
  //                           child: Container(
  //                             width: 100.h,
  //                             height: 40.h,
  //                             decoration: AppDecoration.outlineSelectedLite
  //                                 .copyWith(borderRadius: BorderRadius.circular(30.h)),
  //                             child: Center(
  //                               child: textNormal(text: 'حذف'),
  //                             ),
  //                           )),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           });
  //     },
  //   );
  // }
  /// Section Widget
  //   Widget _buildPackageItem(BuildContext context,RemindersListModel data,int index) {
  //   DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data.reminderDate! );
  //   String dayName = DateFormat.EEEE('ar').format(parsedDate);
  //   String formattedTime = DateFormat("a h:mm").format(parsedDate);
  //   String formattedDate = DateFormat("yyyy MMMM dd", 'ar').format(parsedDate);
  //   formattedDate = formattedDate.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
  //     // تحويل الرقم العربي إلى رقمه الإنجليزي
  //     return match.group(0)!.replaceAllMapped(RegExp(r'[٠١٢٣٤٥٦٧٨٩]'), (m) {
  //       switch (m.group(0)) {
  //         case '٠': return '0';
  //         case '١': return '1';
  //         case '٢': return '2';
  //         case '٣': return '3';
  //         case '٤': return '4';
  //         case '٥': return '5';
  //         case '٦': return '6';
  //         case '٧': return '7';
  //         case '٨': return '8';
  //         case '٩': return '9';
  //         default: return '';
  //       }
  //     });
  //   });
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: Container(
  //       // width: 361.h,
  //       height: 140.h,
  //       decoration: AppDecoration.gradientPackage.copyWith(
  //         // color: Color(int.parse(colorPackage)),
  //           color: appTheme.lightBlue100,
  //           // border: Border.all(color: Color(int.parse(colorPackage))),
  //           gradient: LinearGradient(
  //             begin: Alignment(0.90, 0.77),
  //             end: Alignment(0.18, 0.83),
  //             colors: [
  //               appTheme.whiteA700,
  //               appTheme.lightBlue100,
  //               // appTheme.colorAppBar,
  //             ],
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: appTheme.black900.withOpacity(0.9),
  //               spreadRadius: 0.2,
  //               // blurRadius: 3,
  //               offset: Offset(
  //                 0,
  //                 0,
  //               ),
  //             ),
  //           ],
  //           borderRadius: BorderRadius.circular(10.r)),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           sizeWidthNormal(),
  //           Column(
  //             children: [
  //               sizeHeightNormal(),
  //               CustomImageView(
  //                 imagePath: data.remind_others ==1 ? ImageConstant.iconWhatsapp: ImageConstant.imgPerson,
  //                 width:data.remind_others ==1 ? 18.w:  15.w,
  //                 height:data.remind_others ==1 ? 18.w: 15.w,
  //                 color: appTheme.deepPurpleA10001,
  //                 fit: BoxFit.fill,
  //               ),
  //             ],
  //           ), sizeWidthNormal(width: 4.w),
  //           Container(
  //             width: 255.w,
  //             child: Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       textNormal(
  //                           text: dayName,
  //                           color: appTheme.black900,
  //                           fontSize: AppFontSize.fontSize_16,
  //                           fontWeight: FontWeight.w200
  //                       ),
  //                       sizeWidthNormal(),
  //                       textNormal(
  //                           text:formattedTime,
  //                           color: appTheme.gray,
  //                           fontSize: AppFontSize.fontSize_12,
  //                           fontWeight: FontWeight.w200
  //                       ),
  //                       if(data.remind_others ==1)...{
  //                         sizeWidthNormal(),
  //                         Directionality(
  //                           textDirection: ui.TextDirection.ltr,
  //                           child:    textNormal(
  //                               text: data.phone_number.toString(),
  //                               color: appTheme.gray,
  //                               fontSize: AppFontSize.fontSize_15,
  //                               fontWeight: FontWeight.w200),)
  //
  //                       }
  //
  //                     ],
  //                   ),
  //                   textNormal(
  //                     text: formattedDate,
  //                     color: appTheme.black900,
  //                     fontSize: AppFontSize.fontSize_18,
  //                   ),
  //                   sizeHeightNormal(height: 5.h),
  //                   TimerReminderWidget(
  //                      reminderDate: data.reminderDate!,
  //                   ),
  //                   sizeHeightNormal(height: 5.h),
  //                   Container(
  //                     width: 300.w,
  //                     child: textNormal(
  //                         text:data.description.toString(),
  //                         color: appTheme.gray,
  //                         fontSize: AppFontSize.fontSize_11,
  //                         fontWeight: FontWeight.w800,
  //                         maxLines: 2
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //
  //
  //           Padding(
  //             padding: EdgeInsets.only(top: 10.h,),
  //             child: Row(
  //               children: [
  //                 //
  //                 // Container(
  //                 //   decoration: AppDecoration.background,
  //                 //   width: 24.w,
  //                 //   height: 24.w,
  //                 //   child: CustomImageView(
  //                 //     imagePath: ImageConstant.editIcon,
  //                 //     width: 15.w,
  //                 //     height: 15.w,
  //                 //     fit: BoxFit.scaleDown,
  //                 //   ),
  //                 // ),
  //                 InkWell(
  //                   onTap: (){
  //                     navigatorToPush(
  //                         context: context,
  //                         pageName: AddRemindersPage(
  //                           data: data,
  //                           isEdit: true,
  //                             isEditArchive:true
  //                         ));
  //                   },
  //                   child: Stack(
  //                     alignment: Alignment.center,
  //                     children: [
  //                       Container(
  //                         decoration: AppDecoration.background,
  //                         width: 28.w,
  //                         height: 28.w,
  //                       ),
  //                       CustomImageView(
  //                         imagePath: ImageConstant.editIcon,
  //                         width: 20.w,
  //                         height: 20.w,color: Colors.white,
  //                         fit: BoxFit.contain,
  //                         // color: appTheme.white,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 sizeWidthNormal(),
  //
  //                 InkWell(
  //                   onTap: (){
  //
  //                     deleteReminder(context, idReminder: data.id!, index: index);
  //                   },
  //                   child: Stack(
  //                     alignment: Alignment.center,
  //                     children: [
  //                       Container(
  //                         decoration: AppDecoration.background,
  //                         width: 28.w,
  //                         height: 28.w,
  //                       ),
  //                       CustomImageView(
  //                         imagePath: ImageConstant.deleteIcon,
  //                         width: 20.w,
  //                         height: 20.w,
  //                         fit: BoxFit.contain,color: Colors.white,
  //                         // color: appTheme.white,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

}

