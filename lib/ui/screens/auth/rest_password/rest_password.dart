import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
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
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../theme/lbeena_colors.dart';
import '../../../widget/back_ground_Auth.dart';
import '../login/model_home_page.dart';
import '../otp/otp_screen.dart';
import '../register/cubit/cubit.dart';
import '../register/cubit/status.dart';
import '../widget/appbar_auth.dart';

class RestPassword extends StatefulWidget {
  RestPassword({Key? key,required this.mobileNumber})
      : super(
          key: key,
        );
String? mobileNumber;
  @override
  State<RestPassword> createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  TextEditingController televisionController = TextEditingController();

  TextEditingController mobileNoController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordController2 = TextEditingController();

  final FocusNode _firstFocusNode = FocusNode();

  final FocusNode _secondFocusNode = FocusNode();

  final FocusNode _secondFocusNode2 = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppbarAuth(),
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
                            if (state is SuccessResetPasswordState) {
                              SnackBarHelper.mySnackBarSuccess(
                                  state.otpModel.message.toString(), context);
                              // navigatorToPushReplacementUntil(
                              //     context: context, location: '/homePage');
                              RegisterCubit.get(context).login('971${widget.mobileNumber}', passwordController.text);

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
                                  extra:homePageData
                                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
                              );
                              print(DIManager.findDep<SharedPrefs>()
                                  .getToken());
                              print(DIManager.findDep<SharedPrefs>()
                                  .getUserID());
                            }
                            if (state is ErrorLoginState) {
                              SnackBarHelper.mySnackBarError(
                                  state.error.toString(), context);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              children: [
                                // _buildMobileItem(context, _firstFocusNode),
                                sizeHeightNormal(
                                    height:
                                        AppHeightAndWidthSize.heightSize_18),
                                _buildPasswordItem(context, _secondFocusNode,
                                    passwordController, AppLocalizations.of(context)!.new_password),
                                sizeHeightNormal(
                                    height:
                                        AppHeightAndWidthSize.heightSize_18),
                                _buildPasswordItem(
                                    context,
                                    _secondFocusNode2,
                                    passwordController2,
                                    AppLocalizations.of(context)!.reset_password),
                                sizeHeightNormal(
                                    height:
                                        AppHeightAndWidthSize.heightSize_18),
                                _buildButtonSave(context, state),
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


  bool isObscureText = true;
  /// Section Widget
  Widget _buildPasswordItem(BuildContext context, focusNode, controller, text) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: CustomTextFormField(
        width: 308.w,
        focusNode: focusNode,
        textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: controller,
        hintText: text,
        textStyle: themeLite.textTheme.titleSmall!
            .copyWith(fontWeight: FontWeight.w300),
        // alignment: Alignment.center,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        obscureText: isObscureText,
        suffix: InkWell(
            onTap: () {
              setState(() {
                isObscureText = !isObscureText;
              });
            },
            child: !isObscureText
                ? Icon(
              Icons.remove_red_eye_outlined,
              size: 23.h,
              color: LbeenaColors.orange,
            )
                : Icon(
              Icons.remove_red_eye_sharp,
              size: 25.h,
              color: LbeenaColors.orange,
            )),
        autofocus: false,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          // if (text.length > 10) {
          //   return 'Too more';
          // }
          return null;
        },
        contentPadding:
        EdgeInsets.only(left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
      ),
    );
  }

  bool isTruePassword = true;

  /// Section Widget
  Widget _buildButtonSave(BuildContext context, state) {
    return Column(
            children: [
              !isTruePassword
                  ? textNormal(
                      text: 'الرجاء التأكد من كلمة المرور',
                      color: appTheme.red300)
                  : Container(),
              sizeHeightNormal(
                height: AppHeightAndWidthSize.heightSize_18,
              ),
              Container(
                width: 168.w,
                decoration: AppDecoration.outlineCyan.copyWith(
                  borderRadius: BorderRadiusStyle.circleBorder24,
                ),
                child:  (state is LoadingResetPasswordState)
                    ? loaderOtp()
                    : CustomElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        if (passwordController.text ==
                            passwordController2.text) {
                          RegisterCubit.get(context).resetPassword(
                              widget.mobileNumber!,
                              passwordController.text,
                              passwordController2.text);
                          isTruePassword = true;
                        } else {
                          isTruePassword = false;
                        }
                      });
                    }
                  },
                  width: 168.w,
                  text: AppLocalizations.of(context)!.save,
                  buttonStyle: CustomButtonStyles.outlineCyan,
                ),
              ),

              if (state is LoadingLoginState)...{
                sizeHeightNormal(height: 20.h),
                textNormal(
                    text: 'جاري تسجيل الدخول ..',fontSize: 12.fSize
                )
              }
            ],
          );
  }
}
