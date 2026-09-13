import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/lbeena_phone_country.dart';
import 'package:syrians_in_uae/data/models/profile_company/profile_company_model.dart';
import 'package:syrians_in_uae/ui/app_general_bloc/handel_android_app.dart';
import 'package:syrians_in_uae/ui/screens/auth/login/model_home_page.dart';
import 'package:syrians_in_uae/ui/screens/auth/widget/lbeena_auth_scaffold.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/ugc/subscribe_ugc_page.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/company_info_shimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/custom_text_form_field.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:syrians_in_uae/widgets/otp_widegt.dart';
import 'package:syrians_in_uae/widgets/user_image_profile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
    required this.ugcList,
    required this.dateHomePage,
  });

  HomePageLoginModel? dateHomePage;
  List<Ugc> ugcList = [];

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController decController = TextEditingController();
  TextEditingController namePersonController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  String? userName = DIManager.findDep<SharedPrefs>().getUserName();
  String? mobileNumber = '';
  String? mobileNumberUser = '';
  String? createAt = DIManager.findDep<SharedPrefs>().getCreateAt();
  String? joinAt = DIManager.findDep<SharedPrefs>().getJoinAt();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isFinishTime = false;
  bool loadingShimmer = true;
  bool isStartTime = false;
  XFile? fileLicense;
  String? createdAtTime;
  String? note;
  String? desc_user;
  String? imageCompany;
  String? ratingUser = DIManager.findDep<SharedPrefs>().getRatingUser();
  String _countryCode = LbeenaPhoneCountry.defaultCode;
  String? otp;
  bool isShowOtp = false;
  bool loaderButton = false;

  bool get _isDark => DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    String createdAt = createAt.toString();
    DateTime createdAtDateTime = DateTime.parse(createdAt);
    namePersonController.text = userName.toString();
    createdAtTime = DateFormat('yyyy-MM-dd').format(createdAtDateTime);
  }

  listenerBloc(context, state) {
    if (state is SuccessDataFormatState) {
      createdAtTime = state.createAt;
    }
    if (state is SuccessProfileUserState) {
      loadingShimmer = false;
      imageCompany = state.profileUserModel.data!.user!.profilePic;
      note = state.profileUserModel.data!.user!.note;
      desc_user = state.profileUserModel.data!.user!.desc_user;
      decController.text = state.profileUserModel.data!.user!.desc_user ?? '';

      mobileNumber = state.profileUserModel.data!.user!.mobile!;
      _countryCode = LbeenaPhoneCountry.detectFromFull(mobileNumber);
      final mobileNumberSubstring =
          LbeenaPhoneCountry.localFromFull(mobileNumber);
      mobileNoController.text = mobileNumberSubstring;
      mobileNumberUser = mobileNumberSubstring;
    }
    if (state is LoadingProfileUserState) {
      loadingShimmer = true;
    }
    if (state is SuccessSendOTPState) {
      SnackBarHelper.mySnackBarSuccess(state.otpModel.message, context);
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
          countryCode: _countryCode,
        );
      } else {
        SnackBarHelper.mySnackBarError(
          state.checkMobileExistsModel.message.toString(),
          context,
        );
      }
    }

    if (state is ErrorSendOTPState) {
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }

    if (state is SuccessValidateMobileNumberState) {
      SnackBarHelper.mySnackBarSuccess(state.otpModel.message, context);
      setState(() {
        isStartTime = false;
        isShowOtp = false;
      });
      ProfileCubit.get(context).editProfileInformation(
        userName: namePersonController.text,
        mobileNumber: mobileNoController.text,
        desc_user: decController.text,
        countryCode: _countryCode,
      );
    }
    if (state is LoadingEditProfileState) {
      loaderButton = true;
    }
    if (state is SuccessEditProfileState) {
      loaderButton = false;
      SnackBarHelper.mySnackBarSuccess(
        state.editProfileModel!.message,
        context,
      );
      DIManager.findDep<SharedPrefs>().setMobileNumber(
        LbeenaPhoneCountry.full(_countryCode, mobileNoController.text),
      );
      DIManager.findDep<SharedPrefs>()
          .setUserNamePerson(state.editProfileModel!.data!.userName);
    }
    if (state is ErrorEditProfileState) {
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }

    if (state is SuccessEditImageProfileState) {
      imageCompany = state.editInformationCompanyModel!.data!.profilePic;
      DIManager.findDep<SharedPrefs>().setImageProfile(imageCompany);
      SnackBarHelper.mySnackBarSuccess(
        state.editInformationCompanyModel!.message.toString(),
        context,
      );
    }

    if (state is ErrorEditImageProfileState) {
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }
    if (state is SuccessLoadFileProfileState) {
      fileLicense = state.fileLicense;
      ProfileCubit.get(context).editImageProfile(
        image: File(fileLicense!.path),
      );
    }

    if (state is ErrorValidateMobileNumberState) {
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        backgroundColor:
            _isDark ? LbeenaColors.surfaceDark : LbeenaColors.lightBg,
        appBar: appBarNormalWithIcon(
          text: 'ملف شخصي',
          context: context,
          isShowBack: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocProvider(
            create: (context) => ProfileCubit()
              ..getFormatDate(
                createdAt: createAt.toString(),
                joinedAt: joinAt.toString(),
              )
              ..getProfileUser(),
            child: BlocConsumer<ProfileCubit, ProfileStates>(
              listener: listenerBloc,
              builder: (context, state) {
                return RefreshIndicator(
                  color: LbeenaColors.orange,
                  backgroundColor: LbeenaColors.white,
                  onRefresh: () {
                    ProfileCubit.get(context).getFormatDate(
                      createdAt: createAt.toString(),
                      joinedAt: joinAt.toString(),
                    );
                    return ProfileCubit.get(context).getProfileUser();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: state is ErrorCompanyInformationState
                        ? Column(
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                'خطأ بالتحميل',
                                style: TextStyle(
                                  color: _isDark
                                      ? LbeenaColors.white
                                      : LbeenaColors.tealDark,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const CompanyInformationShimmer(),
                            ],
                          )
                        : loadingShimmer
                            ? const CompanyInformationShimmer()
                            : _bodyPage(context, state),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyPage(context, state) {
    return Column(
      children: [
        _bodyInfoUser(context),
        const SizedBox(height: 14),
        _changeInfo(context, state),
      ],
    );
  }

  Widget _changeInfo(context, state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: LbeenaColors.cardWith(
        color: _isDark ? LbeenaColors.cardDark : LbeenaColors.white,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تعديل المعلومات',
              style: TextStyle(
                color: _isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'حدّث اسمك، سيرتك، ورقم جوالك',
              style: TextStyle(
                color: _isDark ? LbeenaColors.fieldHint : LbeenaColors.muted,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            _fieldLabel('اسم المستخدم'),
            CustomTextFormField(
              fillColor: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.fieldFill,
              controller: namePersonController,
              hintText: 'اسم المستخدم',
              maxLength: 35,
              textInputType: TextInputType.text,
              focusNode: _firstFocusNode,
              prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.user),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _fieldLabel('السيرة الذاتية'),
            CustomTextFormField(
              fillColor: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.fieldFill,
              controller: decController,
              hintText: 'اكتب نبذة قصيرة عنك',
              maxLength: 150,
              maxLines: 3,
              textInputType: TextInputType.multiline,
              focusNode: _thirdFocusNode,
              validator: (a) => null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _fieldLabel('رقم الجوال'),
            _buildMobileItem(context, _secondFocusNode),
            if (DIManager.findDep<SharedPrefs>().getAccountType() ==
                    'individual' &&
                widget.ugcList.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    navigatorToPush(
                      context: context,
                      pageName: SubscribeSgcPage(
                        isEditUGC: true,
                        ugcList: widget.ugcList,
                        dateHomePage: widget.dateHomePage,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: LbeenaColors.orange,
                    side: BorderSide(color: LbeenaColors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.clapperboard,
                    size: 14,
                    color: LbeenaColors.orange,
                  ),
                  label: const Text(
                    'تعديل UGC',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
            if (isShowOtp) ...[
              const SizedBox(height: 18),
              Text(
                'أدخل رمز التحقق',
                style: TextStyle(
                  color: _isDark ? LbeenaColors.white : LbeenaColors.tealDark,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Center(child: _buildOTP(context)),
            ],
            if (isStartTime) ...[
              const SizedBox(height: 12),
              Center(
                child: TimerCountdown(
                  format: CountDownTimerFormat.secondsOnly,
                  enableDescriptions: false,
                  timeTextStyle: TextStyle(
                    color: LbeenaColors.orange,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                  colonsTextStyle: TextStyle(
                    color: LbeenaColors.orange,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                  endTime: isStartTime
                      ? DateTime.now().add(const Duration(seconds: 25))
                      : DateTime.now().add(const Duration(seconds: 1)),
                  onEnd: () {
                    setState(() {
                      isFinishTime = true;
                    });
                  },
                ),
              ),
              if (isFinishTime)
                Center(
                  child: TextButton(
                    onPressed: () {
                      ProfileCubit.get(context).sendOtp(
                        mobileNoController.text,
                        countryCode: _countryCode,
                      );
                      setState(() {
                        isFinishTime = false;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.send_otp_tow,
                      style: TextStyle(
                        color: LbeenaColors.orange,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
            if (!isShowOtp) ...[
              const SizedBox(height: 22),
              _buildButtonSave(context, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: _isDark ? LbeenaColors.white : LbeenaColors.tealDark,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _bodyInfoUser(context) {
    final displayName = namePersonController.text.isEmpty
        ? userName.toString()
        : namePersonController.text;
    final membership =
        DIManager.findDep<SharedPrefs>().getMembershipNumber()?.toString() ?? '';
    final photo = isEmptyProfileImage(imageCompany)
        ? ImageConstant.imgPerson
        : imageCompany.toString().contains('http')
            ? imageCompany.toString()
            : AppEndpoints.baseUrlWithoutApi + imageCompany.toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [LbeenaColors.tealDark, LbeenaColors.teal],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
      child: Column(
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LbeenaColors.orange, width: 3),
                  ),
                  child: ClipOval(
                    child: CustomImageView(
                      imagePath: photo,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      placeHolder: ImageConstant.imgPerson,
                    ),
                  ),
                ),
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: Material(
                    color: LbeenaColors.orange,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => ProfileCubit.get(context).loadImages(),
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            size: 13,
                            color: LbeenaColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: LbeenaColors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'حساب فردي',
            style: TextStyle(
              color: LbeenaColors.white.withValues(alpha: 0.85),
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if ((decController.text).trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              decController.text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: LbeenaColors.white.withValues(alpha: 0.9),
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (membership.isNotEmpty && membership != 'null')
                _metaChip(
                  icon: FontAwesomeIcons.idCard,
                  label: 'عضوية $membership',
                  filled: true,
                ),
              if (createdAtTime != null)
                _metaChip(
                  icon: FontAwesomeIcons.calendar,
                  label: createdAtTime!,
                ),
              if ((ratingUser ?? '').isNotEmpty && ratingUser != 'null')
                _metaChip(
                  icon: FontAwesomeIcons.solidStar,
                  label: ratingUser!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaChip({
    required FaIconData icon,
    required String label,
    bool filled = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: filled
            ? LbeenaColors.orange
            : LbeenaColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 11, color: LbeenaColors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: LbeenaColors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

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
          ProfileCubit.get(context).validateMobileNumber(
            otp!,
            mobileNoController.text,
            countryCode: _countryCode,
          );
        });
      },
    );
  }

  Widget _buildMobileNo(BuildContext context, focusNode) {
    return CustomTextFormField(
      fillColor: _isDark ? LbeenaColors.surfaceDark : LbeenaColors.fieldFill,
      controller: mobileNoController,
      isMobile: true,
      hintText: LbeenaPhoneCountry.phoneHint,
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
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      focusNode: focusNode,
      prefix: const LbeenaAuthFieldIcon(icon: FontAwesomeIcons.mobileScreen),
    );
  }

  Widget _buildMobileItem(BuildContext context, focusNode) {
    return Row(
      children: [
        Expanded(flex: 5, child: _buildMobileNo(context, focusNode)),
        const SizedBox(width: 8),
        buildUaeNumber(
          context,
          initialSelection: '+$_countryCode',
          onChanged: (code) {
            setState(() {
              _countryCode = code;
            });
          },
        ),
      ],
    );
  }

  Widget _buildButtonSave(BuildContext context, state) {
    return loaderButton
        ? loaderNormal(color: LbeenaColors.orange)
        : SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  if (isStartTime) {
                    SnackBarHelper.mySnackBarPending(
                      'الرجاء الانتظار ..',
                      context,
                    );
                    return;
                  }
                  if (namePersonController.text == userName.toString() &&
                      LbeenaPhoneCountry.full(
                            _countryCode,
                            mobileNoController.text,
                          ) ==
                          mobileNumber.toString() &&
                      desc_user == decController.text) {
                    SnackBarHelper.mySnackBarPending(
                      'لم تقم بإجراء أي تعديل ..',
                      context,
                    );
                    return;
                  }

                  if (LbeenaPhoneCountry.full(
                        _countryCode,
                        mobileNoController.text,
                      ) !=
                      mobileNumber.toString()) {
                    ProfileCubit.get(context).checkMobileExists(
                      mobileNumber: mobileNoController.text,
                      countryCode: _countryCode,
                    );
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
              style: ElevatedButton.styleFrom(
                backgroundColor: LbeenaColors.orange,
                foregroundColor: LbeenaColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          );
  }
}
