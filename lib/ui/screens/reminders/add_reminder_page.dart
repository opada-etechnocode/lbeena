import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as ad;
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/reminders/cubit/reminder_state.dart';
import 'package:syrians_in_uae/ui/screens/reminders/reminder_page.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/reminders/reminders_model.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/components.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_text_form_field.dart';
import 'cubit/reminder_cubit.dart';

class AddRemindersPage extends StatefulWidget {
  RemindersListModel? data;
  bool isEdit = false;
  bool isEditArchive = false;

  AddRemindersPage(
      {super.key, this.data, this.isEdit = false, this.isEditArchive = false});

  @override
  State<AddRemindersPage> createState() => _AddRemindersPageState();
}

class _AddRemindersPageState extends State<AddRemindersPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      descriptionController.text = widget.data!.description.toString();
    }
    super.initState();
  }

  bool _isSwitchedWhatsapp = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<ReminderCubit, ReminderState>(
        listener: (context, state) {
          if (state is AddReminderSuccessState) {
            SnackBarHelper.mySnackBarSuccess(
                state.addReminderModel.message, context,
                behavior: SnackBarBehavior.floating);
            ReminderCubit.get(context).remindersList.clear();
            Navigator.of(context).pop();

            ReminderCubit.get(context).getReminder(page: 1, status: 'active');
          }
          if (state is AddReminderErrorState) {
            SnackBarHelper.mySnackBarError(state.error, context,
                behavior: SnackBarBehavior.floating);
          }
          if (state is EditReminderErrorState) {
            SnackBarHelper.mySnackBarError(state.error, context,
                behavior: SnackBarBehavior.floating);
          }

          if (state is EditReminderSuccessState) {
            SnackBarHelper.mySnackBarSuccess(
                state.addReminderModel.message, context,
                behavior: SnackBarBehavior.floating);
            if (widget.isEditArchive) {
              Navigator.of(context).pop();
            }
            ReminderCubit.get(context).remindersList.clear();
            ReminderCubit.get(context).getReminder(page: 1, status: 'active');
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return HandelAndroidApp(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: appBarNormalWithIcon(text: 'التذكيرات', context: context,isShowBack: true),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 16.h, left: 10.w, right: 10.w),
                  child: state is AddReminderLoadingState ||
                          state is EditReminderLoadingState
                      ? LoadingAnimationWidget.flickr(
                          // color: appTheme.cyan400,
                          size: 35,
                          leftDotColor: appTheme.deepPurpleA10001,
                          rightDotColor: Colors.deepOrangeAccent,
                        )
                      : CustomElevatedButton(
                          height: 35.h,
                          width: 200.w,
                          text: widget.isEdit ? 'تعديل' : 'إضافة',
                          buttonTextStyle: themeLite.textTheme.bodySmall!
                              .copyWith(fontSize: 14.sp),
                          onPressed: () {
                            if (descriptionController.text.isEmpty) {
                              SnackBarHelper.mySnackBarError(
                                  'الرجاء اضافة وصف', context,
                                  behavior: SnackBarBehavior.floating);
                              return;
                            }
                            if (reminderDate == null) {
                              SnackBarHelper.mySnackBarError(
                                  'الرجاء اختيار تاريخ التذكير', context,
                                  behavior: SnackBarBehavior.floating);
                              return;
                            }
                            if (reminderTime == null) {
                              SnackBarHelper.mySnackBarError(
                                  'الرجاء اختيار وقت التذكير', context,
                                  behavior: SnackBarBehavior.floating);
                              return;
                            }
                            DateTime selectedDate =
                                DateFormat('yyyy-MM-dd').parse(reminderDate!);
                            DateTime selectedTime =
                                DateFormat('hh:mm a').parse(reminderTime!);
                            DateTime now = DateTime.now();
                            if (selectedDate.year == now.year &&
                                selectedDate.month == now.month &&
                                selectedDate.day == now.day) {
                              if (selectedTime.hour < now.hour ||
                                  (selectedTime.hour == now.hour &&
                                      selectedTime.minute <= now.minute)) {
                                SnackBarHelper.mySnackBarError(
                                    'لا يمكن اختيار وقت تذكير في الماضي', context,
                                    behavior: SnackBarBehavior.floating);
                                return;
                              }
                            }

                            if (widget.isEdit) {
                              if(widget.data!.remind_others ==1){
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<ReminderCubit>(context)
                                      .editReminder(
                                      idReminder: widget.data!.id!,
                                      description: descriptionController.text,
                                      reminderDate: reminderDate!,
                                      reminderTime:
                                      addSecondsToTime(reminderTime!),
                                   phoneNumber: countryCode +
                                       mobileNoController.text,
                                  reminderOthers: 1);
                                }
                              }else {
                                BlocProvider.of<ReminderCubit>(context)
                                    .editReminder(
                                    idReminder: widget.data!.id!,
                                    description: descriptionController.text,
                                    reminderDate: reminderDate!,
                                    reminderTime:
                                    addSecondsToTime(reminderTime!),reminderOthers: 0,
                                    repeatType: selectedTypeReminder!);
                              }

                            } else {
                              if (_isSwitchedWhatsapp) {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<ReminderCubit>(context)
                                      .addReminder(
                                          description: descriptionController.text,
                                          reminderDate: reminderDate!,
                                          reminderTime:
                                              addSecondsToTime(reminderTime!),
                                          repeatType: selectedTypeReminder!,
                                          isHaveWhatsapp: true,
                                          mobileNumber: countryCode +
                                              mobileNoController.text);
                                }
                              } else {
                                BlocProvider.of<ReminderCubit>(context)
                                    .addReminder(
                                        description: descriptionController.text,
                                        reminderDate: reminderDate!,
                                        reminderTime:
                                            addSecondsToTime(reminderTime!),
                                        repeatType: selectedTypeReminder!);
                              }
                            }
                          },
                        ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDescriptionCompany(context, _firstFocusNode),
                        sizeHeightNormal(height: 10.h),
                        if (widget.isEdit) ...{

                          // sizeHeightNormal(),
                        if (widget.data!.remind_others == 1) ...{
                          Padding(      padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child:      Container(
                            decoration: AppDecoration.outlineCircular10,

                            // width: 260.w,
                            // height: 45.h,
                            alignment: Alignment.centerRight,
                            child:   Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: textNormal(
                                            text: "التاريخ القديم",
                                            fontWeight: FontWeight.w200,color: Colors.grey,fontSize: 12.sp),
                                      ),
                                      // sizeWidthNormal(width: 5.w),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: textNormal(
                                            text: widget.data!.reminderDate
                                                .toString(),
                                            fontWeight: FontWeight.w200,color: Colors.grey,fontSize: 12.sp),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: textNormal(
                                            text: "الرقم القديم",
                                            fontWeight: FontWeight.w200,color: Colors.grey,fontSize: 12.sp),
                                      ),
                                      // sizeWidthNormal(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Directionality(
                                            textDirection: ui.TextDirection.ltr,
                                            child: textNormal(
                                                text: widget.data!.phone_number
                                                    .toString(),
                                                fontWeight: FontWeight.w200,color: Colors.grey,fontSize: 12.sp)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),)


                        }else ...{
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Container(
                              decoration: AppDecoration.outlineCircular10,
            // width: 260.w,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: textNormal(
                                        text: "التاريخ القديم",
                                        fontWeight: FontWeight.w200,color: Colors.grey,fontSize: 12.sp),
                                  ),
                                  // sizeWidthNormal(width: 5.w),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: textNormal(
                                        text: widget.data!.reminderDate
                                            .toString(),
                                        fontWeight: FontWeight.w200,color: Colors.grey,fontSize: 12.sp),
                                  )
                                ],
                              ),
                            ),
                          ),
                        },
                        sizeHeightNormal()
                        },
                        _buildRowTime(),
                        sizeHeightNormal(height: 5.h),
                        if (!widget.isEdit) ...{
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              children: [
                                textNormal(
                                  text: 'ارسال تذكير إلى واتساب',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Transform.scale(
                                    scale: 0.9,
                                    // تغيير الحجم (0.8 يعني تصغير بنسبة 20%)
                                    child: Switch(
                                      value: _isSwitchedWhatsapp,
                                      onChanged: (value) {
                                        setState(() {
                                          _isSwitchedWhatsapp = value;
                                        });
                                      },
                                      activeColor: Colors.white,
                                      inactiveTrackColor: Colors.grey,
                                      activeTrackColor: Colors.green,
                                      trackOutlineWidth:
                                          MaterialStateProperty.all(3),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      trackOutlineColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => appTheme
                                                  .scaffoldBackgroundColor100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isSwitchedWhatsapp) ...{
                            sizeHeightNormal(height: 35.h),
                            _buildPhone()
                          } else ...{
                            _buildRepeatReminder()
                          },
                        } else ...{
                          if (widget.data!.remind_others == 1) ...{
                          sizeHeightNormal(),
                            _buildPhone()
                          } else ...{
                            _buildRepeatReminder()
                          }
                        },
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  String? selectedTypeReminder = 'none';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: 'none',
          child: textNormal(
              text: 'بدون', fontSize: 13.sp, fontWeight: FontWeight.w200)),
      DropdownMenuItem(
          value: "before_one_day",
          child: textNormal(
              text: "تذكير قبل ٢٤ ساعة",
              fontSize: 13.sp,
              fontWeight: FontWeight.w200)),
    ];
    return menuItems;
  }

  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _firstFocusNode = FocusNode();

  String addSecondsToTime(String reminderTime) {
    if (reminderTime.contains('AM') || reminderTime.contains('PM')) {
      // قم بفصل الوقت عن AM/PM
      List<String> parts = reminderTime.split(' ');
      if (parts.length == 2) {
        String time = parts[0]; // الجزء الخاص بالوقت
        String period = parts[1]; // AM أو PM
        return '$time:00 $period'; // أضف الثواني وأعد تنسيق الوقت
      }
      return 'Invalid time format';
    } else {
      return 'Invalid time format';
    }
  }

  String? reminderDate;
  String countryCode = '+971';

  void showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2100, 12, 31),
      theme: ad.DatePickerTheme(
        backgroundColor: appTheme.white,
        itemStyle: themeLite.textTheme.titleSmall!,
        doneStyle: themeLite.textTheme.titleSmall!,
        cancelStyle: themeLite.textTheme.titleSmall!,
      ),
      onConfirm: (date) {
        setState(() {
          reminderDate = DateFormat('yyyy-MM-dd').format(date);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.ar,
    );
  }

  String? reminderTime;

  void showTime12hPicker(BuildContext context) {
    DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      theme: ad.DatePickerTheme(
        backgroundColor: appTheme.white,
        itemStyle: themeLite.textTheme.titleSmall!,
        doneStyle: themeLite.textTheme.titleSmall!,
        cancelStyle: themeLite.textTheme.titleSmall!,
      ),
      onConfirm: (date) {
        setState(() {
          reminderTime = DateFormat('hh:mm a').format(date);
          print(reminderTime);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.ar,
    );
  }

  Widget _buildRepeatReminder() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: textNormal(
                text: 'تكرار التذكير كل',
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w600),
          ),
          sizeHeightNormal(),
          Container(
            padding: EdgeInsets.symmetric(
                // horizontal: 15.h,
                // vertical: 9.v,
                ),
            decoration: AppDecoration.outlineCyan.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder24, boxShadow: []),
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: appTheme.buttonColorBorder, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: appTheme.buttonColorBorder, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: appTheme.buttonColorBorder, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: appTheme.buttonColorBorder, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: appTheme.buttonColorBorder, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: appTheme.lightBlue100,
                ),
                validator: (value) =>
                    value == null ? "يجب أن تختار إمارة" : null,
                dropdownColor: appTheme.lightBlue100,
                hint: textNormal(text: 'تكرار تذكير كل'),
                value: selectedTypeReminder ?? '',
                focusNode: _secondFocusNode,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTypeReminder = newValue!;
                  });
                },
                items: dropdownItems),
          )
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildPhone() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Container(
            decoration: AppDecoration.outlineCyan.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder16,
            ),
            child: _buildMobileNo(context, _threeFocusNode),
          ),
        ),
        sizeWidthNormal(),
        Container(
          decoration: AppDecoration.outlineCyan.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder16,
          ),
          height: 46.h,
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: CountryCodePicker(
              padding: EdgeInsets.zero,

              backgroundColor: appTheme.white,
              dialogBackgroundColor: appTheme.white,
              searchStyle: themeLite.textTheme.titleSmall,
              searchDecoration: InputDecoration(hintText: 'ابحث ..'),
              onChanged: (value) {
                setState(() {
                  countryCode = value.dialCode!;
                });
              },
              flagWidth: 20.w,
              textStyle: TextStyle(fontSize: 14.fSize, color: Colors.grey),
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: '+971',

              favorite: [
                '+968',
                'OM',
                '+973',
                'BH',
                '+974',
                'QAR',
                '+965',
                'KW',
                '+966',
                'KSA',
                '+971',
                'UAE'
              ],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
        ),
      ],
    );
  }

  final FocusNode _threeFocusNode = FocusNode();

  /// Section Widget
  Widget _buildMobileNo(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      width: 230.w,
      controller: mobileNoController,
      hintText: "504501535",
      autofocus: false,
      isMobile: true,
      // alignment: Alignment.center,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      focusNode: focusNode,

      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }
        if (text.length > 10 || text.length < 9) {
          return AppLocalizations.of(context)!.confirm_number;
        }

        return null;
      },

      textStyle:
          themeLite.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300),
      suffix: lang == 'ar'
          ? null
          : Container(
              margin: EdgeInsets.fromLTRB(6.h, 9, 15.h, 9),
              child: CustomImageView(
                imagePath: ImageConstant.imgMinimize,
                height: 30.h,
                width: 35.w,
                color: appTheme.deepPurpleA10001,
                // alignment: Alignment.center,
              ),
            ),
      suffixConstraints: lang == 'ar'
          ? null
          : BoxConstraints(
              maxHeight: 48.h,
            ),
      prefix: lang == 'en'
          ? null
          : Container(
              margin: EdgeInsets.fromLTRB(6.h, 9, 15.h, 9),
              child: CustomImageView(
                imagePath: ImageConstant.imgMinimize,
                height: 30.h,
                width: 35.w, color: appTheme.deepPurpleA10001,
                // alignment: Alignment.center,
              ),
            ),
      prefixConstraints: lang == 'en'
          ? null
          : BoxConstraints(
              maxHeight: 48.h,
            ),
      contentPadding:
          EdgeInsets.only(left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
    );
  }

  Widget _buildRowTime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // CustomElevatedButton(
          //   text: 'اختر التاريخ',width: 150.w,height: 60.h,
          //   isStar: true,
          //   onPressed: (){
          //     showDatePicker(context);
          //   },
          // ),

          InkWell(
            onTap: () {
              showDatePicker(context);
            },
            child: Container(
              decoration: AppDecoration.outlineCircular10,
              width: 140.w,
              height: 45.h,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: textNormal(
                    text: reminderDate ?? 'اختر التاريخ',
                    fontWeight: FontWeight.w200,
                    fontSize: 13.sp),
              ),
            ),
          ),
          sizeWidthNormal(),
          InkWell(
            onTap: () {
              showTime12hPicker(context);
            },
            child: Container(
              decoration: AppDecoration.outlineCircular10,
              width: 140.w,
              height: 45.h,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: textNormal(
                    text: reminderTime ?? 'اختر الوقت',
                    fontWeight: FontWeight.w200,
                    fontSize: 13.sp),
              ),
            ),
          ),
          // CustomElevatedButton(text: 'اختر الوقت',width: 150.w,height: 60.h,     isStar: true,
          // onPressed: (){
          //   showTime12hPicker(context);
          // },),
        ],
      ),
    );
  }

  Widget _buildDescriptionCompany(BuildContext context, focusNode) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: Container(
        height: 110.h,
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          // vertical: 30.h,
        ),
        decoration: AppDecoration.outlineCyan.copyWith(
          borderRadius: BorderRadius.circular(
            10.r,
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.cyan600,
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(
                0,
                0,
              ),
            ),
          ],
        ),
        child: ThemeTextFormField(
          child: TextFormField(
            controller: descriptionController,
            focusNode: focusNode,
            // textDirection: DIManager.findDep<ApplicationCubit>().appLanguage.languageCode == AppConsts.LANG_AR? TextDirection.rtl:TextDirection.ltr,
            maxLines: null,
            maxLength: 100,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return AppLocalizations.of(context)!.field_is_empty;
              }
              return null;
            },
            // maxLength: 700,
            // cursorColor: AppColorsController().scaffoldBGColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterStyle: TextStyle(color: appTheme.black900),
              hintText: 'اكتب الوصف ..',
              hintStyle: themeLite.textTheme.bodyMedium!
                  .copyWith(color: Colors.grey, fontSize: 12.sp),
            ),
            style: themeLite.textTheme.bodySmall!
                .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w100),
            // onChanged: (value) {
            //   setState(() {
            //     // aboutMeValue = value;
            //   });
            // },
          ),
        ),
      ),
    );
  }
}
