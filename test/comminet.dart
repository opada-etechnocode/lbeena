///TOAST
//void showToast({
//   required String text,
//   required ToastStates state,
// }) =>
//     Fluttertoast.showToast(
//         msg: text,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         timeInSecForIosWeb: 1,
//         backgroundColor:
//         chooseToastColor(state),
//         textColor: Colors.white,
//         fontSize: 16.0);
//
// enum ToastStates { SUCCESS, ERROR, WARNING }
//
// Color chooseToastColor(ToastStates state) {
//   Color? color;
//   switch (state) {
//     case ToastStates.SUCCESS:
//       color = Colors.green;
//       break;
//     case ToastStates.ERROR:
//       color = Colors.red;
//       break;
//     case ToastStates.WARNING:
//       color = Colors.amber;
//       break;
//   }
//   return color;
// }
// void showTopSnackBar() =>  Flushbar(
//   icon: Icon(Icons.error, size: 32, color: Colors.white),
//   shouldIconPulse: false,
//   title: 'Title',
//   message: 'Hello',
//   mainButton: InkWell(
//     child: Text(
//       'Click Me',
//       style: TextStyle(color: Colors.white, fontSize: 16),
//     ),
//     onTap: () {},
//   ),
//   onTap: (_) {
//     print('Clicked bar');
//   },
//   duration: Duration(seconds: 3),
//   flushbarPosition: FlushbarPosition.TOP,
//   margin: EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 0),
//   borderRadius: BorderRadius.circular(16.r),
// );
//
// void showBlurredSnackBar(BuildContext context) => Flushbar(
//   icon: Icon(Icons.error, size: 32, color: Colors.white),
//   shouldIconPulse: false,
//   title: 'Title',
//   message: 'Hello',
//   mainButton: InkWell(
//     child: Text(
//       'Click Me',
//       style: TextStyle(color: Colors.white, fontSize: 16),
//     ),
//     // onPressed: () {},
//   ),
//   onTap: (_) {
//     print('Clicked bar');
//   },
//   padding: EdgeInsets.all(24),
//   flushbarPosition: FlushbarPosition.TOP,
//   margin: EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 0),
//   duration: Duration(seconds: 3),
//   borderRadius: BorderRadius.circular(16.r),
//   barBlur: 20,
//   backgroundColor: Colors.black.withOpacity(0.5),
// )..show(context);
//
// void showDismissSnackBar(BuildContext context) => Flushbar(
//   icon: Icon(Icons.error, size: 32, color: Colors.white),
//   shouldIconPulse: false,
//   title: 'Title',
//   message: 'Hello',
//   mainButton: InkWell(
//     child: Text(
//       'Click Me',
//       style: TextStyle(color: Colors.white, fontSize: 16),
//     ),
//
//   ),
//   onTap: (_) {
//     print('Clicked bar');
//   },
//   flushbarPosition: FlushbarPosition.TOP,
//   margin: EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 0),
//   borderRadius: BorderRadius.circular(16.r),
//   backgroundColor: Colors.blue.withOpacity(0.7),
//   barBlur: 20,
//   padding: EdgeInsets.all(24),
//   animationDuration: Duration(microseconds: 0),
//   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
// )..show(context);
//
// void showGradientSnackBar(BuildContext context) => Flushbar(
//   animationDuration: Duration(microseconds: 0),
//   icon: Icon(Icons.error, size: 32, color: Colors.white),
//   shouldIconPulse: false,
//   title: 'Title',
//   message: 'Hello',
//   mainButton: InkWell(
//     child: Text(
//       'Click Me',
//       style: TextStyle(color: Colors.white, fontSize: 16),
//     ),
//
//   ),
//   padding: EdgeInsets.all(24),
//   flushbarPosition: FlushbarPosition.TOP,
//   margin: EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 0),
//   duration: Duration(seconds: 3),
//   borderRadius: BorderRadius.circular(16.r),
//   backgroundGradient: LinearGradient(
//     colors: [Colors.red, Colors.orange],
//   ),
//   boxShadows: [
//     BoxShadow(
//       color: Colors.red,
//       offset: Offset(2, 2),
//       blurRadius: 8,
//     )
//   ],
// )..show(context);
/// For Ads Random From HomePage
// for (int i = 1;
//     i <= adsRandom.length ||
//         i <= homePageModel!.data!.adsBanner!.data.length;
//     i++) ...[
//   // if ((i + 1) % 6 == 0 && i != adsRandom.length - 1) ...[
//   if (((i) % 6 == 0 && i != adsRandom.length - 1)) ...[
//     if (homePageModel!.data!.adsBanner!.data.isNotEmpty &&
//         (i ~/ 6) + 2 < homePageModel!.data!.adsBanner!.data.length &&
//         i <= adsRandom.length) ...[
//       if ((i ~/ 6) != 1 || (i ~/ 6) != 2) ...[
//         Padding(
//           padding: EdgeInsets.only(bottom: 15.h, top: 5.h),
//           child: _buildBannerItem(
//             context,
//             homePageModel!.data!.adsBanner!
//                 .data[(i ~/ 6) + 2], // تحديد بنر بناءً على i
//           ),
//         )
//       ] else
//         ...[]
//     ] else ...[
//       sizeHeightNormal(),
//     ]
//   ] else ...[
//     // Align(
//     //   alignment: Alignment.center,
//     //   child: GridView.builder(
//     //     shrinkWrap: true,
//     //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     //       mainAxisExtent: 180.h,
//     //       crossAxisCount: 2,
//     //       mainAxisSpacing: 22.h,
//     //       crossAxisSpacing: 22.h,
//     //     ),
//     //     physics: NeverScrollableScrollPhysics(),
//     //     itemCount: adsRandom!.length,
//     //     itemBuilder: (context, index) {
//     //       return GestureDetector(
//     //           onTap: () {
//     //
//     //
//     //             navigatorToPush(
//     //                 context: context,
//     //                 pageName: DetailsProduct(
//     //                   idProduct: int.parse(adsRandom[index].adsId! ),
//     //                   detailsProduct: adsRandom[index],
//     //                   // detailsProduct: ,
//     //                   // idProduct: int.parse(data.data[index].adsId!),
//     //                 ));
//     //           },
//     //           child: AdsProductWidget(
//     //             dataProductItem: adsRandom[index],
//     //           ));
//     //     },
//     //   ),
//     // ),
//
//     if (i > adsRandom.length &&
//         isShowAllBanner &&
//         (i ~/ 6) + adsRandom.length -1== i) ...[
//       for (int j = (i ~/ 6) + 3;
//           j < homePageModel!.data!.adsBanner!.data.length;
//           j++) ...[
//         // textNormal(
//         //     text: homePageModel!.data!.adsBanner!.data[j].bannerId
//         //         .toString()),
//         // textNormal(text: j.toString()),
//         // textNormal(text: i.toString()),
//         Padding(
//           padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
//           child: _buildBannerItem(
//             context,
//             homePageModel!
//                 .data!.adsBanner!.data[j], // تحديد بنر بناءً على i
//           ),
//         )
//       ],
//     ],
//     Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       child: Row(
//         // crossAxisAlignment:i%2== 0? CrossAxisAlignment.start:CrossAxisAlignment.end,
//         // mainAxisAlignment:i%2== 0?  MainAxisAlignment.start:MainAxisAlignment.end,
//         children: [
//           if (i <= adsRandom.length) ...[
//             i % 2 != 0
//                 ? GestureDetector(
//                     onTap: () {
//                       navigatorToPush(
//                           context: context,
//                           pageName: DetailsProduct(
//                             idProduct:
//                                 int.parse(adsRandom[i - 1].adsId!),
//                             detailsProduct: adsRandom[i - 1],
//                             // detailsProduct: ,
//                             // idProduct: int.parse(data.data[index].adsId!),
//                           ));
//                     },
//                     child: AdsProductWidget(
//                       dataProductItem: adsRandom[i - 1],
//                     ))
//                 : Container(),
//             sizeWidthNormal(width: 15.h),
//             if (i < adsRandom.length) ...[
//               i % 2 != 0
//                   ? GestureDetector(
//                       onTap: () {
//                         navigatorToPush(
//                             context: context,
//                             pageName: DetailsProduct(
//                               idProduct: int.parse(adsRandom[i].adsId!),
//                               detailsProduct: adsRandom[i],
//                               // detailsProduct: ,
//                               // idProduct: int.parse(data.data[index].adsId!),
//                             ));
//                       },
//                       child: AdsProductWidget(
//                         dataProductItem: adsRandom[i],
//                       ))
//                   : Container(),
//             ]
//           ],
//         ],
//       ),
//     ),
//     sizeHeightNormal(),
//   ],
// ],

