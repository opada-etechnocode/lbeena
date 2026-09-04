import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syrians_in_uae/ui/app_general_bloc/app_general_cubit.dart';
import 'package:syrians_in_uae/ui/screens/aladhan_time/cubit/aladhan_time_cubit.dart';
import 'package:syrians_in_uae/ui/screens/auth/login/login_screen.dart';
import 'package:syrians_in_uae/ui/screens/auth/login/model_home_page.dart';
import 'package:syrians_in_uae/ui/screens/cart/cubit/cart_cubit.dart';
import 'package:syrians_in_uae/ui/screens/cart/order_page.dart';
import 'package:syrians_in_uae/ui/screens/chats/chat_messages_ad.dart';
import 'package:syrians_in_uae/ui/screens/chats/chats_screen.dart';
import 'package:syrians_in_uae/ui/screens/community/cubit/community_cubit.dart';
import 'package:syrians_in_uae/ui/screens/community/post_screen.dart';
import 'package:syrians_in_uae/ui/screens/company/company_details_page.dart';
import 'package:syrians_in_uae/ui/screens/details_product/details_product.dart';
import 'package:syrians_in_uae/ui/screens/fortune_wheel/cubit/fortune_wheel_cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/home_screen.dart';
import 'package:syrians_in_uae/ui/screens/reminders/cubit/reminder_cubit.dart';
import 'package:syrians_in_uae/ui/screens/reminders/reminder_item.dart';
import 'package:syrians_in_uae/ui/screens/store/cubit/store_cubit.dart';
import 'package:syrians_in_uae/ui/screens/tour/splash_screen_page.dart';
import 'package:syrians_in_uae/ui/theme/cubit/them_app_cubit.dart';
import 'package:nested/nested.dart';
import 'core/di/di_manager.dart';
import 'core/shared_prefs/shared_prefs.dart';
import 'core/utils/endpoints.dart';
import 'data/models/chats/message_model.dart';

