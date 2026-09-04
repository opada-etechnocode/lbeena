import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/support/team_service_model.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/company_info_shimmer.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../theme/theme_text_form_field.dart';
import '../home/cubit/cubit.dart';

class CustomerServes extends StatefulWidget {
  CustomerServes({
    super.key,
  });

  @override
  State<CustomerServes> createState() => _CustomerServesState();
}

class _CustomerServesState extends State<CustomerServes> {
  TextEditingController nameUsersServesController = TextEditingController(
    text: DIManager.findDep<SharedPrefs>().getAccountType() == 'individual'
        ? DIManager.findDep<SharedPrefs>().getUserName()
        : DIManager.findDep<SharedPrefs>().getUserNameCompany() ?? '',
  );
  TextEditingController mobileNumberController = TextEditingController(
    text: DIManager.findDep<SharedPrefs>().getMobileNumber() ?? '',
  );
  TextEditingController messageController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _seventhFocusNode = FocusNode();
  String selectedType = 'إبلاغ عن مشكلة';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: textNormal(text: 'إبلاغ عن مشكلة'), value: 'إبلاغ عن مشكلة'),
      DropdownMenuItem(child: textNormal(text: "اقتراحات"), value: "اقتراحات"),
      DropdownMenuItem(child: textNormal(text: "أخرى"), value: "أخرى"),
    ];
    return menuItems;
  }

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  Widget buildCustomerServes(
      {required BuildContext context,
      required focusNode,
      required controller,
      required String hintText,
      vertical,
      required bool readOnly,
      bool isMobile = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: vertical ?? 2.h,
        ),
        decoration:  AppDecoration.outlineCyan.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder10,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 0,
                offset: Offset(
                  2.5,
                  2.5,
                ),
              ),
            ],
            border: Border.all(color: Colors.grey)
        ),
        child: CustomTextFormField(
          width: 320.h,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return AppLocalizations.of(context)!.field_is_empty;
            }
            return null;
          },
          focusNode: focusNode,
          //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          controller: controller,
          // maxLength: 30,
          hintText: hintText,
          readOnly: readOnly,
          isMobile: isMobile,
          maxLength: null,
          // alignment: Alignment.center,
          // textInputAction: TextInputAction.done,
          textInputType: TextInputType.text,
          autofocus: false,
        ),
      ),
    );
  }

  List<ServiceTeamList> dataServiceTeam = <ServiceTeamList>[];
  bool isLoadingServiceTeamData = true;

  /// Section Widget
  Widget _buildTypeServes(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      width: 340.h,
      padding: EdgeInsets.symmetric(
          // horizontal: 15.h,
          // vertical: 9.v,
          ),
      decoration:  AppDecoration.outlineCyan.copyWith(
          borderRadius: BorderRadiusStyle.circleBorder10,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 0,
              offset: Offset(
                2.5,
                2.5,
              ),
            ),
          ],
          border: Border.all(color: Colors.grey)
      ),
      child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            filled: true,
            fillColor: appTheme.lightBlue100,
          ),
          dropdownColor: appTheme.lightBlue100,
          hint: textNormal(text: ''),
          value: selectedType,
          focusNode: focusNode,
          onChanged: (String? newValue) {
            setState(() {
              selectedType = newValue!;
            });
          },
          items: dropdownItems),
    );
  }

  Widget _buildDescriptionCompany(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 30.h,
        ),
        decoration: AppDecoration.outlineCyan.copyWith(
          borderRadius: BorderRadiusStyle.circleBorder10,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 0,
              offset: Offset(
                2.5,
                2.5,
              ),
            ),
          ],
          border: Border.all(color: Colors.grey)
        ),
        child: ThemeTextFormField(
          child: TextFormField(
            controller: messageController,
            focusNode: focusNode,
            // textDirection: DIManager.findDep<ApplicationCubit>().appLanguage.languageCode == AppConsts.LANG_AR? TextDirection.rtl:TextDirection.ltr,
            maxLines: null,
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
              hintText: 'اكتب رسالتك هنا ..',
              hintStyle: themeLite.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey), // زيادة التباعد الرأسي لزيادة ارتفاع الحقل
            ),
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

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(
          text: 'خدمة دعم العملاء',
          isShowBack: true,context: context),
        body: BlocProvider(
          create: (context) => HomeCubit()..getServiceTeam(),
          child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {
              if (state is SuccessSendMessageSupportState) {
                SnackBarHelper.mySnackBarSuccess(
                    state.generalResult.message.toString(), context);
                Navigator.of(context).pop();
              }

              if (state is ErrorSendMessageSupportState) {
                SnackBarHelper.mySnackBarError(state.error.toString(), context);
              }
              if (state is LoadingServiceTeamState) {
                isLoadingServiceTeamData = true;
              }
              if (state is SuccessServiceTeamState) {
                dataServiceTeam = state.allServicesTeamModel.data;
                isLoadingServiceTeamData = false;
              }
              if (state is ErrorServiceTeamState) {
                isLoadingServiceTeamData = false;
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sizeHeightNormal(height: 15.h),
                      _buildTypeServes(context, _seventhFocusNode),
                      buildCustomerServes(
                          context: context,
                          controller: nameUsersServesController,
                          readOnly:
                              DIManager.findDep<SharedPrefs>().getToken() != null
                                  ? true
                                  : false,
                          focusNode: _firstFocusNode,
                          hintText: 'اسم المستخدم'),
                      buildCustomerServes(
                          context: context,
                          controller: mobileNumberController,
                          readOnly:
                              DIManager.findDep<SharedPrefs>().getToken() != null
                                  ? true
                                  : false,
                          focusNode: _secondFocusNode,
                          isMobile: true,
                          hintText: 'رقم الجوال'),
                      _buildDescriptionCompany(context, _thirdFocusNode),
                      sizeHeightNormal(height: 15.h),
                      state is LoadingSendMessageSupportState
                          ? loaderNormal()
                          : CustomElevatedButton(
                              text: 'إرسال',
                              width: 190.w,
                              onPressed: () {
                                if (_formKey2.currentState!.validate()) {
                                  HomeCubit.get(context).sendCustomerServes(
                                      type: selectedType,
                                      userName: nameUsersServesController.text,
                                      mobileNumber: mobileNumberController.text,
                                      messageServes: messageController.text);
                                }
                              },
                            ),
                      sizeHeightNormal(height: 50.h),
                      dataServiceTeam.isEmpty?Container():  Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 5.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textNormal(text: 'فريق التسجيل والدعم والتطوير :'),
                          ],
                        ),
                      ),
                      isLoadingServiceTeamData
                          ? NotificationsInformationShimmer()
                          : dataServiceTeam.isEmpty?Container():ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dataServiceTeam.length,
                          itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Container(
                                  height: 60.h,
                                  decoration: AppDecoration.outlineCyan.copyWith(
                                      borderRadius: BorderRadiusStyle.circleBorder10,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 1,
                                          blurRadius: 0,
                                          offset: Offset(
                                            2.5,
                                            2.5,
                                          ),
                                        ),
                                      ],
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.sp),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CustomImageView(
                                          imagePath:dataServiceTeam[index].image,
                                          height: 40.h,
                                          width: 40.h,
                                          radius: BorderRadius.circular(40.r),
                                          fit: BoxFit.cover,
                                          placeHolder: ImageConstant.community,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            textNormal(text: dataServiceTeam[index].name??''),
                                            textNormal(text: dataServiceTeam[index].description ??'',fontSize:AppFontSize.fontSize_12 ),
                                          ],
                                        ),
                                        Spacer(),
                                        CustomElevatedButton(
                                          width: 120.w,
                                          text: 'واتساب',
                                          leftIcon: Padding(
                                            padding:  EdgeInsets.symmetric(horizontal: 8.w),
                                            child: CustomImageView(
                                              imagePath: ImageConstant.iconWhatsapp,

                                            ),
                                          ),
                                          onPressed: () {
                                            if(dataServiceTeam[index].mobile !=null){
                                              final Uri url = Uri.parse(
                                                  'https://wa.me/+${dataServiceTeam[index].mobile}');
                                              launchUrl(url,mode: LaunchMode.externalApplication);
                                            }

                                          },
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                      sizeHeightNormal(height: 120.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