/// GridView.builder
// Align(
//   alignment: Alignment.center,
//   child: GridView.builder(
//     shrinkWrap: true,
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       mainAxisExtent: 180.h,
//       crossAxisCount: 2,
//       mainAxisSpacing: 22.h,
//       crossAxisSpacing: 22.h,
//     ),
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: adsRandom!.length,
//     itemBuilder: (context, index) {
//       return GestureDetector(
//           onTap: () {
//
//
//             navigatorToPush(
//                 context: context,
//                 pageName: DetailsProduct(
//                   idProduct: int.parse(adsRandom[index].adsId! ),
//                   detailsProduct: adsRandom[index],
//                   // detailsProduct: ,
//                   // idProduct: int.parse(data.data[index].adsId!),
//                 ));
//           },
//           child: AdsProductWidget(
//             dataProductItem: adsRandom[index],
//           ));
//     },
//   ),
// ),
//
//   /// Section Widget
//   Widget _buildAdsEvaluation(BuildContext context, { String? text,MergedData? list,}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.h),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: EdgeInsets.only(left: 2.h, bottom: 20.h),
//               child: Text(
//                 text.toString(),
//                 style: themeLite.textTheme.titleMedium,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: GridView.builder(
//               shrinkWrap: true,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 mainAxisExtent: 196.v,
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 22.h,
//                 crossAxisSpacing: 22.h,
//               ),
//               physics: NeverScrollableScrollPhysics(),
//               itemCount:  list!.data.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                     onTap: () {
//                       navigatorToPush(
//                           context: context, pageName: DetailsProduct(
//                         // detailsProduct:list,
// idProduct: int.parse(list.data![index].adId! ),
//                       ));
//                     },
//                     child: AdsProductWidget(
//                       dataProductItem:list.data[index],
//                       isFromEvaluation: true,
//                     ));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
///Counter Animations
// Container(
//   width: 250.h,
//   height: 300.h,
//   color:Colors.cyan,
//   child: _controller.value.isInitialized
//       ? AspectRatio(
//     aspectRatio: _controller.value.aspectRatio,
//     child: VideoPlayer(_controller),
//   )
//       : Container(),
// ),
//
//  IconButton(onPressed: (){
//    setState(() {
//      _controller.value.isPlaying
//          ? _controller.pause()
//          : _controller.play();
//    });
//  }, icon: Icon(Icons.play_circle)),

