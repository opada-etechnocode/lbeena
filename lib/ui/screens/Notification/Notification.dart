import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/notifications/all_notifications_model.dart';
import 'package:syrians_in_uae/ui/screens/Notification/cubit/notification_cubit.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/states.dart';
import 'package:syrians_in_uae/ui/screens/community/post_screen.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/chats/data_massage_model.dart';
import '../../../widgets/company_info_shimmer.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../chats/cubit/cubit.dart';
import '../company/company_details_page.dart';
import '../details_product/details_product.dart';
import '../reminders/reminder_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationsModel? notificationsModel;

  bool loadingShimmer = true;

  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  @override
  void initState() {
    chatBlocFirebase.getNotificationsHomePage(
      user_id: DIManager.findDep<SharedPrefs>().getUserID(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text: 'الإشعارات', context: context,isShowBack: true),
        body: RefreshIndicator(
          color: appTheme.greenColor,
          backgroundColor: appTheme.lightBlue100,
          onRefresh: () async {
            // مجرد إعادة جلب البيانات من Firestore
            chatBlocFirebase.getNotificationsHomePage(
              user_id: DIManager.findDep<SharedPrefs>().getUserID(),
            );
          },
          child: BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
            bloc: chatBlocFirebase,
            listener: (context, state) {},
            builder: (context, state) {

              // في حالة ما في بيانات
              if (chatBlocFirebase.notificationHomePage.isEmpty) {

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sizeHeightNormal(height: 80.h),
                    Padding(
                      padding: EdgeInsets.all(50.sp),
                      child: CustomImageView(
                        imagePath: ImageConstant.photoNotification2,
                        width: 3000.w,
                        height: 250.h,
                      ),
                    ),
                  ],
                );
              }

              // إذا في إشعارات
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // زر حذف الكل (لو محتاج تحذف الكولكشن كاملة من Firebase)
                  InkWell(
                    onTap: () {
                      chatBlocFirebase.deleteAllNotifications(
                        user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textNormal(
                        text: 'حذف الكل',
                        color: Colors.red,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: chatBlocFirebase.notificationHomePage.length,
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = chatBlocFirebase.notificationHomePage[index];
                        return Padding(
                          padding: EdgeInsets.all(4.r),
                          child: InkWell(
                            onTap: () {
                              if (item.is_read == '0') {
                                chatBlocFirebase.readNotification(
                                  user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                                  notificationId: item.id!,
                                );
                              }
                              showNotificationsDetails(context, item);
                            },
                            child: Container(
                              height: isIpad(context) ? 90.h : 70.h,
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
                                      width: 320.w,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                textNormal(
                                                  text: item.title.toString(),
                                                  fontSize: AppFontSize.fontSize_16,
                                                ),
                                                Spacer(),
                                                Container(),
                                                textNormal(
                                                  text: convertDateFromFirebase(
                                                    item.created_at!,
                                                  ),
                                                  fontSize: AppFontSize.fontSize_11,
                                                  fontWeight: FontWeight.w500,
                                                  color: appTheme.deepPurpleA100,
                                                ),
                                              ],
                                            ),
                                            sizeHeightNormal(height: 5.h),
                                            textNormal(text: item.body.toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    item.is_read.toString() == '0'
                                        ? Column(
                                      children: [
                                        sizeHeightNormal(height: 10.h),
                                        PopupMenuButton(
                                          color: appTheme.lightBlueBottomNavigatorBar,
                                          child: CustomImageView(
                                            imagePath: ImageConstant.iconList,
                                            height: 15.h,
                                            width: 15.h,
                                            color: appTheme.deepPurpleA10002,
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: textNormal(text: 'حذف'),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == "delete") {
                                              chatBlocFirebase.deleteOneNotification(
                                                user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                                                notificationId: item.id!,
                                              );
                                            }
                                          },
                                        ),
                                        textNormal(
                                          text: '*',
                                          fontSize: 25.sp,
                                          color: Colors.red,
                                        ),
                                      ],
                                    )
                                        : PopupMenuButton(
                                      color: appTheme.lightBlueBottomNavigatorBar,
                                      child: CustomImageView(
                                        imagePath: ImageConstant.iconList,
                                        height: 15.h,
                                        width: 15.h,
                                        color: appTheme.deepPurpleA10002,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: textNormal(text: 'حذف'),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == "delete") {
                                          chatBlocFirebase.deleteOneNotification(
                                            user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                                            notificationId: item.id!,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void showNotificationsDetails(BuildContext context, DataNotificationsHomePageModel data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: appTheme.buttonColor,
            title: Text(
              data.title.toString(),
              style: themeLite.textTheme.titleSmall,
            ),
            content: textNormal(
                text: data.body.toString(), overflow: TextOverflow.visible),
            actions: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Container(
                      width: 120.h,
                      height: 40.h,
                      decoration: AppDecoration.outlineSelectedLite
                          .copyWith(borderRadius: BorderRadius.circular(30.h)),
                      child: Center(
                        child: textNormal(text: 'تم'),
                      ),
                    )),
                  ),
                  sizeWidthNormal(),
                  data.type_notification == 'company'||
                      data.type_notification == 'post'
                      ||data.type_notification == 'ads'
                      ||data.type_notification == 'reminder'
                      ||data.type_notification == 'follow'
                      ?  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      if(data.type_notification == 'company'){
                        navigatorToPush(
                            context: context,
                            pageName: CompanyDetailsPage(
                              idCompany: int.parse(data.user_id.toString()),
                            ));
                      }else if(data.type_notification == 'post'){
                        navigatorToPush(context: context, pageName: PostScreen(idPost: int.parse(data.post_id.toString()),));
                      }else if(data.type_notification == 'ads'){
                          navigatorToPush(
                              context: context,
                              pageName: DetailsProduct(
                                // detailsProduct: relatedAds![index],
                                categoryId: data.category_id.toString(),
                                isBannerInOut: data.in_out == '1' ? true : false,
                                idAds: data.ad_id.toString(),
                                isBanner: data.isBanner == '1' ? true : false,
                                idBannerOrProduct: data.isBanner == '1'
                                    ? int.parse(data.banner_id.toString())
                                    : int.parse(data.ad_id.toString()),
                                idAdOnwerCompany:
                                    int.parse(data.user_id!.toString()),
                              ));
                      }else if(data.type_notification == 'reminder'){
                        navigatorToPush(
                            context: context,
                            pageName: RemindersItem(
                              // detailsProduct: relatedAds![index],
                              idReminder: int.parse(data.reminder_id!),
                              reminderOthers: int.parse(data.reminder_others!)

                            ));
                      }else if( data.type_notification ==  'follow'){
                        navigatorToPush(
                            context: context,
                            pageName: CompanyDetailsPage(
                              idCompany: int.parse(data.following_id.toString()),
                            ));
                      }

                    },
                    child: Center(
                        child: Container(
                      width: 120.h,
                      height: 40.h,
                      decoration: AppDecoration.outlineSelectedLite
                          .copyWith(borderRadius: BorderRadius.circular(30.h)),
                      child: Center(
                        child: textNormal(text: 'انتقل للتفاصيل'),
                      ),
                    )),
                  ):Container(),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}


String convertDate({required String date}){
  DateTime createdAtDateTime =
  DateTime.parse(date == 'null' ? '2024-04-25 12:13:42' : date);

  return DateFormat('yyyy-MM-dd').format(createdAtDateTime).toString();

}


String convertDateFromFirebase(Timestamp timestamp) {
  try {
    DateTime createdAtDateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(createdAtDateTime);
  } catch (e) {
    print("convertDate error: $e");
    return "";
  }
}
