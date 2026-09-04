import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../../data/models/profile_company/profile_company_model.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../app_general_bloc/handel_android_app.dart';
import '../auth/login/model_home_page.dart';
import '../community/comments.dart';
import '../../../widgets/company_info_shimmer.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/loader_for_page.dart';
import '../../../widgets/otp_widegt.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../widget/url_webview.dart';
import '../auth/login/login_screen.dart';
import '../community/cubit/community_cubit.dart';
import '../community/list_coummunity.dart';
import '../details_product/details_product.dart';
import '../ugc/subscribe_ugc_page.dart';
import 'cubit/status.dart';

class ProfilePage extends StatefulWidget {
   ProfilePage({super.key,required this.ugcList,required this.dateHomePage ,});

   HomePageLoginModel? dateHomePage;
  List<Ugc> ugcList=[];
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isPressing2 = false;
  TextEditingController decController = TextEditingController();
  TextEditingController namePersonController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  String? accountType = DIManager.findDep<SharedPrefs>().getAccountType();
  String? userName = DIManager.findDep<SharedPrefs>().getUserName();
  String? mobileNumber = '';
  String? mobileNumberUser = '';
  String? createAt = DIManager.findDep<SharedPrefs>().getCreateAt();
  String? joinAt = DIManager.findDep<SharedPrefs>().getJoinAt();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPressing = false;
  bool isFinishTime = false;
  bool loadingShimmer = true;
  bool isStartTime = false;
  XFile? fileLicense;
  String? createdAtTime;

// String? joinedAtTime ;
  String? note;
  String? desc_user;

  String? imageCompany;
  String? ratingUser = DIManager.findDep<SharedPrefs>().getRatingUser();

  @override
  void initState() {
    initData();
    super.initState();
  }
  void initData(){
  String createdAt = createAt.toString();
  String joinedAt = joinAt.toString();
  DateTime createdAtDateTime = DateTime.parse(createdAt);
  DateTime joinedAtDateTime = DateTime.parse(joinedAt);
  namePersonController.text = userName.toString();
  // mobileNoController.text = mobileNumber.toString();

  createdAtTime = DateFormat('yyyy-MM-dd').format(createdAtDateTime);
  // joinedAtTime = DateFormat('yyyy-MM-dd').format(joinedAtDateTime);
}
initPrint(){
  print(
      'ProfilePage User: ____________________________________________________________');
  print(
      'ProfilePage User: package:syrians_in_uae/ui/screens/profile/profile_page.dart');
  print('ProfilePage User: ____________________________________________________________');
}

