import 'dart:io';

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
import '../../theme/theme_helper.dart';
import '../auth/login/model_home_page.dart';
import '../home/cubit/cubit.dart';
import '../home/cubit/status.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _initFirebaseMessaging();
    super.initState();
    // _navigateToNextScreen();
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
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? appWord;
  bool isAppUnderMaintenance = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit()..getSettingApp(),
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
            // HomeCubit.get(context).getPolicyTermsAppLinks();
            navigatorToPushReplacementUntil(
                context: context,
                location: '/homePage',
                extra: HomePageLoginModel(
                  homePageModel: homePageModel,
                  categoriesMainModel: categoriesMainModel,
                  // adsRandomModel: adsRandomModel,
                ));

          }

          if (state is SuccessSettingAppState) {
            appWord = state.settingAppModel.data[0].controlMessage??'';
            _controller = AnimationController(
              duration: const Duration(milliseconds: 500),
              vsync: this,
            );

            // إعداد تأثير التلاشي
            _fadeAnimation = CurvedAnimation(
              parent: _controller,
              curve: Curves.easeIn,
            );

            // بدء الحركة بعد انتهاء الكتابة
            Future.delayed(Duration(milliseconds: 100), () {
              _controller.forward();
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
            // if (DIManager.findDep<SharedPrefs>().getIsFirst() == false) {
            navigatorToPushReplacementUntil(
              context: context,
              location: '/homePage',
            );
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

        },
        builder: (context, state) {
          return HandelAndroidApp(
            child: Scaffold(
              backgroundColor: LbeenaColors.teal,
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
                    sizeHeightNormal(height: 24.h),
                    if (isLoading)
                      SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: LbeenaColors.orange,
                        ),
                      )
                    else
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          appWord ?? 'لبينا',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.fSize,
                            fontWeight: FontWeight.w600,
                            color: LbeenaColors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: versionAppWidget(),
                    ),
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }
}

