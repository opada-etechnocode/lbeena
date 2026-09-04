import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:syrians_in_uae/ui/screens/auth/otp/otp_screen.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/register_screen.dart';
import 'package:syrians_in_uae/ui/screens/auth/widget/lbeena_auth_scaffold.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/helper/snack_bar_helper.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/add_ad_new/category_model.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../../main.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../chats/cubit/apis_chat_firebase.dart';
import '../../home/cubit/status.dart';
import '../register/cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/status.dart';

import 'model_home_page.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.isNeedIconBac = false})
      : super(
          key: key,
        );
  bool isNeedIconBac = false;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController televisionController = TextEditingController();

  TextEditingController mobileNoController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final FocusNode _firstFocusNode = FocusNode();

  final FocusNode _secondFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HomePageModel? homePageModel;
  CategoriesAddPostModel? categoriesMainModel;
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
    firebaseApp.initFirebaseMessagingAndSaveDeviceToken();
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
          subtitle: AppLocalizations.of(context)!.welcome_to_company,
          title: AppLocalizations.of(context)!.login_in_app,
          child: Form(
            key: _formKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<LoginCubit>(
                  create: (BuildContext context) => LoginCubit(),
                ),
                BlocProvider<RegisterCubit>(
                  create: (BuildContext context) => RegisterCubit(),
                ),
                BlocProvider<HomeCubit>(
                  create: (BuildContext context) => HomeCubit()
                    ..getAllDataInHomePage(),
                ),
              ],
              child: BlocConsumer<HomeCubit, HomeStates>(
                listener: (context, state) {
                  if (state is SuccessAllDataHomePageState) {
                    categoriesMainModel = state.categoriesMainModel;
                    homePageModel = state.homePageModel;
                  }

                  if (state is SuccessGetStatusUserState) {
                    DIManager.findDep<SharedPrefs>()
                        .setToken(state.statusUserResult.token);
                    DIManager.findDep<SharedPrefs>().setStatusUser(
                        state.statusUserResult.statusUser);
                    DIManager.findDep<SharedPrefs>().setStatusUGC(state.statusUserResult.is_ugc??false);
                    DIManager.findDep<SharedPrefs>()
                        .setMembershipNumber(state.statusUserResult.membershipNumber);
                  }

                },
                builder: (context, state) {
                  return BlocConsumer<LoginCubit, LoginStates>(
                    listener: (context, state) {
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
                          ratingUser2: state.loginModel.data!.user!.rating,
                          membershipNumberValue: state.loginModel.data!.user!.membershipNumber,
                        );
                        APIs.updateStatusUser(
                          userStatus: 'resumed',
                        );

                        if (DIManager.findDep<SharedPrefs>()
                                .getToken() !=
                            null) {
                          HomeCubit.get(context).getStatusUser();
                        }
                        navigatorToPushReplacementUntil(
                            context: context,
                            location: '/homePage',
                            extra: HomePageLoginModel(
                              homePageModel: homePageModel,
                              categoriesMainModel: categoriesMainModel,
                            ));

                        print(DIManager.findDep<SharedPrefs>()
                            .getToken());
                        print(
                            '============================================');
                        print(DIManager.findDep<SharedPrefs>()
                            .getUserID());
                      }
                      if (state is ErrorLoginState) {

                        if (state.error.is_mobile_verified ==1) {
                          SnackBarHelper.mySnackBarPending(
                              state.error.message.toString(), context);
                          BlocProvider.of<RegisterCubit>(context)
                              .sendOtp(
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

                        }else{
                          SnackBarHelper.mySnackBarError(
                              state.error.message.toString(), context);
                        }
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'لديك حساب ؟ سجل دخول للمتابعة',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: LbeenaColors.black.withOpacity(0.72),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildMobileItem(context, _firstFocusNode),
                          const SizedBox(height: 14),
                          _buildPasswordItem(context, _secondFocusNode),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.forget_password,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: LbeenaColors.muted,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () {
                                    navigatorToPush(
                                        context: context,
                                        pageName: OTPScreen(
                                          ifFromRestPassword: true,
                                        ));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .reset_password,
                                    style: CustomTextStyles
                                        .titleSmallff00a1c4
                                        .copyWith(
                                      color: LbeenaColors.orange,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          LbeenaAuthPrimaryButton(
                            label: 'تسجيل دخول',
                            loading: state is LoadingLoginState,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                LoginCubit.get(context).login(
                                    '971${mobileNoController.text}', passwordController.text);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: LbeenaColors.fieldBorder),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.or,
                                  style: const TextStyle(
                                    color: LbeenaColors.muted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: LbeenaColors.fieldBorder),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          LbeenaAuthPrimaryButton(
                            label: AppLocalizations.of(context)!.login_guest,
                            outlined: true,
                            onPressed: () {
                              navigatorToPushReplacementUntil(
                                  context: context, location: '/homePage',
                                  extra:homePageData
                              );
                            },
                          ),
                          const SizedBox(height: 28),
                          _buildNine(context),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildMobileNo(BuildContext context, focusNode) {
    return CustomTextFormField(
      controller: mobileNoController,
      hintText: "504501535",
      autofocus: false,
      isMobile: true,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      focusNode: focusNode,
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.mobileScreen),
      fillColor: LbeenaColors.fieldFill,
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

  /// Section Widget
  Widget _buildPasswordItem(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      focusNode: focusNode,
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      controller: passwordController,
      hintText: AppLocalizations.of(context)!.password,
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.lock),
      fillColor: LbeenaColors.fieldFill,
      textStyle: themeLite.textTheme.titleSmall!
          .copyWith(fontWeight: FontWeight.w300, color: LbeenaColors.black),
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      obscureText: isObscureText,
      autofocus: false,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }
        return null;
      },
      suffix: InkWell(
          onTap: () {
            setState(() {
              isObscureText = !isObscureText;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: FaIcon(
              isObscureText
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              size: 16,
              color: LbeenaColors.orange,
            ),
          )),
      contentPadding:
          EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h, right: 16.w),
    );
  }

  /// Section Widget
  Widget _buildTf2(BuildContext context) {
    return InkWell(
      onTap: (){
        navigatorToPush(context: context, pageName: RegisterScreen());
      },
      child: Text(
        AppLocalizations.of(context)!.sign_up,
        style: const TextStyle(
          color: LbeenaColors.orange,
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
          decorationColor: LbeenaColors.orange,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNine(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.dont_have_account,
          style: const TextStyle(
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
