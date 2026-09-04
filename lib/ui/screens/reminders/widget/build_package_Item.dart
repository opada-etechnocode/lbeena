import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syrians_in_uae/ui/screens/reminders/widget/timer_widget.dart';
import 'dart:ui' as ui;
import '../../../../core/constants/app_font.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/reminders/reminders_model.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../add_reminder_page.dart';
import '../cubit/reminder_cubit.dart';

class BuildPackageItem extends StatelessWidget {
  RemindersListModel data;
  int index;
  bool isArchiveReminder;
   BuildPackageItem({super.key,required this.data, required this.index,
     required this.isArchiveReminder});

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data.reminderDate! );
    String dayName = DateFormat.EEEE('ar').format(parsedDate);
    String formattedTime = DateFormat("a h:mm").format(parsedDate);
    String formattedDate = DateFormat("yyyy MMMM dd", 'ar').format(parsedDate);
    formattedDate = formattedDate.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      // تحويل الرقم العربي إلى رقمه الإنجليزي
      return match.group(0)!.replaceAllMapped(RegExp(r'[٠١٢٣٤٥٦٧٨٩]'), (m) {
        switch (m.group(0)) {
          case '٠': return '0';
          case '١': return '1';
          case '٢': return '2';
          case '٣': return '3';
          case '٤': return '4';
          case '٥': return '5';
          case '٦': return '6';
          case '٧': return '7';
          case '٨': return '8';
          case '٩': return '9';
          default: return '';
        }
      });
    });
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        // width: 361.h,
        height: 140.h,
        decoration: AppDecoration.gradientPackage.copyWith(
          // color: Color(int.parse(colorPackage)),
            color: appTheme.lightBlue100,
            // border: Border.all(color: Color(int.parse(colorPackage))),
            gradient: LinearGradient(
              begin: Alignment(0.90, 0.77),
              end: Alignment(0.18, 0.83),
              colors: [
                appTheme.whiteA700,
                appTheme.lightBlue100,
                // appTheme.colorAppBar,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withOpacity(0.9),
                spreadRadius: 0.2,
                // blurRadius: 3,
                offset: Offset(
                  0,
                  0,
                ),
              ),
            ],
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeWidthNormal(),
            Column(
              children: [
                sizeHeightNormal(),
                CustomImageView(
                  imagePath: data.remind_others ==1 ? ImageConstant.iconWhatsapp: ImageConstant.imgPerson,
                  width:data.remind_others ==1 ? 18.w:  15.w,
                  height:data.remind_others ==1 ? 18.w: 15.w,
                  color: appTheme.deepPurpleA10001,
                  fit: BoxFit.fill,
                ),
              ],
            ), sizeWidthNormal(width: 4.w),
            Container(
              width: 255.w,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        textNormal(
                            text: dayName,
                            color: appTheme.black900,
                            fontSize: AppFontSize.fontSize_16,
                            fontWeight: FontWeight.w200
                        ),
                        sizeWidthNormal(),
                        textNormal(
                            text:formattedTime,
                            color: appTheme.gray,
                            fontSize: AppFontSize.fontSize_12,
                            fontWeight: FontWeight.w200
                        ),
                        if(data.remind_others ==1)...{
                          sizeWidthNormal(),
                          Directionality(
                            textDirection: ui.TextDirection.ltr,
                            child:    textNormal(
                                text: data.phone_number.toString(),
                                color: appTheme.gray,
                                fontSize: AppFontSize.fontSize_15,
                                fontWeight: FontWeight.w200),)

                        }

                      ],
                    ),
                    textNormal(
                      text: formattedDate,
                      color: appTheme.black900,
                      fontSize: AppFontSize.fontSize_18,
                    ),
                    sizeHeightNormal(height: 5.h),
                    TimerReminderWidget(
                      reminderDate: data.reminderDate!,
                    ),
                    sizeHeightNormal(height: 5.h),
                    Container(
                      width: 300.w,
                      child: textNormal(
                          text:data.description.toString(),
                          color: appTheme.gray,
                          fontSize: AppFontSize.fontSize_11,
                          fontWeight: FontWeight.w800,
                          maxLines: 2
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.only(top: 10.h,),
              child: Row(
                children: [
                  //
                  // Container(
                  //   decoration: AppDecoration.background,
                  //   width: 24.w,
                  //   height: 24.w,
                  //   child: CustomImageView(
                  //     imagePath: ImageConstant.editIcon,
                  //     width: 15.w,
                  //     height: 15.w,
                  //     fit: BoxFit.scaleDown,
                  //   ),
                  // ),
                  InkWell(
                    onTap: (){
                      navigatorToPush(
                          context: context,
                          pageName: AddRemindersPage(
                              data: data,
                              isEdit: true,
                              isEditArchive:isArchiveReminder
                          ));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: AppDecoration.background,
                          width: 28.w,
                          height: 28.w,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.editIcon,
                          width: 20.w,
                          height: 20.w,color: Colors.white,
                          fit: BoxFit.contain,
                          // color: appTheme.white,
                        ),
                      ],
                    ),
                  ),
                  sizeWidthNormal(),

                  InkWell(
                    onTap: (){

                      deleteReminder(context, idReminder: data.id!, index: index,
                          reminderOthers:data.remind_others!);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: AppDecoration.background,
                          width: 28.w,
                          height: 28.w,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.deleteIcon,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.contain,color: Colors.white,
                          // color: appTheme.white,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void deleteReminder(
      BuildContext context, {
        required int idReminder,
        required int index,
        required int reminderOthers,

      }) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return StatefulBuilder(
            builder: (BuildContext context1, StateSetter setState) {
              return AlertDialog(
                backgroundColor: appTheme.buttonColor,
                title: Text(
                  'هل أنت متأكد من حذف التذكير ؟',
                  style: themeLite.textTheme.titleSmall,
                ),
                content: Container(
                  height: 80.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(borderRadius: BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'إلغاء'),
                              ),
                            )),
                      ),
                      sizeWidthNormal(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          ReminderCubit.get(context)
                              .deleteReminder(idReminder: idReminder, index: index,isArchiveReminder: isArchiveReminder,reminderOthers: reminderOthers);
                        },
                        child: Center(
                            child: Container(
                              width: 100.h,
                              height: 40.h,
                              decoration: AppDecoration.outlineSelectedLite
                                  .copyWith(borderRadius: BorderRadius.circular(30.h)),
                              child: Center(
                                child: textNormal(text: 'حذف'),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