  listenerBloc(context, state){
    if (state is SuccessDataFormatState) {
      createdAtTime = state.createAt;
      // joinedAtTime = state.joinAt;
    }
    if (state is SuccessProfileUserState) {
      loadingShimmer = false;
      imageCompany = state.profileUserModel.data!.user!.profilePic;
      note = state.profileUserModel.data!.user!.note;
      desc_user = state.profileUserModel.data!.user!.desc_user;
      decController.text = state.profileUserModel.data!.user!.desc_user??'';

      String mobileNumberSubstring = state
          .profileUserModel.data!.user!.mobile!
          .substring(3);
      mobileNumber = state.profileUserModel.data!.user!.mobile!;
      mobileNoController.text = mobileNumberSubstring;
      mobileNumberUser = mobileNumberSubstring;
    }
    if (state is LoadingProfileUserState) {
      loadingShimmer = true;
    }
    if (state is SuccessSendOTPState) {
      SnackBarHelper.mySnackBarSuccess(
          state.otpModel.message, context);
      setState(() {
        isStartTime = true;
        isShowOtp = true;
      });
    }

    if (state is LoadingCheckMobileExistsState) {
      loaderButton = true;
    }

    if (state is SuccessCheckMobileExistsState) {
      loaderButton = false;
      if (state.checkMobileExistsModel.status == true) {
        ProfileCubit.get(context).sendOtp(
          mobileNoController.text,
        );
      } else {
        SnackBarHelper.mySnackBarError(
            state.checkMobileExistsModel.message.toString(),
            context);
      }
    }

    if (state is ErrorSendOTPState) {
      SnackBarHelper.mySnackBarError(
          state.error.toString(), context);
    }

    if (state is SuccessValidateMobileNumberState) {
      SnackBarHelper.mySnackBarSuccess(
          state.otpModel.message, context);
      setState(() {
        isStartTime = false;
        isShowOtp = false;
      });
      ProfileCubit.get(context).editProfileInformation(
        userName: namePersonController.text,
        mobileNumber: mobileNoController.text,
        desc_user: decController.text,
      );
    }
    if (state is LoadingEditProfileState) {
      loaderButton = true;
    }
    if (state is SuccessEditProfileState) {
      loaderButton = false;
      SnackBarHelper.mySnackBarSuccess(
          state.editProfileModel!.message, context);
      DIManager.findDep<SharedPrefs>().setMobileNumber('971${mobileNoController.text}');
      DIManager.findDep<SharedPrefs>().setUserNamePerson(state.editProfileModel!.data!.userName);
    }
    if (state is ErrorEditProfileState) {
      SnackBarHelper.mySnackBarError(
          state.error.toString(), context);
    }

    if (state is SuccessEditImageProfileState) {
      imageCompany =
          state.editInformationCompanyModel!.data!.profilePic;
      DIManager.findDep<SharedPrefs>()
          .setImageProfile(imageCompany);
      SnackBarHelper.mySnackBarSuccess(
          state.editInformationCompanyModel!.message.toString(),
          context);
    }

    if (state is ErrorEditImageProfileState) {
      SnackBarHelper.mySnackBarError(
          state.error.toString(), context);
    }
    if (state is SuccessLoadFileProfileState) {
      fileLicense = state.fileLicense;
      ProfileCubit.get(context).editImageProfile(
        image: File(fileLicense!.path),
      );
    }

    if (state is ErrorValidateMobileNumberState) {
      SnackBarHelper.mySnackBarError(
          state.error.toString(), context);
    }
    // loadingShimmer
  }
  bool isReadAll = false;
  @override
  Widget build(BuildContext context) {
    initPrint();
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text:  'ملف شخصي', context: context,isShowBack: true),
            body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider(
        create: (context) => ProfileCubit()
          ..getFormatDate(
              createdAt: createAt.toString(),
              joinedAt: joinAt.toString())
          ..getProfileUser(),
        child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state){
            listenerBloc(context, state);
          },
          builder: (context, state) {
            return RefreshIndicator(
                color: appTheme.greenColor,
                backgroundColor: appTheme.lightBlue100,
                onRefresh: () {
                  ProfileCubit.get(context).getFormatDate(
                      createdAt: createAt.toString(),
                      joinedAt: joinAt.toString());
                  return ProfileCubit.get(context).getProfileUser();
                },
                child: SingleChildScrollView(
                  // physics: BouncingScrollPhysics(),
                  child: state is ErrorCompanyInformationState
                      ? Column(
                          children: [
                            textNormal(text: 'خطأ بالتحميل'),
                            CompanyInformationShimmer(),
                          ],
                        )
                      : loadingShimmer
                          ? CompanyInformationShimmer()
                          : _bodyPage(context,state),
                ));
          },
        ),
      ),
            ),
          ),
    );
  }

  Widget _bodyPage(context ,state){
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        sizeHeightNormal(),
        _bodyInfoUser(context),
        sizeHeightNormal(),
        _changeInfo(context,state),


      ],
    );
  }
  Widget _changeInfo(context ,state){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTextFormFieldItem(context,
              controller:
              namePersonController,
              icon: ImageConstant.imgPerson,
              maxLength: 35,
              hintText: 'اسم المستخدم',
              textInputType:
              TextInputType.text,
              focusNode: _firstFocusNode,
              onChangedButton:
                (text) {
              setState(() {
                namePersonController.text = text;
              });
            },
          ),
          sizeHeightNormal(
            height: 25.h,
          ),
          buildTextFormFieldItem(context,
            controller:
            decController,
            icon: ImageConstant.imgPerson,
            maxLength: 150,
            hintText: 'السيرة الذاتية',
            textInputType:
            TextInputType.text,
            validator: (a){
            return null;
            },
            focusNode: _thirdFocusNode,
            onChangedButton:
                (text) {
              setState(() {
                decController.text = text;
              });
            },
          ),
          sizeHeightNormal(
            height: 25.h,
          ),
          _buildMobileItem(
              context, _secondFocusNode),
          sizeHeightNormal(
            height: 25.h,
          ),
          if( DIManager.findDep<SharedPrefs>().getAccountType() ==
              'individual'&& widget.ugcList.isNotEmpty)...{

            CustomElevatedButton(text: 'تعديل UGC',    width: 208.h,onPressed: (){
              navigatorToPush(context: context, pageName: SubscribeSgcPage(
                isEditUGC: true,
                ugcList: widget.ugcList,
                dateHomePage: widget.dateHomePage,
              ));
            },)
          },
          !isShowOtp
              ? Container()
              : _buildOTP(context),
          !isStartTime
              ? Container()
              : Column(
            children: [
              sizeHeightNormal(),
              TimerCountdown(
                format: CountDownTimerFormat
                    .secondsOnly,
                enableDescriptions:
                false,
                timeTextStyle:
                const TextStyle(
                    color: Colors
                        .lightBlue,
                    fontSize: 12,
                    fontFamily:
                    'Inter',
                    fontWeight:
                    FontWeight
                        .bold,
                    height: 0),
                colonsTextStyle:
                const TextStyle(
                    color: Colors
                        .lightBlue,
                    fontSize: 16,
                    fontFamily:
                    'Inter',
                    fontWeight:
                    FontWeight
                        .bold,
                    height: 0),
                endTime: isStartTime
                    ? DateTime.now()
                    .add(Duration(
                    seconds:
                    25))
                    : DateTime.now()
                    .add(Duration(
                    seconds:
                    1)),
                onEnd: () {
                  setState(() {
                    isFinishTime =
                    true;
                  });
                  // isFinishTime = true;
                },
              ),
              isFinishTime
                  ? InkWell(
                  onTap: () {
                    ProfileCubit.get(
                        context)
                        .sendOtp(
                        mobileNoController
                            .text);
                    setState(() {
                      isFinishTime =
                      false;
                    });
                  },
                  child: textNormal(
                      text: AppLocalizations.of(
                          context)!
                          .send_otp_tow,
                      color: appTheme
                          .greenColor))
                  : Container(),
              sizeHeightNormal(
                  height: AppHeightAndWidthSize
                      .heightSize_40),
            ],
          ),
          sizeHeightNormal(height:20.h),
          isShowOtp?Container():  _buildButtonSave(context, state),
        ],
      ),
    );
  }
  Widget _bodyInfoUser(context){
    return Container(
      width: 250.w,
      decoration: AppDecoration.profileUi,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 75.h,
              height: 90.h,
              child: Center(
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment
                          .bottomCenter,
                      child: Container(
                        width: 75.h,
                        height: 75.h,
                        // color: Colors.green,
                        decoration:
                        AppDecoration
                            .outlineCircular4,
                        // child: Image.asset(
                        //     ImageConstant.imgLogoWhite13,),
                        child:
                        CustomImageView(
                          imagePath: imageCompany.toString().contains('http')? imageCompany
                              .toString():AppEndpoints
                              .baseUrlWithoutApi +
                              imageCompany
                                  .toString(),
                          width: 60.h,
                          height: 60.h,
                          alignment:
                          Alignment
                              .center,
                          radius:
                          BorderRadius
                              .circular(
                              30.h),
                          fit: BoxFit.fill,
                          placeHolder:
                          ImageConstant
                              .imgPerson,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment
                            .topLeft,
                        child: IconButton(
                            onPressed: () {
                              // showNumberWhatsapp(context);
                              ProfileCubit.get(
                                  context)
                                  .loadImages();
                            },
                            icon: Icon(
                              Icons
                                  .camera_alt,
                              color: appTheme
                                  .deepPurpleA10001,
                            ))),
                  ],
                ),
              ),
            ),
            sizeHeightNormal(height: 8.h),
            Text(
              namePersonController.text ==
                  ''
                  ? userName.toString()
                  : namePersonController
                  .text,
              style: themeLite
                  .textTheme.titleSmall,
            ),
            sizeHeightNormal(height: 8.h),
            Text(
                'تاريخ الإنضمام: ${createdAtTime}'),
            Text(
                'رقم العضوية: ${ DIManager.findDep<SharedPrefs>().getMembershipNumber().toString()}'),
          ],
        ),
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

          ProfileCubit.get(context)
              .validateMobileNumber(otp!, mobileNoController.text);
        });
      },

    );
  }


  Widget _buildMobileNo(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return CustomTextFormField(
      width: 208.h,
      controller: mobileNoController,
      isMobile: true,
      hintText: "0504501535",
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppLocalizations.of(context)!.field_is_empty;
        }
        if (text.length > 10 || text.length < 9) {
          return 'يرجى التأكد من الرقم';
        }
        return null;
      },
      autofocus: false,
      // alignment: Alignment.center,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      focusNode: focusNode,
      contentPadding:
      EdgeInsets.only(left: 30.w, top: 10.h, bottom: 10.h, right: 30.w),
    );
  }

  /// Section Widget
  Widget _buildMobileItem(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (lang == 'ar') ...[
            Container(
              decoration: AppDecoration.outlineCyan.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder24,
              ),
              child: _buildMobileNo(context, focusNode),
            ),
            Container(
              decoration: AppDecoration.outlineCyan.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder24,
              ),
              child: buildUaeNumber(context),
            )
          ] else ...[
            Container(
              decoration: AppDecoration.outlineCyan.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder24,
              ),
              child: buildUaeNumber(context),
            ),
            Container(
              decoration: AppDecoration.outlineCyan.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder24,
              ),
              child: _buildMobileNo(context, focusNode),
            ),
          ]
        ],
      ),
    );
  }

  bool isShowOtp = false;
  bool loaderButton = false;

  Widget _buildButtonSave(BuildContext context, state) {
    return loaderButton
        ? loaderNormal()
        : CustomElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
                 if (_formKey.currentState!.validate()) {
                if (isStartTime) {
                  SnackBarHelper.mySnackBarPending(
                      'الرجاء الانتظار ..', context);
                  return ;
                }
                if (namePersonController.text == userName.toString() &&
                    '971${mobileNoController.text}' ==
                        mobileNumber.toString() && desc_user == decController.text) {
                  SnackBarHelper.mySnackBarPending(
                      'لم تقم بإجراء أي تعديل ..', context);
                  return ;
                }

if('971${mobileNoController.text}' != mobileNumber.toString()){
  ProfileCubit.get(context).checkMobileExists(
      mobileNumber: mobileNoController.text);
  return;
} else {
  ProfileCubit.get(context).editProfileInformation(
    userName: namePersonController.text,
    desc_user: decController.text,
  );
  return;
}


              }
            },
            width: 208.h,
            text: AppLocalizations.of(context)!.save,
          );
  }
}

