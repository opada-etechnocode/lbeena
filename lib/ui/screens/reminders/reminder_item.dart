import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/data/models/profile_company/package_company_model.dart';
import 'package:syrians_in_uae/ui/screens/payment/payment_page.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/reminders/archive_reminder_page.dart';
import 'package:syrians_in_uae/ui/screens/reminders/cubit/reminder_state.dart';
import 'package:syrians_in_uae/ui/screens/reminders/reminder_page.dart';
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

import 'dart:ui' as ui;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/add_ads/add_ads_model.dart';
import '../../../data/models/reminders/reminders_model.dart';
import '../../../widgets/components.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import 'add_reminder_page.dart';
import 'cubit/reminder_cubit.dart';

class RemindersItem extends StatefulWidget {
  int idReminder;
  int reminderOthers;
  RemindersItem({
    super.key,
    required this.idReminder,
    required this.reminderOthers,
  });

  @override
  State<RemindersItem> createState() => _RemindersItemState();
}

class _RemindersItemState extends State<RemindersItem> {


  @override
  void initState() {
    ReminderCubit.get(context).getItemReminder(idReminder: widget.idReminder, reminderOthers:  widget.reminderOthers);
    super.initState();
  }

  int page = 1;
  RemindersListModel? item;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderCubit, ReminderState>(
      listener: (context, state) {
        if (state is DeleteRemindersSuccessState) {
          SnackBarHelper.mySnackBarSuccess(
              state.remindersModel.message, context,
              behavior: SnackBarBehavior.floating);
        }

        if (state is DeleteRemindersErrorState) {
          SnackBarHelper.mySnackBarError(state.error, context,
              behavior: SnackBarBehavior.floating);
        }
        if(state is GetReminderItemSuccessState)
        {
          item = state.remindersModel.data;
        }
      },
      builder: (context, state) {
        return HandelAndroidApp(
          child: Scaffold(
            appBar: appBarNormalWithIcon(text:  'التذكيرات', context: context,isShowBack: true),
            floatingActionButton: InkWell(
              onTap: (){
                navigatorToPush(context: context, pageName: RemindersPage());
              },
              child: Padding(
                padding:  EdgeInsets.only(top: 50.w,left: 20.w,right: 20.w),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: AppDecoration.outlineWhiteA,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: AppDecoration.outlineCircular2,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.reminderIcon2,
                            height: 30.h,
                            width: 30.h,
                          ),
                        ],
                      ),
                    ),
                    sizeWidthNormal(),
                    textNormal(text: 'مشاهدة كل التذكيرات'),
                  ]
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  state is GetReminderItemLoadingState
                      ? Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sizeHeightNormal(height: 250.h),
                              LoadingAnimationWidget.beat(
                                color: appTheme.cyan400,
                                size: 100,
                              ),
                            ],
                          ),
                      )
                      : item == null?Center(
                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                            text: 'لقد تم حذف هذا التذكير بالفعل',
                            fontWeight: FontWeight.w100)
                                          ],
                                        ),
                      )
                          : Column(
                            children: [
                              sizeHeightNormal(height: 50.h),
                              BuildPackageItem(
                                                data:       item!,
                                                index:-1 ,
                                                isArchiveReminder: false,
                                              ),
                            ],
                          )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
