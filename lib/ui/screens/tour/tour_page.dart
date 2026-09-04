// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import '../../../core/constants/app_font.dart';
// import '../../../core/di/di_manager.dart';
// import '../../../core/shared_prefs/shared_prefs.dart';
// import '../../../data/models/add_ad_new/category_model.dart';
// import '../../../data/models/home_page/categories_main.dart';
// import '../../../data/models/home_page/home_page_model.dart';
// import '../../../l10n/app_localizations.dart';
// import '../../../widgets/components.dart';
// import '../../app_general_bloc/handel_android_app.dart';
// import '../../theme/theme_helper.dart';
// import '../../widget/post_ad_button.dart';
// import '../auth/login/model_home_page.dart';
//
// class TourPage extends StatefulWidget {
//
//   TourPage(
//       {super.key,
//         this.categoriesMainModel,
//         this.homePageModel,
//         this.adsEvaluationModel,
//         this.adsRandomModel});
//
// HomePageModel? homePageModel;
//   CategoriesAddPostModel? categoriesMainModel;
// HomePageModel? adsRandomModel;
// HomePageModel? adsEvaluationModel;
//   static const routeName = '/tour';
//
//   @override
//   _TourPageState createState() => _TourPageState();
// }
//
// class _TourPageState extends State<TourPage> {
//
// @override
//   void initState() {
//   _initFirebaseMessaging();
//     super.initState();
//   }
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//     Future<void> _initFirebaseMessaging() async {
//
//       if(DIManager.findDep<SharedPrefs>().getToken() == null)
//       {
//         await firebaseMessaging.getToken().then((token) {
//           print("Device token is $token");
//           DIManager.findDep<SharedPrefs>().setDeviceToken(token);
//         }).catchError((e) {
//           print("Error in getting device token: $e");
//         });
//       }
//
//       // Request permission to receive notifications
//       await firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//
//   @override
//   Widget build(BuildContext context) {
//     return HandelAndroidApp(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [
//                         appTheme.lightBlue100,
//                         appTheme.deepPurpleA10001,
//
//                       ],
//                       begin: const FractionalOffset(0.5, 0.4),
//                       end: const FractionalOffset(0.0, 0.9),
//                       stops: [0.0, 1.0],
//                       tileMode: TileMode.clamp)),
//             ),
//             Container(
//               child: IntroScreenDemo(
//                 adsEvaluationModel: widget.adsEvaluationModel,
//                 adsRandomModel: widget.adsRandomModel,
//                 categoriesMainModel: widget.categoriesMainModel,
//                 homePageModel: widget.homePageModel,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class IntroScreenDemo extends StatefulWidget {
//   IntroScreenDemo(
//       {super.key,
//         this.categoriesMainModel,
//         this.homePageModel,
//         this.adsEvaluationModel,
//         this.adsRandomModel});
//
//   HomePageModel? homePageModel;
//   CategoriesAddPostModel? categoriesMainModel;
//   HomePageModel? adsRandomModel;
//   HomePageModel? adsEvaluationModel;
//   @override
//   State<IntroScreenDemo> createState() => _IntroScreenDemoState();
// }
//
// class _IntroScreenDemoState extends State<IntroScreenDemo> {
//   final _introKey = GlobalKey<IntroductionScreenState>();
//   int index = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 135.h, top: 40.h),
//       child: IntroductionScreen(
//         key: _introKey,
//         globalBackgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
//         dotsDecorator: DotsDecorator(
//             size: Size(18.h, 14.h),
//             color: Colors.white,
//             activeSize: Size(45.h, 10.h),
//             activeColor:  appTheme.deepPurpleA10001,
//             activeShape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(25.r)),
//             ),
//             spacing: EdgeInsets.symmetric(horizontal: 2.h)),
//         pages: [
//           PageViewModel(
//
//             titleWidget: Container(
//               height: 190.h,
//               child: Image.asset(
//                 'assets/images/tour_0.png',
//                 fit: BoxFit.fill,
//               ),
//             ),
//
//             bodyWidget:  _buildBodyOnBoarding(
//               text1: AppLocalizations.of(context)!.onboarding_1_text1,
//               text2: AppLocalizations.of(context)!.onboarding_1_text2,
//               text3: AppLocalizations.of(context)!.onboarding_1_text3,
//             ),
//           ),
//           PageViewModel(
//
//             titleWidget: Container(
//               height: 190.h,
//               child: Image.asset(
//                 'assets/images/tour_1.png',
//                 fit: BoxFit.fill,
//               ),
//             ),
//
//             bodyWidget:_buildBodyOnBoarding(
//               text1: AppLocalizations.of(context)!.onboarding_2_text1,
//               text2: AppLocalizations.of(context)!.onboarding_2_text2,
//               text3: AppLocalizations.of(context)!.onboarding_2_text3,
//             ),
//
//           ),
//           PageViewModel(
//             // title: '',
//             // useScrollView: false,useRowInLandscape: false,
//             titleWidget: Container(
//               height: 190.h,
//               child: Image.asset(
//                 'assets/images/tour_3.png',
//                 fit: BoxFit.fill,
//               ),
//             ),
//
//             bodyWidget:  _buildBodyOnBoarding(
//               text1: AppLocalizations.of(context)!.onboarding_3_text1,
//               text2: AppLocalizations.of(context)!.onboarding_3_text2,
//               text3: AppLocalizations.of(context)!.onboarding_3_text3,
//             ),
//
//           ),
//
//         ],
//         globalFooter: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             index == 0 || index == 1
//                 ? NewButton(
//                     text: AppLocalizations.of(context)!.skip,
//                     textStyle: TextStyle(
//                         color: Colors.black,
//                         fontWeight: AppFontWeight.bold,
//                         overflow: TextOverflow.ellipsis),
//                     textPadding:
//                         EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
//                     onPressed: () {
//
//                       navigatorToPushReplacementUntil(
//                           context: context, location: '/homePage',
//                           extra: HomePageLoginModel(
//                       homePageModel: widget.homePageModel,
//                       categoriesMainModel:  widget.categoriesMainModel,
//                       adsRandomModel:  widget.adsRandomModel,
//                       ));
//                       DIManager.findDep<SharedPrefs>().setIsFirst(false);
//                     })
//                 : Container(),
//             SizedBox(
//               width: index == 0 || index == 1 ? 20.w : 167.w,
//             ),
//             NewButton(
//                 text: AppLocalizations.of(context)!.next,
//                 textStyle: TextStyle(
//                     color: Colors.black,
//                     fontWeight: AppFontWeight.bold,
//                     overflow: TextOverflow.ellipsis),
//                 textPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.w),
//                 onPressed: () {
//                   // setState(() => _status = 'Going to the next page...');
//
//                   // 3. Use the `currentState` member to access functions defined in `IntroductionScreenState`
//
//                   print(index);
//                   if (index == 2) {
//                     navigatorToPushReplacementUntil(
//                         context: context, location: '/homePage',extra: HomePageLoginModel(
//                       homePageModel: widget.homePageModel,
//                       categoriesMainModel:  widget.categoriesMainModel,
//                       adsRandomModel:  widget.adsRandomModel,
//
//                     ));
//                     DIManager.findDep<SharedPrefs>().setIsFirst(false);
//                   }else {
//
//                     setState(() {
//                       index++;
//                     });
//                     Future.delayed(const Duration(milliseconds: 50),
//                             () => _introKey.currentState?.next());
//                   }
//                 },
//
//             ),
//           ],
//         ),
//         showSkipButton: false,
//         showNextButton: false,
//         onChange: (v) {
//           setState(() {
//             index = v;
//             print(index);
//           });
//
//           // if(v ==3){
//           //
//           //   navigatorToPushReplacement(
//           //       context: context, pageName: LoginScreen());
//           //   DIManager.findDep<SharedPrefs>().setIsFirst(false);
//           // }
//         },
//         // skip: NewButton(
//         //     text: 'تخطي',
//         //     textStyle: TextStyle(
//         //         color: AppColorsController().white,
//         //         fontWeight: AppFontWeight.bold,
//         //         overflow: TextOverflow.ellipsis),
//         //     textPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         //     onPressed: null),
//         // skipStyle: TextButton.styleFrom(
//         //   foregroundColor: AppColorsController().white,
//         // ),
//         // nextStyle: TextButton.styleFrom(
//         //   foregroundColor: AppColorsController().white,
//         // ),
//         // onDone: (){},
//         overrideDone: Text(''),
//         // next: NewButton(
//         //     text: AppLocalizations.of(context)!.next,
//         //     textStyle:TextStyle(
//         //         color: AppColorsController().white,
//         //         fontWeight: AppFontWeight.bold,
//         //         overflow: TextOverflow.ellipsis),
//         //     textPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         //     onPressed: null),
//         // done: NewButton(
//         //     text: 'التالي',
//         //     textStyle: TextStyle(
//         //         color: AppColorsController().white,
//         //         fontWeight: AppFontWeight.bold,
//         //         overflow: TextOverflow.ellipsis),
//         //     textPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         //     onPressed: null),
//         // doneStyle: TextButton.styleFrom(
//         //   foregroundColor: AppColorsController().white,
//         // ),
//       ),
//     );
//   }
//
//   List<PageViewModel>? pages = [];
//   Widget _buildBodyOnBoarding(
//       {required String text1,
//       required String text2,
//       required String text3,}
//       ){
//
//     return Container(
//       decoration: BoxDecoration(
//         // color: Colors.red, // 50% opacity white color
//         borderRadius: BorderRadius.all(Radius.circular(20.h)),
//         gradient: LinearGradient(
//             colors: [
//               appTheme.lightBlue100,
//               Color(0xffFFFFFF),
//             ],
//             begin: FractionalOffset(0.2, 0.1),
//             end: FractionalOffset(0.2, 1.0),
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white, // Shadow color with opacity
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(-5,
//                 -6), // Shadow position, you can customize it as needed
//           ),
//           BoxShadow(
//             color: Colors.black45, // Shadow color with opacity
//             spreadRadius: 0.2,
//             blurRadius: 5,
//             offset: Offset(4,
//                 5), // Shadow position, you can customize it as needed
//           ),
//         ],
//       ),
//       height: 245.h,
//       width: 270.w,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           textNormal(text: text1 ,
//               // 'نرحب بك في تطبيق هاشتاج',
//               fontSize: AppFontSize.fontSize_18),
//           textNormal(text: text2,
//           // 'ماي بزنس يمكنك التسجيل',
//             color: appTheme.black900.withOpacity(.5),
//             fontSize: AppFontSize.fontSize_18,),
//           textNormal(text: text3,
//           // 'في التطبيق أو الدخول ضيف.',
//             color: appTheme.blue600,
//             fontSize: AppFontSize.fontSize_18,),
//
//         ],
//       ),
//     );
//   }
// }