///
// if (_formKey.currentState!.validate()) {
// if (isStartTime) {
// SnackBarHelper.mySnackBarPending(
// 'الرجاء الانتظار ..', context);
// } else {
// if (namePersonController.text != userName.toString() &&
// '971${mobileNoController.text}' ==
// mobileNumber.toString()) {
// ProfileCubit.get(context).editProfileInformation(
// userName: namePersonController.text,
// mobileNumber: mobileNoController.text,desc_user: decController.text,
// );
// return;
// } else if (namePersonController.text == userName.toString() &&
// '971${mobileNoController.text}' !=
// mobileNumber.toString()) {
// ProfileCubit.get(context).checkMobileExists(
// mobileNumber: mobileNoController.text);
// } else if (namePersonController.text == userName.toString() &&
// '971${mobileNoController.text}' ==
// mobileNumber.toString()) {
// // ProfileCubit.get(context)
// //     .checkMobileExists(mobileNumber: mobileNoController.text);
//
// SnackBarHelper.mySnackBarPending(
// 'لم تقم بإجراء أي تعديل ..', context);
// } else if (namePersonController.text != userName.toString() &&
// '971${mobileNoController.text}' !=
// mobileNumber.toString()) {
// ProfileCubit.get(context).editProfileInformation(
// userName: namePersonController.text,
// mobileNumber: mobileNumberUser,
// desc_user: decController.text,
// );
// ProfileCubit.get(context).checkMobileExists(
// mobileNumber: mobileNoController.text);
// }
// }
// }