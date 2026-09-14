import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/home_page/categories_main.dart';
import '../../../data/models/home_page/home_page_model.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/lbeena_colors.dart';
import '../../theme/cubit/them_app_cubit.dart';
import '../../theme/theme_helper.dart';
import '../auth/login/model_home_page.dart';
import '../home/cubit/cubit.dart';
import '../home/cubit/status.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _initFirebaseMessaging();
    super.initState();
    _splashShownAt = DateTime.now();
    _splashBackground = LbeenaColors.splashStart;
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _initFirebaseMessaging() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (DIManager.findDep<SharedPrefs>().getToken() == null) {
      await firebaseMessaging.getToken().then((token) {
        print("Device token is $token");
        DIManager.findDep<SharedPrefs>().setDeviceToken(token);
      }).catchError((e) {
        print("Error in getting device token: $e");
      });
    }

    // Request permission to receive notifications
  }



  HomePageModel? homePageModel;
  CategoriesAddPostModel? categoriesMainModel;
  HomePageModel? adsRandomModel;
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String? appWord;
  bool isAppUnderMaintenance = false;
  bool isLoading = true;
  Color _splashBackground = LbeenaColors.splashStart;
  DateTime? _splashShownAt;
  bool _sloganFinished = false;
  bool _homeReady = false;
  bool _didNavigate = false;
  HomePageLoginModel? _pendingHome;

  void _applyBackendSplashColor() {
    if (!mounted) return;
    final shownAt = _splashShownAt ?? DateTime.now();
    final elapsed = DateTime.now().difference(shownAt).inMilliseconds;
    const minGreenMs = 800;
    final wait = (minGreenMs - elapsed).clamp(0, minGreenMs);
    Future.delayed(Duration(milliseconds: wait), () {
      if (!mounted) return;
      setState(() {
        _splashBackground = LbeenaColors.teal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit()
        ..getSettingApp()
        ..getColorsApp(),
      // create: (BuildContext context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is SuccessAllDataHomePageState) {
            categoriesMainModel = state.categoriesMainModel;
            homePageModel = state.homePageModel;
            // adsRandomModel = state.adsRandomModel;


            if (DIManager.findDep<SharedPrefs>().getToken() != null) {
              HomeCubit.get(context).getStatusUser();
              // HomeCubit.get(context).unReadNotifications();
            }
            _pendingHome = HomePageLoginModel(
              homePageModel: homePageModel,
              categoriesMainModel: categoriesMainModel,
            );
            _homeReady = true;
            _tryGoHome();

          }

          if (state is SuccessSettingAppState) {
            appWord = state.settingAppModel.data[0].controlMessage??'';
            _controller = AnimationController(
              duration: const Duration(milliseconds: 500),
              vsync: this,
            );

            // إعداد تأثير التلاشي
            _fadeAnimation = CurvedAnimation(
              parent: _controller!,
              curve: Curves.easeIn,
            );

            // بدء الحركة بعد انتهاء الكتابة
            Future.delayed(Duration(milliseconds: 100), () {
              _controller?.forward();
            });
            isLoading = false;

            DIManager.findDep<SharedPrefs>().setAllowUserCreateAd(
                state.settingAppModel.data[0].allowAdsUsers);
            DIManager.findDep<SharedPrefs>().setAllowUserChatsInCommunity(
                state.settingAppModel.data[0].allowChat);
            DIManager.findDep<SharedPrefs>().setFontType(
                state.settingAppModel.data[0].font_type.toString());
            if (state.settingAppModel.data[0].underMaintenance == 0) {
              HomeCubit.get(context).getAllDataInHomePage();
              isAppUnderMaintenance = false;
            } else {
              isAppUnderMaintenance = true;
            }
          }
          if(state is ErrorSettingAppState){
            HomeCubit.get(context).getSettingApp();
          }
          if (state is ErrorAllDataHomePageState) {
            _homeReady = true;
            _tryGoHome();
            // } else {
            //   navigatorToPushReplacementUntil(
            //       context: context, location: '/tour');
            // }
          }

          if (state is SuccessGetStatusUserState) {
            DIManager.findDep<SharedPrefs>()
                .setToken(state.statusUserResult.token);
            DIManager.findDep<SharedPrefs>()
                .setStatusUser(state.statusUserResult.statusUser);
            DIManager.findDep<SharedPrefs>()
                .setStatusUGC(state.statusUserResult.is_ugc ?? false);
            DIManager.findDep<SharedPrefs>()
                .setMembershipNumber(state.statusUserResult.membershipNumber);
          }
          if (state is SuccessColorsAppState) {
            DIManager.findDep<SharedPrefs>().setColorsApp(
              color1: state.colorAppModel?.data?.color1 ?? '',
              color2: state.colorAppModel?.data?.color2 ?? '',
              color3: state.colorAppModel?.data?.color3 ?? '',
            );
            context.read<ThemAppCubit>().refreshBrandColors();
            _applyBackendSplashColor();
          }

        },
        builder: (context, state) {
          return HandelAndroidApp(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              color: _splashBackground,
              child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48.w),
                      child: CustomImageView(
                        imagePath: ImageConstant.logoAppWhite,
                        fit: BoxFit.contain,
                        height: 220.fSize,
                      ),
                    ),
                    sizeHeightNormal(height: 20.h),
                    Center(
                      child: _SplashSloganText(
                        onFinished: _onSloganFinished,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: versionAppWidget(
                        textColor: LbeenaColors.white,
                        yearOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  void _onSloganFinished() {
    if (_sloganFinished) return;
    _sloganFinished = true;
    Future.delayed(const Duration(milliseconds: 350), _tryGoHome);
  }

  void _tryGoHome() {
    if (!_sloganFinished || !_homeReady || _didNavigate) return;
    if (isAppUnderMaintenance || !mounted) return;
    _didNavigate = true;
    navigatorToPushReplacementUntil(
      context: context,
      location: '/homePage',
      extra: _pendingHome,
    );
  }
}

class _SplashSloganText extends StatefulWidget {
  const _SplashSloganText({required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<_SplashSloganText> createState() => _SplashSloganTextState();
}

class _SplashSloganTextState extends State<_SplashSloganText>
    with SingleTickerProviderStateMixin {
  static const _slogan = 'إعلانك يبدأ من هنا مع لبينا';

  late final AnimationController _gradient;

  @override
  void initState() {
    super.initState();
    _gradient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _gradient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 15.fSize,
      fontWeight: FontWeight.w700,
      color: LbeenaColors.white,
      fontFamily: 'Cairo',
      letterSpacing: 0.5,
      height: 1.35,
    );
    final maxWidth = MediaQuery.sizeOf(context).width - 40;
    final painter = TextPainter(
      text: TextSpan(text: '$_slogan|', style: style),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      maxLines: 2,
    )..layout(maxWidth: maxWidth);

    return SizedBox(
      height: painter.height + 8,
      width: painter.width.clamp(0, maxWidth),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedBuilder(
          animation: _gradient,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                final t = _gradient.value;
                return LinearGradient(
                  begin: Alignment(1.4 - 2.8 * t, 0),
                  end: Alignment(-1.4 - 2.8 * t, 0),
                  colors: [
                    LbeenaColors.white,
                    LbeenaColors.orange,
                    LbeenaColors.white,
                    LbeenaColors.orange,
                    LbeenaColors.white,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ).createShader(Offset.zero & bounds.size);
              },
              child: child,
            );
          },
          child: DefaultTextStyle(
            style: style,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  _slogan,
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 140),
                  cursor: '|',
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              displayFullTextOnTap: false,
              onFinished: widget.onFinished,
            ),
          ),
        ),
      ),
    );
  }
}

