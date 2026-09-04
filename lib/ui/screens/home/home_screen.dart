import 'dart:async';

// import 'package:radio_player/radio_player.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
// import 'package:syrians_in_uae/core/link_app.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import 'package:syrians_in_uae/ui/screens/auth/login/login_screen.dart';
import 'package:syrians_in_uae/ui/screens/auth/login/model_home_page.dart';
import 'package:syrians_in_uae/ui/screens/company/company_details_page.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/create_post.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/error_data.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/fixed_ads.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/main_cateogies.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/main_cateogies_new.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/news_widget.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/not_found_internet.dart';
import 'package:syrians_in_uae/ui/screens/home/widget/package_user.dart';
import 'package:syrians_in_uae/ui/screens/reminders/cubit/reminder_cubit.dart';
import 'package:syrians_in_uae/ui/screens/search/search.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upgrader/upgrader.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../data/models/home_page/categories_main.dart';
import '../../../data/models/home_page/banner_product_model.dart';
import '../../../data/models/home_page/home_page_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../../widgets/FloatingActionButtonWidget.dart';
import '../../../widgets/adaptive_status_bar.dart';
import '../../../widgets/custom_page_shimmer.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/lbeena_bottom_nav.dart';
import '../../../widgets/shimmer_home_page/shimmer_home_page.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../../widgets/user_image_profile.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/lbeena_colors.dart';
import '../../theme/theme_helper.dart';
import '../Notification/Notification.dart';
import '../aladhan_time/aladhan_time_card.dart';
import '../cart/cart_page.dart';
import '../cart/cubit/cart_cubit.dart';
import '../chats/cubit/apis_chat_firebase.dart';
import '../chats/cubit/cubit.dart';
import '../chats/cubit/states.dart';
import '../chats/general_chats.dart';
import '../community/community.dart';
import '../community/list_coummunity.dart';
import '../company/companies_page.dart';
import '../cuopon/coupon_ads_screen.dart';
import 'dart:developer' as developer;
import '../filter/filter_page.dart';
import '../reminders/cubit/reminder_state.dart';
import '../setting/setting_page.dart';
import '../ugc/widget/subscribe_ugc.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      this.categoriesMainModel,
      this.homePageModel,
      // this.adsRandomModel
      });

  HomePageModel? homePageModel;
  CategoriesAddPostModel? categoriesMainModel;
  // HomePageModel? adsRandomModel;
  static const routeName = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with LifecycleMixin {
  int selectScreen = -1;
  StreamSubscription<List<ConnectivityResult>>? subscription;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onAppLifecycleChange(AppLifecycleState state) {
    setState(() {
      if (DIManager.findDep<SharedPrefs>().getUserID() != null) {
        if (state == AppLifecycleState.resumed) {
          APIs.updateStatusUser(
            userStatus: state.name.toString(),
          );
        } else {
          APIs.updateStatusUser(
            userStatus: DateTime.now().toString(),
          );
        }
      }
      // if(ReminderCubit.get(context).statusBackgroundRadio){
      //   // _radioPlayer.stop();
      // }
    });
  }

  // bool ReminderCubit.get(context).isPlayingRadio = false;

  // late AnimationController _controller;
  // late Animation<double> _fadeAnimation;

  void initState() {
    super.initState();

    ///RadioWork
    // ReminderCubit.get(context).playRadio();
    timerBanner();
    // _controller = AnimationController(
    //   vsync: this, // Provides vsync (TickerProviderStateMixin is required)
    //   duration: const Duration(seconds: 2),
    // );
    // _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    // _controller.forward();
    initConnectivity();
    onAppLifecycleChange(AppLifecycleState.resumed);
    FirebaseMessaging.instance.subscribeToTopic('all');
    if (DIManager.findDep<SharedPrefs>().getToken() == null) {
      FirebaseMessaging.instance.subscribeToTopic('unregistered');
    }else{
      FirebaseMessaging.instance.subscribeToTopic('registered');
      if(DIManager.findDep<SharedPrefs>().getAccountType() =='company'){
         FirebaseMessaging.instance.subscribeToTopic('registeredCompany');
      }
      if(DIManager.findDep<SharedPrefs>().getAccountType() =='individual'){
         FirebaseMessaging.instance.subscribeToTopic('registeredIndividual');
      }
      CartCubit.get(context).getMyCart();
    }
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    // _controller.dispose();
    _bannerController.dispose();

    ///RadioWork
    // ReminderCubit.get(context).stopRadio();

    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    // print('Connectivity changed: $_connectionStatus');
    // print('Connectivity changed: $_connectionStatus');
    // print('Connectivity changed: $_connectionStatus');
    // print('Connectivity changed: $_connectionStatus');
    // print('Connectivity changed: $_connectionStatus');
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int pageAllAds = 0;
  HomePageModel? homePageModel;
  CategoriesAddPostModel? categoriesMainModel;
  HomePageModel? allAdsModel;
  AdsVideo? adsVideoModel;
  NewsDatum? adsNewsModel;
  List<DataProductBannerModel> allAdsList = [];
  CommunityAllPost? communityPostModel;

  bool isLoadingData = false;
  bool _showWord = false;
  bool isShowAllBanner = false;

  void _showWordTimer() async {
    _showWord = true;
    await Future.delayed(Duration(milliseconds: 1500));
    _showWord = false;
    if (mounted) setState(() {});
    _refreshController.resetNoData();
  }

  String type = 'ads';
  int type2 = 0;
  bool isShowSearch = false;
  String? titleRadio;
  int indexBanner = 0;
  DataCategoriesMain? dataCategoriesMain;
  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  // String? statusUser = DIManager.findDep<SharedPrefs>().getStatusUser();

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: UpgradeDialogStyle.cupertino,
      cupertinoButtonTextStyle: TextStyle(
        fontSize: 14.sp,
        color:Colors.black,
      ),
      child: homeScreen(),
    );
  }

  Widget homeScreen() {
    String? userId = DIManager.findDep<SharedPrefs>().getUserID();
    int counterNotificationsUnRead =
        DIManager.findDep<SharedPrefs>().getCounterNotifications() ?? 0;
    String? accountType = DIManager.findDep<SharedPrefs>().getAccountType();
    String? imageProfile =
        DIManager.findDep<SharedPrefs>().getImageProfile().toString();
    return
      // AdaptiveStatusBar(
      // backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      HandelAndroidApp(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButtonWidget(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocProvider(
            create: (context) {
              if (widget.categoriesMainModel == null ||
                  widget.homePageModel == null
                  // || widget.adsRandomModel == null
              ) {
                // return HomeCubit()..getHomePageApi(withCategories: true);
                return HomeCubit()..getAllDataInHomePage();

                ///RadioWork
                // ..playNowRadio();
              } else {
                homePageModel = widget.homePageModel;
                categoriesMainModel = widget.categoriesMainModel;
                // adsRandomModel = widget.adsRandomModel;
                // adsRandom = widget.adsRandomModel!.data!.adsRandom!.data;
                communityPostModel = widget.homePageModel!.data!.postPin!;
                if(widget.homePageModel!.data!.newsHomePageModel.isNotEmpty){
                  adsNewsModel = widget.homePageModel!.data!.newsHomePageModel[0];
                }
                pageAllAds = 0;
                isLoadingData = true;

                if (DIManager.findDep<SharedPrefs>().getToken() == null) {
                  return HomeCubit()
                    ..getColorsApp()
                    ..getSettingApp();

                  ///RadioWork
                  // ..playNowRadio();
                } else {
                  return HomeCubit()
                    ..getStatusUser()
                    // ..unReadNotifications()
                    ..getColorsApp()
                    ..getStatusRecorder()
                    ..getSettingApp();

                  ///RadioWork
                  // ..playNowRadio();
                }
              }
              // return HomeCubit()..getStatusUser();
            },
            child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                listenerHomePage(context, state);
                if (state is SuccessDeleteAccountState) {
                  if (accountType == 'company') {
                    SnackBarHelper.mySnackBarPending(
                        state.generalModel!.message.toString(), context);
                  } else {
                    SnackBarHelper.mySnackBarSuccess(
                        state.generalModel!.message.toString(), context);
                    DIManager.findDep<SharedPrefs>().setImageProfile(null);
                    DIManager.findDep<SharedPrefs>().setToken(null);
                    DIManager.findDep<SharedPrefs>().setAccountType(null);
                    DIManager.findDep<SharedPrefs>().setUserInformation(
                      companyIsActive2: null,
                      userNameCompany2: null,
                      mobileNumber2: null,
                      accountType2: null,
                      token: null,
                      status: null,
                      imageProfile2: null,
                      userID2: null,
                      userNamePerson2: null,
                      createdAd2: null,
                      joinedAd2: null,
                      ratingUser2: null,
                      membershipNumberValue: null,
                    );
                    DIManager.findDep<SharedPrefs>().setCounterNotifications(0);
                  }
                }
                if (state is SuccessAllDataHomePageState) {
                  isLoadingData = true;
                  imageProfile = DIManager.findDep<SharedPrefs>()
                      .getImageProfile()
                      .toString();
                  // HomeCubit.get(context).getPolicyTermsAppLinks();
                  HomeCubit.get(context).getAllNews();
                  HomeCubit.get(context).getColorsApp();
                  HomeCubit.get(context).getSettingApp();
                  // ..getColorsApp();();
                  if (DIManager.findDep<SharedPrefs>().getToken() != null) {
                    HomeCubit.get(context).getStatusUser();
                    HomeCubit.get(context).getStatusRecorder();
                    // HomeCubit.get(context).unReadNotifications();
                    BlocProvider.of<HomeCubit>(context).getPackagesUser();
                  }
                  // print('imageProfile $imageProfile');
                  categoriesMainModel = state.categoriesMainModel;
                  // print(categoriesMainModel!.data[2].categoryId);
                  // print(categoriesMainModel!.data[2].categoryId);
                  // print(categoriesMainModel!.data[2].categoryId);
                  homePageModel = state.homePageModel;
                  // adsRandomModel = state.adsRandomModel;

                  // adsVideoModel = state.homePageModel!.data!.adsVideo!;
                  communityPostModel = state.homePageModel!.data!.postPin!;
                  if(state.homePageModel!.data!.newsHomePageModel.isNotEmpty){
                    adsNewsModel = state.homePageModel!.data!.newsHomePageModel[0];
                  }
                  // adsRandom = state.adsRandomModel!.data!.adsRandom!.data;
                  pageAllAds = 0;
                setDataHomePage( HomePageLoginModel(
                      // adsRandomModel: adsRandomModel,
                      categoriesMainModel:categoriesMainModel ,
                      homePageModel: homePageModel
                  ));
                }
              },
              builder: (context, state) {
                return _connectionStatus[0].toString() ==
                        'ConnectivityResult.none'
                    ? const NotFoundInternet()
                    : Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          selectScreen == -1
                              ? homePage(state, context, imageProfile, userId,
                                  counterNotificationsUnRead)
                              : widgetApp[selectScreen],
                          LbeenaBottomNav(
                            selectScreen: selectScreen,
                            chatBloc: chatBlocFirebase,
                            onSelect: (index) {
                              setState(() {
                                selectScreen = index;
                              });
                            },
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  void timerBanner() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_bannerController.hasClients) {
        if (_bannerController.page!.round() ==
            homePageModel!.data!.adsBanner.length - 1) {
          _bannerController.animateToPage(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          _bannerController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  List<Widget> widgetApp = [
    CartPage(),
    GeneralChatsPage(),
    SettingPage(),
    CompaniesPage()
  ];
  final PageController _bannerController =
      PageController(viewportFraction: 0.9);
  ScrollController controllerInfiniteCarousel =
      ScrollController(initialScrollOffset: 0);

  Widget homePage(
      state, context, imageProfile, userId, counterNotificationsUnRead) {
    return Column(
      children: [
        _buildAppBarHomePage(
            context, imageProfile, userId, counterNotificationsUnRead),
        // sizeHeightNormal(),
        Expanded(
          flex: 2,
          child: SmartRefreshWidget(
            onRefresh: () {
              onRefreshHomePage(context);
            },
            controller: _refreshController,
            onLoading: () {
              onLoadingHomepage(context);
            },
            child: isLoadingData
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        if (state is LoadingAllDataHomePageState) ...[
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: const CustomPageShimmer(),
                          ),
                        ] else if (state is ErrorAllDataHomePageState) ...[
                          const ErrorData()
                        ] else ...[
                          // const TopNewsWidget(),
                          if (homePageModel != null) ...{
                            sizeHeightNormal(),
                            MainCategoriesNew(
                            dateHomePage:  HomePageLoginModel(
                                categoriesMainModel:categoriesMainModel ,
                                homePageModel: homePageModel
                            ),
                            ),
                            const AladhanTimeCardWidget(),

                            homePageModel!.data!.adsBanner.isNotEmpty
                                ? sizeHeightNormal(height: 8)
                                : Container(),
                            homePageModel!.data!.adsBanner.isNotEmpty
                                ? Column(
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount: homePageModel!
                                            .data!.adsBanner.take(3).length,
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          return buildBannerItem(
                                              context,
                                              homePageModel!.data!.adsBanner[index]);
                                        },
                                        options: CarouselOptions(
                                          height: 158.h,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 4),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 700),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.12,
                                          viewportFraction: 0.88,
                                          enableInfiniteScroll: true,
                                          scrollDirection: Axis.horizontal,
                                          // اتجاه التمرير

                                          onPageChanged: (index, reason) {
                                            // يمكنك تحديث حالة المؤشر هنا إذا لزم الأمر
                                          },
                                        ),
                                      ),
                                      sizeHeightNormal(),
                                    ],
                                  )
                                : Container(),

                            MainCategories(
                              categoriesMainModel:categoriesMainModel,
                            ),

                            FixedAdsWidget(
                              adsProduct: homePageModel!.data!.adsProduct,
                            ),
                            communityPostModel ==null?Container(): communityPostModel!.data.isEmpty
                                ? Container()
                                : Column(
                                    children: [
                                      LbeenaSectionHeader(
                                        title: 'من قسم سوشال',
                                        icon: FontAwesomeIcons.users,
                                        actionLabel: 'عرض الكل',
                                        onAction: () {
                                          navigatorToPush(
                                              context: context,
                                              pageName: CommunityPage());
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ListCommunity(
                                          communityPostModel:
                                              communityPostModel!.data,
                                          page: pageAllAds,
                                          isFromUserPage: false,
                                          isFromHomePage: true,
                                        ),
                                      ),
                                    ],
                                  ),

                            if (DIManager.findDep<SharedPrefs>().getToken() !=
                                    null &&
                                DIManager.findDep<SharedPrefs>()
                                        .getAccountType() ==
                                    'individual' &&
                                DIManager.findDep<SharedPrefs>()
                                        .getStatusUGC() ==
                                    false) ...{
                               SubscribeUGCWidget(
                                 dateHomePage: HomePageLoginModel(
                                   // adsRandomModel: adsRandomModel,
                                   categoriesMainModel:categoriesMainModel ,
                                   homePageModel: homePageModel
                                 ),
                               ),
                            },


                            /// خطة اعلانية
                            if (DIManager.findDep<SharedPrefs>().getToken() !=
                                null) ...{
                              const PackageUserWidget(),
                              sizeHeightNormal(),
                            },
                            // buildAdsItems(context,
                            //     adsProduct:
                            //         adsEvaluationModel!.data!.adsEvalution,
                            //     text: AppLocalizations.of(context)!
                            //         .top_rated_ads),

                            adsNewsModel==null
                                ? Container()
                                : buildNewsAds(context,
                                    adsNewsModel: adsNewsModel),

                            homePageModel!.data!.company ==null?Container():   buildCompanyAdvertisers(context,
                                company: homePageModel!.data!.company),

                            if ( homePageModel!.data!.adsBanner.length>3)
                              Column(
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: homePageModel!
                                        .data!.adsBanner.length ==4?1: homePageModel!
                                        .data!.adsBanner.length ==5?2:homePageModel!
                                        .data!.adsBanner.length==6?3:0,
                                    itemBuilder:
                                        (context, index, realIndex) {
                                      return buildBannerItem(
                                          context,
                                          homePageModel!.data!.adsBanner[index+3]);
                                    },
                                    options: CarouselOptions(
                                      height: 158.h,
                                      autoPlay: true,
                                      autoPlayInterval:
                                      Duration(seconds: 4),
                                      autoPlayAnimationDuration:
                                      Duration(milliseconds: 700),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.12,
                                      viewportFraction: 0.88,
                                      enableInfiniteScroll: true,
                                      scrollDirection: Axis.horizontal,

                                      onPageChanged: (index, reason) {
                                        // يمكنك تحديث حالة المؤشر هنا إذا لزم الأمر
                                      },
                                    ),
                                  ),
                                  sizeHeightNormal(),
                                ],
                              ),

                            buildAdsRandom(context,
                                adsRandom: allAdsList,
                                text: AppLocalizations.of(context)!.all_ads),

                            if (state is LoadingAdsRandomState) ...[
                              Center(
                                child:  Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: appTheme.greenColor,
                                      strokeWidth: 1.5,
                                    )),
                              ),
                            ],
                            _showWord
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: textNormal(
                                        text: AppLocalizations.of(context)!
                                            .download_data,
                                        color: appTheme.greenColor),
                                  )
                                : Container(),
                            sizeHeightNormal(height: 120),
                          } else ...{
                            const ErrorData()
                          }
                        ],
                        // BannerItemShimmer(),
                      ],
                    ),
                  )
                : const ShimmerHomePage(),
          ),
        ),
      ],
    );
  }

  listenerHomePage(context, state) {
    /// Success
    ///RadioWork
    // if (state is SuccessPlayNowRadioState) {
    //   titleRadio = state.playNowModel.nowPlaying!.song!.title!;
    // }
    if (state is SuccessHomePageState) {
      homePageModel = state.homePageModel;
    }
    if (state is SuccessSettingAppState) {
      DIManager.findDep<SharedPrefs>()
          .setAllowUserCreateAd(state.settingAppModel.data[0].allowAdsUsers);
      DIManager.findDep<SharedPrefs>().setAllowUserChatsInCommunity(
          state.settingAppModel.data[0].allowChat);
      DIManager.findDep<SharedPrefs>().setFontType(
          state.settingAppModel.data[0].font_type.toString());
    }
    if (state is SuccessLogoutState) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>  LoginScreen(), ),
      // );
      //

      navigatorToPushReplacementUntil(context: context, location: '/login');
    }

    if (state is SuccessStatusRecorderState) {
      DIManager.findDep<SharedPrefs>()
          .setIsAllowVoice(state.statusRecorderModel.is_allow_voice);
      DIManager.findDep<SharedPrefs>()
          .setTimeVoice(state.statusRecorderModel.allow_voice_time);
      DIManager.findDep<SharedPrefs>()
          .setUserIsBlocked(state.statusRecorderModel.is_blocked);
      DIManager.findDep<SharedPrefs>().setIsPermissionChatGroup(
          state.statusRecorderModel.is_permission_chat);
    }


    if (state is SuccessGetStatusUserState) {
      // print('state.statusUserResult.statusUser: ${state.statusUserResult.statusUser}');
      // print('state.statusUserResult.accountType: ${state.statusUserResult.accountType}');
      DIManager.findDep<SharedPrefs>().setToken(state.statusUserResult.token);
      if(state.statusUserResult.token ==null)
      {
        if(DIManager.findDep<SharedPrefs>().getUserID() != null) {
          SnackBarHelper.mySnackBarSuccess(
              state.statusUserResult.message.toString(), context);
        }
        DIManager.findDep<SharedPrefs>().setImageProfile(null);
        DIManager.findDep<SharedPrefs>().setUserID(null);
        // DIManager.findDep<SharedPrefs>().setToken(null);
        DIManager.findDep<SharedPrefs>().setAccountType(null);
        DIManager.findDep<SharedPrefs>().setUserInformation(
          companyIsActive2: null,
          userNameCompany2: null,
          mobileNumber2: null,
          accountType2: null,
          token: null,
          status: null,
          imageProfile2: null,
          userID2: null,
          userNamePerson2: null,
          createdAd2: null,
          joinedAd2: null,
          ratingUser2: null,
          membershipNumberValue: null,
        );

        DIManager.findDep<SharedPrefs>().setStatusUGC(false);
        DIManager.findDep<SharedPrefs>().setCounterNotifications(0);
        subscribeToTopic();
      }else {
        DIManager.findDep<SharedPrefs>()
            .setStatusUGC(state.statusUserResult.is_ugc ?? false);
        DIManager.findDep<SharedPrefs>()
            .setStatusUser(state.statusUserResult.statusUser);
        DIManager.findDep<SharedPrefs>()
            .setAccountType(state.statusUserResult.accountType);
        DIManager.findDep<SharedPrefs>()
            .setUserNameCompany(state.statusUserResult.company_name);
        DIManager.findDep<SharedPrefs>()
            .setUserNamePerson(state.statusUserResult.user_name);
        DIManager.findDep<SharedPrefs>()
            .setMembershipNumber(state.statusUserResult.membershipNumber);
      }

    }


    if (state is SuccessSendMessageSupportState) {
      Navigator.pop(context);
      SnackBarHelper.mySnackBarSuccess(
          state.generalResult.message.toString(), context);
    }
    if (state is SuccessAdsRandomState) {
      if (state.adsRandomModel.data!.adsRandom!.data.isEmpty) {
        isShowAllBanner = true;
        _showWordTimer();
      }
      allAdsList.addAll(state.adsRandomModel.data!.adsRandom!.data);

      // print('indexBanner:#$indexBanner}');
    }

    if (state is SuccessColorsAppState) {
      DIManager.findDep<SharedPrefs>().setColorsApp(
          color1: state.colorAppModel!.data!.color1!,
          color2: state.colorAppModel!.data!.color2!,
          color3: state.colorAppModel!.data!.color3!);
    }

    /// Error
    if (state is ErrorLogoutState) {
      SnackBarHelper.mySnackBarError(state.error.toString(), context);
    }

    /// Loading
    if (state is LoadingAllDataHomePageState) {
      isLoadingData = false;
    }
  }

  onRefreshHomePage(context) async {
    await HomeCubit.get(context).getAllDataInHomePage(isNeedRefresh: false);

    ///RadioWork
    // await HomeCubit.get(context).playNowRadio();
    // ReminderCubit.get(context).playRadio();

    setState(() {
      isShowAllBanner = false;
    });
    indexBanner = 0;
    allAdsList.clear();
    pageAllAds=0;
    _refreshController.refreshCompleted();
  }

  onLoadingHomepage(context) async {
    pageAllAds++;
    await HomeCubit.get(context).getAdsRandom(page: pageAllAds);
    setState(() {});
    _refreshController.loadComplete();
  }

  Widget _buildAppBarHomePage(
      BuildContext context, imageProfile, userId, counterNotificationsUnRead) {
    final isDark = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? const [LbeenaColors.black, LbeenaColors.surfaceDark]
                : const [LbeenaColors.tealDark, LbeenaColors.teal],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.logoAppbarWhite,
                  height: 58,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                LbeenaAppBarIcon(
                  icon: FontAwesomeIcons.magnifyingGlass,
                  onTap: () {
                    navigatorToPush(
                      context: context,
                      pageName: FilterPage(
                        categoriesMainModel: categoriesMainModel,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Builder(builder: (context) {
                  if (DIManager.findDep<SharedPrefs>().getToken() != null) {
                    chatBlocFirebase.getNotificationsHomePage(
                      user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                    );
                  }
                  return BlocProvider(
                    create: (context) => ChatCubitFirebase(),
                    child: BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
                      bloc: chatBlocFirebase,
                      listener: (context, state) {},
                      builder: (context, state) {
                        final count = chatBlocFirebase.notificationHomePage
                            .where((element) => element.is_read == '0')
                            .length;
                        return LbeenaAppBarIcon(
                          icon: count > 0
                              ? FontAwesomeIcons.solidBell
                              : FontAwesomeIcons.bell,
                          badge: count,
                          onTap: () {
                            navigatorToPush(
                              context: context,
                              pageName: DIManager.findDep<SharedPrefs>()
                                          .getToken() ==
                                      null
                                  ? LoginScreen(isNeedIconBac: true)
                                  : NotificationPage(),
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LbeenaColors.orange, width: 2),
                  ),
                  child: ClipOval(
                    child: UserImageProfile(
                      imageUrl: imageProfile.toString(),
                      width: 42,
                      height: 42,
                      onTap: () {
                        navigatorToPush(
                          context: context,
                          pageName: DIManager.findDep<SharedPrefs>().getToken() ==
                                  null
                              ? LoginScreen(isNeedIconBac: true)
                              : CompanyDetailsPage(
                                  idCompany: int.parse(userId!),
                                ),
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
    );
  }
}