// VimeoVideoPlayer(
//   url: 'https://vimeo.com/70591644',
// ),
///
//AnimationController? _controller;
//   Animation<double>? _animation;
//   @override
//   void dispose() {
//     _controller!.dispose(); // Dispose of the animation controller when not needed
//     super.dispose();
//   }
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 100 *(int.parse(widget.detailsProductFromBanner?.clicks ?? widget.detailsProduct?.clicks ?? 1))), // Duration of the counter in seconds
//     );
//     _animation = Tween<double>(begin: 0, end: double.parse(widget.detailsProductFromBanner?.clicks ?? widget.detailsProduct?.clicks ?? '0')).animate(_controller!)
//       ..addListener(() {
//         setState(() {}); // Rebuild the UI when the counter changes
//       });
//     _controller!.forward(); // Start the counter
//   }

///HTML
//  Future<void> fetchHTML() async {
//     try {
//       var response = await Dio().get('https://hashtag-mybusiness.com/faq.html');
//       setState(() {
//         htmlContent = response.data.toString();
//       });
//     } catch (e) {
//       print('Error fetching HTML: $e');
//     }
//   }
///
///
// <key>NSContactsUsageDescription</key>
// 	<string>App requires access to your contacts to help you find friends who are using this app. Your contacts will not be shared with any third parties.</string>
//