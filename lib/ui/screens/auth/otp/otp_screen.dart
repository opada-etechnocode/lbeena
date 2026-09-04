import 'dart:ui';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/ui/screens/auth/rest_password/rest_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/image_constant.dart';
// import '../../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../../widgets/components.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/loader_for_page.dart';
import '../../../../widgets/otp_widegt.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/lbeena_colors.dart';
import '../../../theme/theme_helper.dart';
import '../../../widget/back_ground_Auth.dart';
import '../../chats/cubit/apis_chat_firebase.dart';
import '../login/model_home_page.dart';
import '../register/cubit/cubit.dart';
import '../register/cubit/status.dart';
import '../widget/appbar_auth.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({
    super.key,
    this.ifFromRestPassword = false,
    this.ifFromRestPasswordTimer = false,
    this.mobileFromRegisterAccount,
    this.passwordFromRegisterA,
    this.ifFromRegisterAccount = false,
  });

  bool? ifFromRestPassword;
  bool? ifFromRestPasswordTimer;
  String? mobileFromRegisterAccount;
  String? passwordFromRegisterA;
  bool ifFromRegisterAccount;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController televisionController = TextEditingController();

  TextEditingController mobileNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController personController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _therdFocusNode = FocusNode();
  final FocusNode _fouredFocusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressing = false;
  bool isPressing2 = false;
  bool isFinishTime = false;
  bool isStartTime = false;

  HomePageLoginModel? homePageData;
  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
      print("homePageData : ${homePageData!.homePageModel!.data!.adsBanner.length}");
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.ifFromRegisterAccount);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: Scaffold(
          resizeToAvoidBottomInset: false, appBar: AppbarAuth(),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    BackGroundAuth(
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.h,
                        vertical: 7.w,
                      ),
                      child: BlocProvider(
                        create: (context) => RegisterCubit(),
                        child: BlocConsumer<RegisterCubit, RegisterStates>(
                          listener: (context, state) {
                            if (state is SuccessSendOTPState) {
                              SnackBarHelper.mySnackBarSuccess(
                                  state.otpModel.message, context);
                              setState(() {
                                isStartTime = true;
                              });
                            }
                            if (state is SuccessCheckMobileExistsState) {
                              if (state.checkMobileExistsModel.status ==
                                  false) {
                                RegisterCubit.get(context).sendOtp(
                                  mobileNoController.text,
                                );
                              } else {
                                SnackBarHelper.mySnackBarError(
                                    state.checkMobileExistsModel.message
                                        .toString(),
                                    context);
                              }
                            }

                            if (state is SuccessValidateMobileNumberState) {
                              if (widget.ifFromRestPassword == true) {
                                SnackBarHelper.mySnackBarSuccess(
                                    state.otpModel.message, context);

                                // navigatorToPushReplacementUntil(
                                //     context: context, location: '/restPassword');
                                navigatorToPush(context: context, pageName: RestPassword(
                                  mobileNumber: mobileNoController.text,
                                ));
                              } else {
                                SnackBarHelper.mySnackBarSuccess(
                                    state.otpModel.message, context);
                                RegisterCubit.get(context).login('971${widget.mobileFromRegisterAccount}', widget.passwordFromRegisterA!);

                                // navigatorToPushReplacementUntil(
                                //     context: context, location: '/homePage');
                              }
                            }

                            if(state is SuccessLoginState){
                              DIManager.findDep<SharedPrefs>()
                                  .setUserInformation(
                                companyIsActive2:
                                state.loginModel.data!.user!.isActive ??
                                    '',
                                userNameCompany2:
                                state.loginModel.data!.user!.companyName,
                                mobileNumber2:
                                state.loginModel.data!.user!.mobile,
                                accountType2:
                                state.loginModel.data!.user!.accountType,
                                token: state.loginModel.data!.accessToken,
                                status: state.loginModel.data!.user!.status,
                                imageProfile2:
                                state.loginModel.data!.user!.profilePic,
                                userID2: int.parse(
                                    state.loginModel.data!.user!.userId!),
                                userNamePerson2:
                                state.loginModel.data!.user!.userName,
                                createdAd2:
                                state.loginModel.data!.user!.createdAt,
                                joinedAd2:
                                state.loginModel.data!.user!.joinedAt,
                                ratingUser2:
                                state.loginModel.data!.user!.rating,
                                membershipNumberValue: state.loginModel.data!.user!.membershipNumber,
                              );
                              APIs.updateStatusUser(
                                userStatus: 'resumed',
                              );
                              navigatorToPushReplacementUntil(
                                  context: context, location: '/homePage',
                                  extra: homePageData
                                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
                              );
                            }

                            if (state is ErrorSendOTPState) {
                              SnackBarHelper.mySnackBarError(
                                  state.error, context);
                            }

                            if (state is ErrorValidateMobileNumberState) {
                              SnackBarHelper.mySnackBarError(
                                  state.error, context);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              children: [
                                widget.ifFromRegisterAccount
                                    ? Container()
                                    : Column(
                                        children: [
                                          _buildMobileItem(
                                              context, _firstFocusNode),
                                          sizeHeightNormal(
                                            height: AppHeightAndWidthSize
                                                .heightSize_20,
                                          ),
                                          _buildSendCode(context, state),
                                          sizeHeightNormal(
                                            height: AppHeightAndWidthSize
                                                .heightSize_16,
                                          ),
                                        ],
                                      ),

                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: _buildText(context),
                                    ),
                                    sizeHeightNormal(
                                        height: AppHeightAndWidthSize
                                            .heightSize_24),
                                    _buildOTP2(context),
                                    // !isStartTime
                                    //     ? Container()
                                    //     : Column(
                                    //         children: [
                                    //           sizeHeightNormal(),
                                    //           TimerCountdown(
                                    //             format: CountDownTimerFormat
                                    //                 .hoursMinutesSeconds,
                                    //             enableDescriptions: false,
                                    //             timeTextStyle: const TextStyle(
                                    //                 color: Colors.lightBlue,
                                    //                 fontSize: 12,
                                    //                 fontFamily: 'Inter',
                                    //                 fontWeight: FontWeight.bold,
                                    //                 height: 0),
                                    //             colonsTextStyle:
                                    //                 const TextStyle(
                                    //                     color: Colors.lightBlue,
                                    //                     fontSize: 16,
                                    //                     fontFamily: 'Inter',
                                    //                     fontWeight:
                                    //                         FontWeight.bold,
                                    //                     height: 0),
                                    //             endTime: isStartTime ||
                                    //                     widget
                                    //                         .ifFromRegisterAccount
                                    //                 ? DateTime.now().add(
                                    //                     Duration(seconds: 25))
                                    //                 : DateTime.now().add(
                                    //                     Duration(seconds: 1)),
                                    //             onEnd: () {
                                    //               setState(() {
                                    //                 isFinishTime = true;
                                    //               });
                                    //               // isFinishTime = true;
                                    //             },
                                    //             /* build: (context, double time) {
                                    //                                 return Text(
                                    //                                   'Time left $time',
                                    //                                   style: const TextStyle(
                                    //                                     color: Color(0xFFAC0000),
                                    //                                     fontSize: 18,
                                    //                                     fontFamily: 'Inter',
                                    //                                     fontWeight: FontWeight.bold,
                                    //                                     height: 0,
                                    //                                   ),
                                    //                                 );
                                    //                               },*/
                                    //           ),
                                    //           isFinishTime
                                    //               ? InkWell(
                                    //                   onTap: () {
                                    //                     RegisterCubit.get(
                                    //                             context)
                                    //                         .sendOtp(
                                    //                             mobileNoController
                                    //                                 .text);
                                    //                     setState(() {
                                    //                       isFinishTime = false;
                                    //                     });
                                    //                   },
                                    //                   child: textNormal(
                                    //                       text:
                                    //                       AppLocalizations.of(context)!.send_otp_tow,
                                    //                           // 'ارسال ال OTP مرة ثانية',
                                    //                       color:
                                    //                           appTheme.blue600))
                                    //               : Container(),
                                    //           sizeHeightNormal(
                                    //               height: AppHeightAndWidthSize
                                    //                   .heightSize_40),
                                    //         ],
                                    //       ),
                                    !widget.ifFromRegisterAccount
                                        ? Container()
                                        : Column(
                                            children: [
                                              sizeHeightNormal(),
                                              TimerCountdown(
                                                format: CountDownTimerFormat
                                                    .secondsOnly,
                                                enableDescriptions: false,
                                                timeTextStyle: const TextStyle(
                                                    color: Colors.lightBlue,
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    height: 0),
                                                colonsTextStyle:
                                                    const TextStyle(
                                                        color: Colors.lightBlue,
                                                        fontSize: 16,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 0),
                                                endTime: widget
                                                        .ifFromRegisterAccount
                                                    ? DateTime.now().add(
                                                        Duration(seconds: 50))
                                                    : DateTime.now().add(
                                                        Duration(seconds: 1)),
                                                onEnd: () {
                                                  setState(() {
                                                    isFinishTime = true;
                                                  });
                                                  // isFinishTime = true;
                                                },
                                                /* build: (context, double time) {
                                                                    return Text(
                                                                      'Time left $time',
                                                                      style: const TextStyle(
                                                                        color: Color(0xFFAC0000),
                                                                        fontSize: 18,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.bold,
                                                                        height: 0,
                                                                      ),
                                                                    );
                                                                  },*/
                                              ),
                                              isFinishTime
                                                  ? InkWell(
                                                      onTap: () {
                                                        if (widget
                                                                .ifFromRegisterAccount ==
                                                            true) {
                                                          RegisterCubit.get(
                                                                  context)
                                                              .sendOtp(widget
                                                                  .mobileFromRegisterAccount!);
                                                        } else {
                                                          RegisterCubit.get(
                                                                  context)
                                                              .sendOtp(
                                                                  mobileNoController
                                                                      .text);
                                                        }
                                                        setState(() {
                                                          isFinishTime = false;
                                                        });
                                                      },
                                                      child: textNormal(
                                                          text:
                                                          AppLocalizations.of(context)!.send_otp_tow,
                                                          color:
                                                              LbeenaColors.orange))
                                                  : Container(),
                                              sizeHeightNormal(
                                                  height: AppHeightAndWidthSize
                                                      .heightSize_40),
                                            ],
                                          ),



                                    if(state is LoadingValidateMobileNumberState)...{
                                      Padding(
                                        padding: EdgeInsets.only(top: 40.h),
                                        child: Container(
                                          width: 25.h,
                                          height: 25.h,
                                          child: CircularProgressIndicator(
                                            color: appTheme.greenColor,
                                          ),
                                        ),
                                      ),
                                    }
                                  ],
                                ),
                                // _buildButtonOtp(context),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? otp;



  Widget _buildOTP2(context) {
    return OTPInputWidget(
      length: 4,
      onChanged: (value) {
        setState(() {
          otp = value;
        });
        print(otp);
      },
      onSubmit: (pin) {
        setState(() {
          otp = pin;
          if (widget.ifFromRegisterAccount == true) {
            RegisterCubit.get(context).validateMobileNumber(
                otp!, widget.mobileFromRegisterAccount!);
          } else {
            RegisterCubit.get(context)
                .validateMobileNumber(otp!, mobileNoController.text);
          }
        });
      },
    );
  }

  /// Section Widget
  Widget _buildText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.send_otp_pas,
      style: themeLite.textTheme.titleMedium!.copyWith(fontSize:12.sp ),
    );
  }


  /// Section Widget
  Widget _buildUaeNumber(BuildContext context) {
    var lang = Localizations.localeOf(context).languageCode;

    return CustomTextFormField(
      width: 97.h,
      readOnly: true,
      controller: televisionController,
      hintText: lang == 'en' ? "+971" : "971+",
      // filled: true,
      prefix: lang == 'ar'
          ? null
          : Container(
              margin: EdgeInsets.fromLTRB(10.h, 16, 9.h, 16),
              child: CustomImageView(
                imagePath: ImageConstant.imgTelevision,
                height: 16.h,
                width: 23.h,
              ),
            ),

      suffix: lang == 'en'
          ? null
          : Container(
              margin: EdgeInsets.fromLTRB(10.h, 16, 9.h, 16),
              child: CustomImageView(
                imagePath: ImageConstant.imgTelevision,
                height: 16.h,
                width: 23.h,
              ),
            ),
      suffixConstraints: lang == 'en'
          ? null
          : BoxConstraints(
              maxHeight: 48.h,
            ),
      prefixConstraints: lang == 'ar'
          ? null
          : BoxConstraints(
              maxHeight: 48.h,
            ),
    );
  }

  /// Section Widget
  Widget _buildMobileNo(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      width: 208.h,
      controller: mobileNoController,
      hintText: "504501535",isMobile: true,
      autofocus: false,
      // alignment: Alignment.center,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      focusNode: focusNode,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }
        if (text.length > 10 || text.length < 9) {
          return 'يرجى التأكد من الرقم';
        }
        return null;
      },

      textStyle:
          themeLite.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300),
      contentPadding:
          EdgeInsets.only(left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
    );
  }

  /// Section Widget
  Widget _buildMobileItem(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (lang == 'ar') ...[
          Container(
            decoration: AppDecoration.outlineCyan,
            child: _buildMobileNo(context, focusNode),
          ),
          Container(
            decoration: AppDecoration.outlineCyan,
            child: _buildUaeNumber(context),
          )
        ] else ...[
          Container(
            decoration: AppDecoration.outlineCyan,
            child: _buildUaeNumber(context),
          ),
          Container(
            decoration: AppDecoration.outlineCyan,
            child: _buildMobileNo(context, focusNode),
          ),
        ]
      ],
    );
  }

  /// Section Widget
  Widget _buildSendCode(BuildContext context, state) {
    return  isStartTime?       TimerCountdown(
      format: CountDownTimerFormat
          .secondsOnly,
      enableDescriptions: false,
      timeTextStyle: const TextStyle(
          color: Colors.lightBlue,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          height: 0),
      colonsTextStyle:
      const TextStyle(
          color: Colors.lightBlue,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight:
          FontWeight.bold,
          height: 0),
      endTime: isStartTime ||
          widget
              .ifFromRegisterAccount
          ? DateTime.now().add(
          Duration(seconds: 50))
          : DateTime.now().add(
          Duration(seconds: 1)),
      onEnd: () {
        setState(() {
          isFinishTime = true;
          isStartTime = false;
          print('isStartTime :$isStartTime');
        });
        // isFinishTime = true;
      },

    ): Container(
      width: 158.h,
            // padding: EdgeInsets.zero,
      decoration: AppDecoration.outlineCyan,
            child: (state is LoadingSendOTPState || state is LoadingCheckMobileExistsState)
                ? loaderOtp()
                :  CustomElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();

                if (_formKey.currentState!.validate()) {
                  if(!isStartTime){

                    RegisterCubit.get(context)
                        .checkMobileExists(mobileNumber: mobileNoController.text);
                    // setState(() {
                    //   isStartTime =true;
                    // });
                  }else {
                    SnackBarHelper.mySnackBarPending('الرجاء الانتظار ...', context);
                  }

                }

              },
              width: 158.h,
              text: AppLocalizations.of(context)!.send_otp,
              buttonStyle: CustomButtonStyles.outlineCyan,
            ),
          );
  }
}

Widget loaderOtp(){
  return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 55.w,vertical: 4.h),
      child:    LoadingAnimationWidget.threeRotatingDots(
        // color:  appTheme.white,
        color:  LbeenaColors.orange,
        size: 35,
      )
  );
}
