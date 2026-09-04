import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/ui/screens/auth/complete_register_company/complete_register_company.dart';
import 'package:syrians_in_uae/ui/screens/auth/otp/otp_screen.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/auth/widget/lbeena_auth_scaffold.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/auth/register/register_from_data.dart';
import '../../../../data/models/company/activity_company_model.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/loader_for_page.dart';
import '../../../../widgets/otp_widegt.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/theme_helper.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widget/url_webview.dart';
import '../login/model_home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController televisionController = TextEditingController();

  TextEditingController mobileNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _therdFocusNode = FocusNode();
  final FocusNode _fouredFocusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressing = false;
  bool isPressing2 = true;
  bool isCompany = false;
  bool isFinishTime = false;
  bool isStartTime = false;
  List<ActivityCompanyList> activityCompanyList=[];

  HomePageLoginModel? homePageData;
  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
      print("homePageData : ${homePageData!.homePageModel!.data!.adsBanner!.length}");
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: LbeenaAuthScaffold(
          subtitle: 'ليس لديك حساب؟ أنشئ حسابك خلال دقائق',
          title: 'تسجيل حساب جديد',
          child: Form(
            key: _formKey,
            child: BlocProvider(
              create: (context) => RegisterCubit()..getActivityCompany(),
              child: BlocConsumer<RegisterCubit, RegisterStates>(
                listener: (context, state) {
                  if (state is ErrorRegisterUserState) {
                    SnackBarHelper.mySnackBarError(
                        state.error.toString(), context);
                  }
                  if(state is SuccessActivityCompanyState){
                    activityCompanyList =state.activityCompanyModel.data;
                  }
                  if (state is SuccessRegisterUserState) {
                    SnackBarHelper.mySnackBarSuccess(
                        state.registerModel.message, context);
                    RegisterCubit.get(context).sendOtp(
                      mobileNoController.text,
                    );
                    navigatorToPush(
                        context: context,
                        pageName: OTPScreen(
                          ifFromRegisterAccount: true,
                          ifFromRestPasswordTimer: true,
                          passwordFromRegisterA: passwordController.text,
                          mobileFromRegisterAccount:
                              mobileNoController.text,
                        ));

                  }
                  if (state is SuccessLoginState) {
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

                    navigatorToPushReplacementUntil(
                        context: context,
                        location: '/homePage',
                        extra: homePageData
                    );

                  }
                  if (state is ErrorLoginState) {
                    SnackBarHelper.mySnackBarError(
                        state.error.toString(), context);
                  }
                  if (state is SuccessCheckMobileExistsState) {
                    if (state.checkMobileExistsModel.status ==
                        true) {
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

                  if(state is SuccessSendOTPState) {
                    SnackBarHelper.mySnackBarSuccess(state.otpModel.message, context);
                    setState(() {
                      isStartTime = true;
                    });

                  }


                  if(state is ErrorSendOTPState) {
                    SnackBarHelper.mySnackBarError(state.error.toString(), context);
                  }
                  if(state is SuccessValidateMobileNumberState) {
                    SnackBarHelper.mySnackBarSuccess(state.otpModel.message, context);
                    navigatorToPush(context: context, pageName: CompleteRegisterCompany(
                      mobileNumber: mobileNoController.text,
                      isTransferUserToCompany: false,
                      activityCompanyList: activityCompanyList,
                    ));
                  }



                  if(state is ErrorValidateMobileNumberState) {
                    SnackBarHelper.mySnackBarError(state.error.toString(), context);
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAccountTypeToggle(),
                      if (isCompany == false) ...[
                        const SizedBox(height: 18),
                        _buildMobileItem(context, _firstFocusNode),
                        const SizedBox(height: 14),
                        _buildUserName(context, _secondFocusNode),
                        const SizedBox(height: 14),
                        _buildPassword(context, _therdFocusNode),
                        const SizedBox(height: 14),
                        _buildPassword2(context, _fouredFocusNode),
                        const SizedBox(height: 16),
                        _buildAccept(),
                        const SizedBox(height: 8),
                        if (isSamePassword)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              'تحقق من كلمة المرور',
                              style: TextStyle(
                                color: Color(0xFFF56C74),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        LbeenaAuthPrimaryButton(
                          label: 'تسجيل',
                          loading: state is LoadingRegisterUserState,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _submitPersonalRegister(context);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildHaveAccount(context),
                      ] else ...[
                        const SizedBox(height: 18),
                        _buildMobileItem(context, _firstFocusNode),
                        const SizedBox(height: 16),
                        _buildSendCode(context, state),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildText(context),
                        ),
                        const SizedBox(height: 16),
                        _buildOTP(context),
                        if (isStartTime) ...[
                          const SizedBox(height: 12),
                          TimerCountdown(
                            format: CountDownTimerFormat.secondsOnly,
                            enableDescriptions: false,
                            timeTextStyle: const TextStyle(
                                color: LbeenaColors.orange,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                height: 0),
                            colonsTextStyle: const TextStyle(
                                color: LbeenaColors.orange,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                height: 0),
                            endTime: isStartTime
                                ? DateTime.now().add(const Duration(seconds: 50))
                                : DateTime.now().add(const Duration(seconds: 1)),
                            onEnd: () {
                              setState(() {
                                isFinishTime = true;
                              });
                            },
                          ),
                          if (isFinishTime)
                            InkWell(
                                onTap: () {
                                  RegisterCubit.get(context)
                                      .sendOtp(mobileNoController.text);
                                  setState(() {
                                    isFinishTime = false;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'إعادة إرسال الرمز',
                                    style: TextStyle(
                                      color: LbeenaColors.orange,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                      decorationColor: LbeenaColors.orange,
                                    ),
                                  ),
                                )),
                          const SizedBox(height: 24),
                        ],
                      ]
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: LbeenaColors.lightBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _accountTypeTab(
            label: 'حساب فردي',
            selected: isPressing2,
            onTap: () {
              setState(() {
                isPressing2 = true;
                isCompany = false;
              });
            },
          ),
          _accountTypeTab(
            label: 'حساب شركة',
            selected: !isPressing2,
            onTap: () {
              setState(() {
                isPressing2 = false;
                isCompany = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _accountTypeTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? LbeenaColors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? LbeenaColors.white : LbeenaColors.teal,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccept() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isPressing = !isPressing;
                if (isPressing) {
                  isPressingAccept = false;
                }
              });
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isPressing ? LbeenaColors.orange : LbeenaColors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isPressingAccept
                      ? appTheme.red300
                      : (isPressing ? LbeenaColors.orange : LbeenaColors.fieldBorder),
                  width: 1.4,
                ),
              ),
              child: isPressing
                  ? const Icon(Icons.check, size: 14, color: LbeenaColors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isPressing = !isPressing;
                      if (isPressing) {
                        isPressingAccept = false;
                      }
                    });
                  },
                  child: Text(
                    'الرجاء الموافقة على ',
                    style: TextStyle(
                      color: isPressingAccept ? appTheme.red300 : LbeenaColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    navigatorToPush(
                        context: context,
                        pageName: UrlWebViewPage(
                          urlPage: DIManager.findDep<SharedPrefs>().getTermsLink(),
                          titleAppBer: 'الأحكام والشروط',
                        ));
                  },
                  child: Text(
                    'الشروط وسياسة التطبيق',
                    style: TextStyle(
                      color: isPressingAccept ? appTheme.red300 : LbeenaColors.orange,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: isPressingAccept ? appTheme.red300 : LbeenaColors.orange,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSendCode(BuildContext context, state) {
    return state is LoadingCheckMobileExistsState
        ? loaderNormal(color: LbeenaColors.orange)
        : LbeenaAuthPrimaryButton(
            label: AppLocalizations.of(context)!.send_otp,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                if (!isStartTime) {
                  RegisterCubit.get(context)
                      .checkMobileExists(mobileNumber: mobileNoController.text);
                } else {
                  SnackBarHelper.mySnackBarPending('الرجاء الانتظار ...', context);
                }
              }
            },
          );
  }

  /// Section Widget
  Widget _buildText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.send_otp_pas,
      style: const TextStyle(
        color: LbeenaColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String? otp;


  Widget _buildOTP(context) {
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

          RegisterCubit.get(context)
              .validateMobileNumber(otp!, mobileNoController.text);
        });
      },
    );
  }
  bool isSamePassword = false;
  bool isPressingAccept = false;

  void _submitPersonalRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != password2Controller.text) {
        setState(() {
          isSamePassword = true;
        });
      } else {
        setState(() {
          isSamePassword = false;
        });
        if (isPressing == true) {
          setState(() {
            isPressingAccept = false;
          });

          RegisterCubit.get(context).registerUser(
              registerFromData: RegisterFromData(
            mobile: mobileNoController.text,
            password: passwordController.text,
            passwordConfirm: password2Controller.text,
            userName: userNameController.text,
          ));
        } else {
          setState(() {
            isPressingAccept = true;
          });
        }
      }
    }
  }

  /// Section Widget
  Widget _buildMobileNo(BuildContext context, focusNode) {
    return CustomTextFormField(
      fillColor: LbeenaColors.fieldFill,
      controller: mobileNoController,
      hintText: "504501535",isMobile: true,
      autofocus: false,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      focusNode: focusNode,
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.mobileScreen),
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
          themeLite.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300, color: LbeenaColors.black),
      contentPadding:
          EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h, right: 16.w),
    );
  }

  /// Section Widget
  Widget _buildMobileItem(BuildContext context, focusNode) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _buildMobileNo(context, focusNode),
        ),
        const SizedBox(width: 8),
        buildUaeNumber(context),
      ],
    );
  }

  bool isObscureText = true;

  Widget _passwordSuffix() {
    return InkWell(
        onTap: () {
          setState(() {
            isObscureText = !isObscureText;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: FaIcon(
            isObscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
            size: 16,
            color: LbeenaColors.orange,
          ),
        ));
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      fillColor: LbeenaColors.fieldFill,
      focusNode: focusNode,
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      controller: passwordController,
      hintText: "كلمة المرور",
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.lock),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }

        if (text.length < 8) {
          return 'يجب كلمة السر أن تكون أكثر من 8 أحرف';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: isObscureText,
      suffix: _passwordSuffix(),
      contentPadding:
      EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h, right: 16.w),
    );
  }

  /// Section Widget
  Widget _buildUserName(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      fillColor: LbeenaColors.fieldFill,
      focusNode: focusNode,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }
        return null;
      },
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      controller: userNameController,
      hintText: "اسم المستخدم",
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.user),
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.text,
      autofocus: false,
      contentPadding:
      EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h, right: 16.w),
    );
  }

  /// Section Widget
  Widget _buildPassword2(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      fillColor: LbeenaColors.fieldFill,
      focusNode: focusNode,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }
        return null;
      },
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      controller: password2Controller,
      hintText: "تأكيد كلمة المرور",
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.lock),
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: isObscureText,
      suffix: _passwordSuffix(),
      contentPadding:
      EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h, right: 16.w),
    );
  }


  Widget _buildTf2(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: const Text(
        "تسجيل دخول",
        style: TextStyle(
          color: LbeenaColors.orange,
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
          decorationColor: LbeenaColors.orange,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "هل لديك حساب؟",
          style: TextStyle(
            color: LbeenaColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        _buildTf2(context),
      ],
    );
  }
}

class PointsPainter extends CustomPainter {
  final List<Offset> points;

  PointsPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (var point in points) {
      canvas.drawPoints(PointMode.points, [point], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