List<SingleChildWidget> providersApp =[
  BlocProvider(create: (context) => ThemAppCubit()..changeTheme(ThemeState.initial),),
  BlocProvider(
    create: (context) => HomeCubit(),
    lazy: false,
  ),
  BlocProvider(
    create: (context) {
if(DIManager.findDep<SharedPrefs>().getToken()  == null){
  return CartCubit();
}else{
  return CartCubit()..getMyCart();
}

    },
    lazy: false,
  ),
  BlocProvider(
    create: (context) => CommunityCubit(),
    lazy: false,
  ),
  BlocProvider(
    create: (context) => StoreCubit(),
    lazy: false,
  ),

  BlocProvider(create: (context) =>  FortuneWheelCubit(),lazy: false,),
  BlocProvider(
    create: (context) => ReminderCubit(),
    lazy: false,
  ),
  BlocProvider(
    create: (context) => AppGeneralCubit(),
    lazy: false,
  ),

  BlocProvider(
    create: (context) => AladhanTimeCubit()..getPrayerTimes(DIManager.findDep<SharedPrefs>().getYourCountry()),
    lazy: false,
  ),
];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',

      builder: (context, state) {

        HomePageLoginModel? homePageLoginModel =
        state.extra as HomePageLoginModel?;
        if (homePageLoginModel == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return HomePage(
          // adsRandomModel: homePageLoginModel?.adsRandomModel,
          categoriesMainModel: homePageLoginModel?.categoriesMainModel,
          homePageModel: homePageLoginModel?.homePageModel,
        );
      },
      routes: [
        GoRoute(
          path: 'splash',
          builder: (context, state) => SplashScreen(),
        ),


        GoRoute(
          path: 'details/:itemId/:isBanner/:idCompany/:idAds/:isBannerInOut/:categoryId',
          builder: (context, state) => DetailsProduct(
            idBannerOrProduct: int.parse(state.pathParameters['itemId']!),
            // idBannerOrProduct:  int.parse(state.pathParameters['itemId']!),
            isBanner: bool.parse(state.pathParameters['isBanner']!),
            idAdOnwerCompany: int.parse(state.pathParameters['idCompany']!),
            categoryId: state.pathParameters['categoryId']!.toString(),
            idAds: state.pathParameters['idAds']!,
            adsName: '',
            isBannerInOut:
            int.parse(state.pathParameters['isBannerInOut']!) == 0
                ? false
                : true,
          ),
        ),
        GoRoute(
            path: 'company/:idCompany',
            builder: (context, state) => CompanyDetailsPage(
              idCompany: int.parse(state.pathParameters['idCompany']!),
            )),

        GoRoute(
            path: 'user/:idCompany',
            builder: (context, state) => CompanyDetailsPage(
              idCompany: int.parse(state.pathParameters['idCompany']!),
            )),
        GoRoute(path: 'login', builder: (context, state) => LoginScreen()),
        GoRoute(
          path: 'homePage',
          builder: (context, state) {
            HomePageLoginModel? homePageLoginModel =
            state.extra as HomePageLoginModel?;
            return HomePage(
              // adsRandomModel: homePageLoginModel?.adsRandomModel,
              categoriesMainModel: homePageLoginModel?.categoriesMainModel,
              homePageModel: homePageLoginModel?.homePageModel,
            );
          },
        ),
        GoRoute(
          path: 'chatScreen',
          builder: (context, state) => ChatsScreen(type: 'ads',),
        ),
        GoRoute(
          path: 'postScreen/:idPost',
          builder: (context, state) => PostScreen(
            idPost:int.parse(state.pathParameters['idPost']!),
          ),
        ),

        GoRoute(
          path: 'remindersItem/:idReminder/:reminderOthers',
          builder: (context, state) => RemindersItem(
            idReminder:int.parse(state.pathParameters['idReminder']!),
            reminderOthers:int.parse(state.pathParameters['reminderOthers']!),
          ),
        ),
        GoRoute(
          path:
          'chat/:nameAds/:imageAds/:imageCompany/:imageUser/:nameOwnerAds/:user_name_person_sender/:user_id/:user_id_2/:ad_id/:categoryId/:idBannerOrProduct/:isBanner/:isBannerInOut/:idAdOnwerCompany',
          // path: 'chat/:nameAds/:imageAds',
          builder: (context, state) => ChatMessagesPage(
            dataMessage: ArgumentMessage(
              nameAds: state.pathParameters['nameAds'].toString(),
              imageAds:
              '${AppEndpoints.baseUrlImageFirebase}/img/ad/${state.pathParameters['imageAds']}',
              imageCompany:
              '${AppEndpoints.baseUrlImageFirebase}/img/profile/${state.pathParameters['imageCompany']}',
              imageUser:
              '${AppEndpoints.baseUrlImageFirebase}/img/profile/${state.pathParameters['imageUser']}',
              nameOwnerAds: state.pathParameters['nameOwnerAds'],
              user_name_person_sender:
              state.pathParameters['user_name_person_sender'],
              idAdOnwerCompany: state.pathParameters['idAdOnwerCompany']!,
              user_id: state.pathParameters['user_id'],
              user_id_2: int.parse(state.pathParameters['user_id_2']!),
              ad_id: int.parse(state.pathParameters['ad_id']!),
              categoryId:state.pathParameters['categoryId']!,
              idBannerOrProduct: int.parse(state.pathParameters['idBannerOrProduct']!),
              isBanner: bool.parse(state.pathParameters['isBanner']!),
              isBannerInOut: bool.parse(state.pathParameters['isBannerInOut']!),
            ),
          ),
        ),
        GoRoute(
          path: 'orderPage/:idOrder/:orderType',
          builder: (context, state) => OrderPage(
            idOrderFromNotification: int.parse(state.pathParameters['idOrder']!),
            isMyOrderRequests: state.pathParameters['orderType'] =='incoming'? true:false,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      redirect: (context, state) => '/',
    )
  ],
  redirect: (context, state) {
    // print('state.matchedLocation:${state.matchedLocation}');
    // print(state.uri.queryParameters.length);
    return state.uri.queryParameters['from'];
  },
);