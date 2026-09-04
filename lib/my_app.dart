import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/apis_chat_firebase.dart';
import 'package:syrians_in_uae/l10n/l10n.dart';
import 'package:syrians_in_uae/ui/theme/cubit/them_app_cubit.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import 'core/di/di_manager.dart';
import 'core/shared_prefs/shared_prefs.dart';
import 'core/utils/size_utils.dart';
import 'package:flutter/services.dart';
import 'general_app.dart';
import 'package:syrians_in_uae/core/link_app.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> with LifecycleMixin  {
  // This widget is the root of your application.
  @override
  void onAppLifecycleChange(AppLifecycleState state) {
      if(DIManager.findDep<SharedPrefs>().getUserID()!=null){
        if(state==AppLifecycleState.resumed) {
          APIs.updateStatusUser(
            userStatus: state.name.toString(),
          );
        }else{
          APIs.updateStatusUser(
            userStatus: DateTime.now().toString(),
          );
        }

      }

  }

  @override
  void initState() {
    initApp();
    initDeepLinks();
    goRouter;
    if(Platform.isAndroid){
      // enableEdgeToEdge();
    }
    super.initState();
  }
  // void enableEdgeToEdge() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.white, // يجعل شريط الحالة شفافًا
  //     statusBarIconBrightness: Brightness.dark, // تغيير لون الأيقونات تلقائيًا
  //     systemNavigationBarColor: Colors.transparent, // يجعل شريط التنقل السفلي شفافًا
  //     systemNavigationBarIconBrightness: Brightness.dark, // الرموز السفلى سوداء
  //   ));
  // }

  void initApp(){
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    onAppLifecycleChange(AppLifecycleState.resumed);
    if (Platform.isAndroid) {
      // Code for Android devices
      print('This is an Android device.');
      DIManager.findDep<SharedPrefs>().setDeviceType("android");
    } else if (Platform.isIOS) {
      // Code for iOS devices
      print('This is an iOS device.');
      DIManager.findDep<SharedPrefs>().setDeviceType("ios");
    } else {
      // Code for other devices
      print('This is not an Android or iOS device.');
      DIManager.findDep<SharedPrefs>().setDeviceType("iphone");
    }
  }

late AppLinks _appLinks;
StreamSubscription<Uri>? _linkSubscription;


@override
void dispose() {
  _linkSubscription?.cancel();

  super.dispose();
}

Future<void> initDeepLinks() async {
  _appLinks = AppLinks();

  final Uri? initialLink = await _appLinks.getInitialLink();
  //
  if (initialLink!= null) {
    openAppLink(initialLink);
  }
  // Handle links
  _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
    debugPrint('onAppLink: $uri');
    openAppLink(uri);
  });
}
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _appLinks = AppLinks();
  //   _setupDeepLinkHandler();
  // }
  // void _setupDeepLinkHandler() async {
  //   _appLinks.uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       debugPrint('Deep link received: $uri');
  //       _handleDeepLink(uri);
  //     }
  //   }
  //   );
  //   final Uri? initialLink = await _appLinks.getInitialLink();
  //   if (initialLink != null) {
  //     debugPrint('Initial deep link: $initialLink');
  //     _handleDeepLink(initialLink);
  //   }
  // }
  //


  void openAppLink(Uri uri) {
    debugPrint('Received deep link: $uri');

    if (uri.path.contains('/details/')) {
      final segments = uri.pathSegments;
      if (segments.length >= 6) {
        final itemId = segments[1];
        final isBanner = segments[2];
        final idCompany = segments[3];
        final idAds = segments[4];
        final isBannerInOut = segments[5];
        final categoryId = segments[6];
        navigatorKey.currentState!.context.go(
          '/details/$itemId/$isBanner/$idCompany/$idAds/$isBannerInOut/$categoryId',
        );
      }
    } else if (uri.path.contains('/company/') || uri.path.contains('/user/')) {
      final segments = uri.pathSegments;
      navigatorKey.currentState!.context.go(
        '/company/${segments[1]}',
      );
    }
    debugPrint('Unhandled link: $uri');
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(376, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return Sizer(
          builder: (BuildContext context, Orientation orientation, DeviceType1 deviceType) {
            return MultiBlocProvider(
              providers: providersApp,
              child: BlocBuilder<ThemAppCubit, ThemAppState>(
                builder: (context, state) {
                  final themeMode = state is ThemDarkAppState ? ThemeMode.dark : ThemeMode.light;
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    supportedLocales: L10n.all,
                    theme: themeLite,
                    darkTheme: themeDark,
                    themeMode: themeMode,
                    
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: Locale(DIManager.findDep<SharedPrefs>().getLang()),
                    routerConfig: goRouter,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

}


