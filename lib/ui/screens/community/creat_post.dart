// import 'dart:async';
// import 'dart:io';
//
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:syrians_in_uae/core/utils/size_utils.dart';
// import 'package:syrians_in_uae/core/utils/endpoints.dart';
// import 'package:syrians_in_uae/ui/screens/community/search_post_screen.dart';
// import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
// import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
// import 'package:syrians_in_uae/widgets/custom_image_view.dart';
// import 'package:syrians_in_uae/widgets/loader_for_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:record/record.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_font.dart';
// import '../../../core/di/di_manager.dart';
// import '../../../core/helper/snack_bar_helper.dart';
// import '../../../core/shared_prefs/shared_prefs.dart';
// import '../../../core/utils/image_constant.dart';
// import '../../../data/models/community/community_post_model.dart';
// import '../../../data/models/community/hashtag_model.dart';
// import '../../../data/models/parts_voice/common.dart';
// import '../../../widgets/smart_refresh_widget.dart';
// import '../auth/login/login_screen.dart';
// import '../chats/chat_messages_ad.dart';
// import '../../../widgets/community_shimmer.dart';
// import '../../../widgets/components.dart';
// import '../../../widgets/custom_text_form_field.dart';
// import '../../../widgets/file_compress.dart';
// import '../../theme/app_decoration.dart';
// import '../l10n/app_localizations.dart';
// import '../add_ads/add_ads.dart';
// import '../parts_voice/parts_voice_page.dart';
// import '../parts_voice/widget/control_button.dart';
// import 'cubit/community_cubit.dart';
// import 'list_coummunity.dart';
//
// import 'package:rxdart/rxdart.dart';
// import 'package:audio_session/audio_session.dart';
// class CreatePost extends StatefulWidget {
//   const CreatePost();
//
//   @override
//   State<CreatePost> createState() => _CreatePostState();
// }
//
// class _CreatePostState extends State<CreatePost>
//     with AutomaticKeepAliveClientMixin {
//   TextEditingController controller = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController? controllerUrlAds = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   bool get wantKeepAlive => true;
//
//   List<String> idHashtag = [];
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   final FocusNode _secondFocusNode = FocusNode();
//   List<CommunityModelDatum>? communityPostModel = [];
//   // bool isLoading = true;
//   int page = 1;
//   bool isLoadingHashtag = true;
//   bool isError = false;
//   List<bool> isSelectAvailableList =
//       List.generate(100, (index) => index == 0 ? true : false);
//   int checkIndexColors = 6;
//
//   // String colorsChoose =  DIManager.findDep<SharedPrefs>().getThemeApp() == 'd' ?'#202326': '#A0DDFD' ;
//   String colorsChoose = 'null';
//   AllHashtagModel? allHashtagModel;
//   int isHaveComment = 1;
//   List<String> colorsBackground = [];
//
//   bool _isSwitched = true;
//
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final AudioRecorder _recorder = AudioRecorder();
//   bool _isRecording = false;
//   String? _filePath;
//   double _currentPosition = 0;
//   double _totalDuration = 0;
//   bool _isRecordingForTextFormFiled = false;
//   bool _isStopRecording = false;
//   bool _isDoneRecording = false;
//
//   Future<void> _startRecording() async {
//     // التحقق من إذن الوصول إلى الميكروفون
//     final bool isPermissionGranted = await _recorder.hasPermission();
//     if (!isPermissionGranted) {
//       print('Permission not granted for recording.');
//       return;
//     }
//
//     // بدء المؤقت
//     startTimer();
//
//     // إعداد المتغيرات المبدئية
//     _isStopRecording = false;
//
//     // تحديد مسار الملف في دليل المستندات
//     final directory = await getApplicationDocumentsDirectory();
//     String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
//     _filePath = '${directory.path}/$fileName';
//
//     // إعدادات التسجيل
//     const config = RecordConfig(
//       encoder: AudioEncoder.aacLc, // استخدام ترميز AAC
//       sampleRate: 22050,           // معدل العينات
//       bitRate: 32000,              // معدل البت
//     );
//
//     try {
//       // بدء التسجيل
//       await _recorder.start(config, path: _filePath!);
//
//       // تحديث حالة التسجيل
//       setState(() {
//         _isRecording = true;
//         _isRecordingForTextFormFiled = true;
//       });
//
//       print('Recording started. File path: $_filePath');
//       print('Time Voice: ${DIManager.findDep<SharedPrefs>().getTimeVoice()}');
//
//       // إيقاف التسجيل تلقائيًا بعد الوقت المحدد
//       Future.delayed(
//         Duration(minutes: DIManager.findDep<SharedPrefs>().getTimeVoice()),
//             () async {
//           await _stopRecording();
//         },
//       );
//     } catch (e) {
//       print('Error while starting recording: $e');
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     try {
//       // إيقاف التسجيل واسترجاع مسار الملف
//       final path = await _recorder.stop();
//       stopTimer();
//
//       // التحقق من أن الملف تم تسجيله بنجاح
//       if (_filePath != null) {
//         // إعداد MediaItem لمصدر الصوت
//         final mediaItem = MediaItem(
//           id: _filePath!,
//           album: "Recording Album",
//           title: "Recording Title",
//           artist: "Unknown",
//           duration: null, // يمكن تحديث المدة لاحقًا بعد تحميل الملف
//         );
//
//         // ضبط AudioSource مع MediaItem
//         await _audioPlayer.setAudioSource(
//           AudioSource.uri(
//             Uri.file(_filePath!),
//             tag: mediaItem,
//           ),
//         );
//
//         // تحديث إجمالي مدة الصوت
//         _totalDuration = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
//
//         print('Recording stopped. File saved at: $_filePath');
//       } else {
//         print('Recording stopped, but file path is null.');
//       }
//
//       // تحديث حالة التسجيل
//       setState(() {
//         _isRecording = false;
//         _isStopRecording = true;
//         _isDoneRecording = true;
//       });
//     } catch (e) {
//       print('Error while stopping recording: $e');
//
//       // إعادة تعيين الحالات عند حدوث خطأ
//       setState(() {
//         _isRecording = false;
//         _isStopRecording = false;
//         _isDoneRecording = false;
//       });
//     }
//   }
//
//   Timer? _timer;
//   double _recordingTime = 0;
//
//   void startTimer() {
//     _recordingTime = 0;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _recordingTime++;
//       });
//     });
//   }
//
//   void stopTimer() {
//     if (_timer != null) {
//       _timer!.cancel();
//     }
//   }
//
//   bool isPlaying = true;
//
//   Future<void> _playRecording() async {
//     if (_filePath != null) {
//       setState(() {
//         isPlaying = false;
//       });
//
//       // إعداد MediaItem لمصدر الصوت
//       final mediaItem = MediaItem(
//         id: _filePath!,
//         album: "Recording Album",
//         title: "Recording Title",
//         artist: "Unknown",
//         duration: Duration(seconds: _totalDuration.toInt()),
//       );
//
//       // ضبط AudioSource مع MediaItem
//       await _audioPlayer.setAudioSource(
//         AudioSource.uri(
//           Uri.file(_filePath!),
//           tag: mediaItem,
//         ),
//       );
//
//       // إعداد المدة الإجمالية
//       _totalDuration = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
//
//       // بدء التشغيل
//       _audioPlayer.play();
//
//       // الاستماع لموضع التشغيل لتحديث _currentPosition
//       _audioPlayer.positionStream.listen((position) {
//         setState(() {
//           _currentPosition = position.inSeconds.toDouble();
//         });
//       });
//
//       // التحقق من نهاية التشغيل
//       _audioPlayer.positionStream.listen((event) {
//         if (event.inSeconds == _totalDuration) {
//           setState(() {
//             isPlaying = true;
//           });
//         }
//       });
//     }
//   }
//
//   Future<void> _stopPlay() async {
//     if (_filePath != null) {
//       await _audioPlayer.stop();
//       setState(() {
//         isPlaying = true;
//         // _currentPosition = 0; // إذا كنت تريد إعادة الموضع إلى البداية
//       });
//     }
//   }
//
//   restartPlay() {
//     setState(() {
//       _isDoneRecording = false;
//       _isStopRecording = false;
//       isPlaying = true;
//       _isRecordingForTextFormFiled = false;
//       _isRecording = false;
//       _filePath = null;
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     _audioPlayer.dispose();
//     _recorder.dispose();
//     super.dispose();
//   }
//   Stream<PositionData> get _positionDataStream =>
//       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//           _audioPlayer.positionStream,
//           _audioPlayer.bufferedPositionStream,
//           _audioPlayer.durationStream,
//               (position, bufferedPosition, duration) => PositionData(
//               position, bufferedPosition, duration ?? Duration.zero));
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//       child: BlocProvider(
//         create: (context) => CommunityCubit()
//           ..getAllCommunityPost(page: 1)
//           ..getAllHashtagPost(),
//         child: BlocConsumer<CommunityCubit, CommunityState>(
//           listener: (context, state) {
//
//
//             if (state is SuccessGetAllHashtagPostState) {
//               allHashtagModel = state.data;
//               if (allHashtagModel!.hashtag.isNotEmpty) {
//                 idHashtag.add(allHashtagModel!.hashtag.first.id!);
//               }
//               isLoadingHashtag = false;
//             }
//
//             if (state is LoadingGetAllHashtagPostState) {
//               isLoadingHashtag = true;
//             }
//
//
//
//             if (state is ErrorCreatePostState) {
//               SnackBarHelper.mySnackBarError(state.message, context);
//             }
//
//             if (state is SuccessCreatePostState) {
//               controller.clear();
//               controllerUrlAds!.clear();
//               _imagesAddProduct = null;
//               checkBoxIndex = 4;
//               checkIndexColors = 0;
//               _isSwitched = true;
//               isHaveComment = 1;
//               colorsChoose =
//                   colorWithoutHashtag(allHashtagModel!.color[0].color1!);
//               SnackBarHelper.mySnackBarSuccess(
//                   'شكراً لمشاركتك ،سيظهر منشورك بعد أن تتم الموافقة عليه',
//                   context);
//             }
//
//
//           },
//           builder: (context, state) {
//             // BlocProvider.of<CommunityCubit>(context,listen: false).refreshAllCommunityPost();
//             return isLoadingHashtag ?Container()
//                 : Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // if (DIManager.findDep<SharedPrefs>()
//                   //         .getToken() ==
//                   //     null) ...{
//                   //   Container(
//                   //     height: 58.h,
//                   //     padding: EdgeInsets.symmetric(
//                   //         horizontal: 10.w, vertical: 5.h),
//                   //     color: appTheme.deepPurpleA10001,
//                   //     child: SizedBox(
//                   //       height: 25.h,
//                   //       child: Marquee(
//                   //         textDirection: lang == 'ar'
//                   //             ? TextDirection.ltr
//                   //             : TextDirection.ltr,
//                   //         text:
//                   //             '    من أجل النشر والتفاعل عليك تسجيل الدخول أولاً',
//                   //         style: Theme.of(context)
//                   //             .textTheme
//                   //             .bodyMedium!
//                   //             .copyWith(
//                   //               color: Colors.white,
//                   //           fontSize: AppFontSize.fontSize_12,
//                   //             ),
//                   //       ),
//                   //     ),
//                   //   )
//                   // } else ...{
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: DIManager.findDep<SharedPrefs>()
//                         .getThemeApp() ==
//                         'd'
//                         ? appTheme.borderImageColor
//                         : Colors.grey.withOpacity(.3),
//                     child: Column(
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: [
//                         sizeHeightNormal(height: 10.h),
//                         Stack(
//                           alignment: Alignment.topRight,
//                           children: [
//                             TextFormField(
//                               controller: controller,
//                               focusNode: _focusNode,
//                               maxLines: null,
//                               maxLength: 1000,
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 icon: Container(
//                                   width: 2.w,
//                                 ),
//                                 hintText: DIManager.findDep<
//                                     SharedPrefs>()
//                                     .getToken() ==
//                                     null
//                                     ? "يجب تسجيل الدخول حتى تستطيع المشاركة .."
//                                     : 'ماذا يخطر في بالك ..',
//                                 hintStyle: TextStyle(
//                                   fontSize: 12.sp,
//                                 ),
//                                 counterStyle: TextStyle(
//                                   color: appTheme.black900,
//                                 ),
//                                 contentPadding:
//                                 EdgeInsets.symmetric(
//                                     vertical: 2.h,
//                                     horizontal: 20.h),
//                               ),
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   // aboutMeValue = value;
//                                 });
//                               },
//                             ),
//                             Positioned(
//                               // left: 0,
//                               right: 7.w,
//                               top: 11.h,
//                               child: CustomImageView(
//                                 imagePath: DIManager.findDep<
//                                     SharedPrefs>()
//                                     .getImageProfile()
//                                     .toString()
//                                     .contains('http')
//                                     ? DIManager.findDep<
//                                     SharedPrefs>()
//                                     .getImageProfile()
//                                     .toString()
//                                     : AppEndpoints
//                                     .baseUrlWithoutApi +
//                                     DIManager.findDep<
//                                         SharedPrefs>()
//                                         .getImageProfile()
//                                         .toString(),
//                                 height: 26.h,
//                                 width: 26.h,
//                                 radius: BorderRadius.circular(
//                                     900.r),
//                                 fit: BoxFit.fill,
//                                 placeHolder:
//                                 ImageConstant.imgPerson,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                             width: 350.w,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 0.w,
//                                   vertical: 5.h),
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment
//                                         .start,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.start,
//                                     children: [
//                                       checkBoxIcon(
//                                         text: 'منشور نصي',
//                                         isChecked:
//                                         checkBoxIndex == 0
//                                             ? true
//                                             : false,
//                                         onPressed: () {
//                                           setState(() {
//                                             if (checkBoxIndex !=
//                                                 0) {
//                                               checkBoxIndex = 0;
//                                             } else {
//                                               checkBoxIndex = 4;
//                                             }
//                                           });
//                                         },
//                                       ),
//                                       checkBoxIndex == 0
//                                           ? Padding(
//                                         padding: EdgeInsets
//                                             .only(
//                                             top:
//                                             12.h),
//                                         child: Row(
//                                           children: [
//                                             InkWell(
//                                               onTap: () {
//                                                 setState(
//                                                         () {
//                                                       checkIndexColors =
//                                                       0;
//                                                       colorsChoose = allHashtagModel!
//                                                           .color[0]
//                                                           .color1!;
//                                                       // colorsChoose = '0xfff52323';
//                                                     });
//                                               },
//                                               child:
//                                               Stack(
//                                                 alignment:
//                                                 Alignment
//                                                     .center,
//                                                 children: [
//                                                   Container(
//                                                     height:
//                                                     20.h,
//                                                     width:
//                                                     20.h,
//                                                     color:
//                                                     Color(int.parse('0xff${colorWithoutHashtag(allHashtagModel?.color[0].color1 ?? colorsChoose)}')),
//                                                   ),
//                                                   if (checkIndexColors ==
//                                                       0)
//                                                     Icon(
//                                                       Icons.check_box_outlined,
//                                                       color:
//                                                       Colors.white70,
//                                                       size:
//                                                       25.h,
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                             sizeWidthNormal(),
//                                             InkWell(
//                                               onTap: () {
//                                                 setState(
//                                                         () {
//                                                       checkIndexColors =
//                                                       1;
//                                                       colorsChoose = allHashtagModel!
//                                                           .color[0]
//                                                           .color2!;
//
//                                                       // colorsChoose = '0xffF5A623';
//                                                     });
//                                               },
//                                               child:
//                                               Stack(
//                                                 alignment:
//                                                 Alignment
//                                                     .center,
//                                                 children: [
//                                                   Container(
//                                                     height:
//                                                     20.h,
//                                                     width:
//                                                     20.h,
//                                                     color:
//                                                     Color(int.parse('0xff${colorWithoutHashtag(allHashtagModel!.color[0].color2 ?? colorsChoose)}')),
//                                                   ),
//                                                   if (checkIndexColors ==
//                                                       1)
//                                                     Icon(
//                                                       Icons.check_box_outlined,
//                                                       color:
//                                                       Colors.white70,
//                                                       size:
//                                                       25.h,
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                             sizeWidthNormal(),
//                                             InkWell(
//                                               onTap: () {
//                                                 setState(
//                                                         () {
//                                                       checkIndexColors =
//                                                       2;
//                                                       // colorsChoose = '0xff6819b1';
//                                                       colorsChoose = allHashtagModel!
//                                                           .color[0]
//                                                           .color3!;
//                                                     });
//                                               },
//                                               child:
//                                               Stack(
//                                                 alignment:
//                                                 Alignment
//                                                     .center,
//                                                 children: [
//                                                   Container(
//                                                     height:
//                                                     20.h,
//                                                     width:
//                                                     20.h,
//                                                     color:
//                                                     Color(int.parse('0xff${colorWithoutHashtag(allHashtagModel!.color[0].color3 ?? colorsChoose)}')),
//                                                   ),
//                                                   if (checkIndexColors ==
//                                                       2)
//                                                     Icon(
//                                                       Icons.check_box_outlined,
//                                                       color:
//                                                       Colors.white70,
//                                                       size:
//                                                       25.h,
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                           : Container(),
//                                     ],
//                                   ),
//                                   Row(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment
//                                         .center,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.start,
//                                     children: [
//                                       checkBoxIcon(
//                                         text: 'يحتوي فيديو',
//                                         isChecked:
//                                         checkBoxIndex == 1
//                                             ? true
//                                             : false,
//                                         onPressed: () {
//                                           setState(() {
//                                             if (checkBoxIndex !=
//                                                 1) {
//                                               checkBoxIndex = 1;
//                                             } else {
//                                               checkBoxIndex = 4;
//                                             }
//                                           });
//                                         },
//                                       ),
//                                       sizeWidthNormal(),
//                                       checkBoxIndex == 1
//                                           ? CustomTextFormField(
//                                         width: 200.w,
//                                         contentPadding:
//                                         EdgeInsets.symmetric(
//                                             horizontal:
//                                             10.w,
//                                             vertical:
//                                             10.h),
//                                         focusNode:
//                                         _secondFocusNode,
//                                         hintText:
//                                         AppLocalizations.of(
//                                             context)!
//                                             .link_hint,
//                                         controller:
//                                         controllerUrlAds,
//                                         validator:
//                                             (text) {
//                                           if (text ==
//                                               null ||
//                                               text.isEmpty) {
//                                             return AppLocalizations.of(
//                                                 context)!
//                                                 .field_is_empty;
//                                           }
//
//                                           if (isURLValid(
//                                               text) !=
//                                               true) {
//                                             return AppLocalizations.of(
//                                                 context)!
//                                                 .should_link_active;
//                                           }
//
//                                           return null;
//                                         },
//                                       )
//                                           : Container(),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       checkBoxIcon(
//                                         text: 'يحتوي صورة',
//                                         isChecked:
//                                         checkBoxIndex == 2
//                                             ? true
//                                             : false,
//                                         onPressed: () {
//                                           setState(() {
//                                             if (checkBoxIndex !=
//                                                 2) {
//                                               checkBoxIndex = 2;
//                                             } else {
//                                               checkBoxIndex = 4;
//                                             }
//                                           });
//                                         },
//                                       ),
//                                       Spacer(),
//                                       checkBoxIcon(
//                                         text: 'يحتوي صوت',
//                                         isChecked:
//                                         checkBoxIndex == 3
//                                             ? true
//                                             : false,
//                                         onPressed: () {
//                                           setState(() {
//                                             if (checkBoxIndex !=
//                                                 3) {
//                                               checkBoxIndex = 3;
//                                             } else {
//                                               checkBoxIndex = 4;
//                                             }
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             )),
//                         isLoadingHashtag
//                             ? Container()
//                             :
//                         // Align(
//                         //         alignment:
//                         //             Alignment.bottomCenter,
//                         //         child: Container(
//                         //           width: 400.w,
//                         //           height: 100.h,
//                         //           child: GridView.builder(
//                         //             scrollDirection:
//                         //                 Axis.vertical,
//                         //             itemCount:
//                         //                 allHashtagModel!
//                         //                     .hashtag!.length,
//                         //             gridDelegate:
//                         //                 SliverGridDelegateWithFixedCrossAxisCount(
//                         //               crossAxisCount: 3,
//                         //               childAspectRatio: 2,
//                         //               mainAxisSpacing: 5.w,
//                         //               mainAxisExtent: 30.h,
//                         //             ),
//                         //             itemBuilder:
//                         //                 (context, index) {
//                         //               return InkWell(
//                         //                 onTap: () {
//                         //                   if (!isSelectAvailableList[
//                         //                       index]) {
//                         //                     idHashtag.add(
//                         //                         allHashtagModel!
//                         //                             .hashtag[
//                         //                                 index]
//                         //                             .id!);
//                         //                   } else {
//                         //                     idHashtag.remove(
//                         //                         allHashtagModel!
//                         //                             .hashtag[
//                         //                                 index]
//                         //                             .id!);
//                         //                   }
//                         //                   setState(() {
//                         //                     isSelectAvailableList[
//                         //                             index] =
//                         //                         !isSelectAvailableList[
//                         //                             index];
//                         //                   });
//                         //                 },
//                         //                 child: Container(
//                         //                   padding: EdgeInsets
//                         //                       .symmetric(
//                         //                           vertical:
//                         //                               5.h,
//                         //                           horizontal:
//                         //                               5.w),
//                         //                   decoration:
//                         //                       BoxDecoration(
//                         //                     color: !isSelectAvailableList[
//                         //                             index]
//                         //                         ? Colors.grey
//                         //                         : appTheme
//                         //                             .deepPurpleA100,
//                         //                     borderRadius:
//                         //                         BorderRadius
//                         //                             .circular(
//                         //                                 20.r),
//                         //                   ),
//                         //                   child: Center(
//                         //                     child: textNormal(
//                         //                       text: allHashtagModel!
//                         //                           .hashtag[
//                         //                               index]
//                         //                           .hashtag!,
//                         //                       fontSize:
//                         //                           AppFontSize.fontSize_12,
//                         //                     ),
//                         //                   ),
//                         //                 ),
//                         //               );
//                         //             },
//                         //           ),
//                         //         ),
//                         //       ),
//                         Padding(
//                           padding:  EdgeInsets.symmetric(horizontal: 10.w),
//                           child: Wrap(
//                             spacing: 8.0,
//                             // المسافة الأفقية بين الويدجتات
//                             runSpacing: 4.0,
//                             // المسافة العمودية بين السطور
//                             children: <Widget>[
//                               for (int index = 0;
//                               index <
//                                   allHashtagModel!
//                                       .hashtag!.length;
//                               index++)
//                                 InkWell(
//                                   onTap: () {
//                                     if (!isSelectAvailableList[
//                                     index]) {
//                                       idHashtag.add(
//                                           allHashtagModel!
//                                               .hashtag[
//                                           index]
//                                               .id!);
//                                       print(idHashtag);
//                                     } else {
//                                       idHashtag.remove(
//                                           allHashtagModel!
//                                               .hashtag[
//                                           index]
//                                               .id!);
//                                     }
//                                     setState(() {
//                                       isSelectAvailableList[
//                                       index] =
//                                       !isSelectAvailableList[
//                                       index];
//                                     });
//                                   },
//                                   child: Chip(
//                                     backgroundColor:
//                                     !isSelectAvailableList[
//                                     index]
//                                         ? Colors.grey
//                                         : appTheme
//                                         .deepPurpleA100,
//                                     // avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
//                                     label: textNormal(
//                                       text: allHashtagModel!
//                                           .hashtag[index]
//                                           .hashtag!,
//                                       fontSize: AppFontSize
//                                           .fontSize_12,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h
//                           ),
//                           child: Row(
//                             children: [
//                               // Spacer(),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   textNormal(
//                                     text: 'تفعيل التعليقات',
//                                     fontSize:
//                                     AppFontSize.fontSize_11,
//                                   ),
//                                   Switch(
//                                     value: _isSwitched,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _isSwitched =
//                                         !_isSwitched;
//                                         if (_isSwitched) {
//                                           isHaveComment = 1;
//                                         } else {
//                                           isHaveComment = 0;
//                                         }
//                                         print(isHaveComment);
//                                       });
//                                     },
//
//                                     activeColor: Colors.white,
//                                     // inactiveThumbColor: appTheme.white,
//                                     inactiveTrackColor:
//                                     Colors.grey,
//                                     activeTrackColor:
//                                     Colors.green,
//                                     trackOutlineWidth:
//                                     MaterialStateProperty
//                                         .all(3),
//
//                                     materialTapTargetSize:
//                                     MaterialTapTargetSize
//                                         .shrinkWrap,
//                                     trackOutlineColor:
//                                     MaterialStateColor.resolveWith(
//                                             (states) => appTheme
//                                             .scaffoldBackgroundColor100),
//                                   ),
//                                 ],
//                               ),
//                               Spacer(),
//                               sizeWidthNormal(),
//                               checkBoxIndex == 2
//                                   ? _addImage()
//                                   : Container(),
//                               sizeWidthNormal(),
//                               if (checkBoxIndex == 3) ...[
//                                 if (DIManager.findDep<
//                                     SharedPrefs>()
//                                     .getToken() ==
//                                     null) ...{
//                                   MaterialButton(
//                                     onPressed: () {
//                                       navigatorToPush(
//                                           context: context,
//                                           pageName: LoginScreen(
//                                             isNeedIconBac: true,
//                                           ));
//                                     },
//                                     minWidth: 0,
//                                     padding: EdgeInsets.only(
//                                         top: 10.h,
//                                         bottom: 10.h,
//                                         right: 10.w,
//                                         left: 10.w),
//                                     shape: const CircleBorder(),
//                                     color: Colors.green,
//                                     child: Icon(Icons.mic_none,
//                                         color: Colors.white,
//                                         size: 28.fSize),
//                                   ),
//                                 } else ...{
//                                   state is LoadingCreatePostState
//                                       ? loaderNormal()
//                                       : MaterialButton(
//                                     onPressed: _isDoneRecording
//                                         ? () async {
//                                       _stopPlay();
//                                       if (_filePath !=
//                                           null) {
//                                         _isDoneRecording =
//                                         false;
//                                         _isStopRecording =
//                                         false;
//                                         isPlaying =
//                                         true;
//                                         _isRecordingForTextFormFiled =
//                                         false;
//                                         _isRecording =
//                                         false;
//                                         // await chatBlocFirebase.sendChatVoice(
//                                         //     DIManager.findDep<SharedPrefs>()
//                                         //         .getUserID()
//                                         //         .toString(),
//                                         //     File(_filePath!));
//                                       }
//                                       // sendNotifications(
//                                       //   massage: 'صوت',
//                                       // );
//
//                                       BlocProvider.of<CommunityCubit>(context).createPost(
//                                           content:
//                                           controller
//                                               .text,
//                                           hashtags:
//                                           idHashtag,
//                                           isHaveComment:
//                                           isHaveComment,
//                                           voice_time:
//                                           _totalDuration
//                                               .toString(),
//                                           type: 'D',
//                                           voice: File(
//                                               _filePath!));
//
//                                       ///
//                                     }
//                                         : _isRecording
//                                         ? _stopRecording
//                                         : _startRecording,
//                                     minWidth: 0,
//                                     padding:
//                                     EdgeInsets.only(
//                                         top: 10.h,
//                                         bottom: 10.h,
//                                         right: 10.w,
//                                         left: 10.w),
//                                     shape:
//                                     const CircleBorder(),
//                                     color:
//                                     _isDoneRecording
//                                         ? Colors.green
//                                         : _isRecording
//                                         ? Colors
//                                         .red
//                                         : Colors
//                                         .green,
//                                     child: Icon(
//                                         _isDoneRecording
//                                             ? Icons.send
//                                             : _isRecording
//                                             ? Icons
//                                             .mic
//                                             : Icons
//                                             .mic_none,
//                                         color:
//                                         Colors.white,
//                                         size: 28.fSize),
//                                   ),
//                                 },
//                               ] else ...[
//                                 state is LoadingCreatePostState
//                                     ? loaderNormal()
//                                     : Padding(
//                                   padding:  EdgeInsets.symmetric(vertical: 4.5.h),
//                                   child: CustomElevatedButton(
//                                       text: 'نشر',
//                                       onPressed: () {
//                                         if (DIManager.findDep<
//                                             SharedPrefs>()
//                                             .getToken() ==
//                                             null) {
//                                           navigatorToPush(
//                                               context:
//                                               context,
//                                               pageName:
//                                               LoginScreen(
//                                                 isNeedIconBac:
//                                                 true,
//                                               ));
//                                         } else {
//                                           if(DIManager.findDep<
//                                               SharedPrefs>().getStatusUserIsBlocked() ==0)
//                                           {
//                                             SnackBarHelper.mySnackBarError('الحساب محظور لايمكنك النشر ..', context);
//                                             return;
//                                           }
//                                           if (controller.text
//                                               .isNotEmpty) {
//                                             if (checkBoxIndex ==
//                                                 0 &&
//                                                 colorsChoose !=
//                                                     'null') {
//                                               BlocProvider.of<CommunityCubit>(context).createPost(
//                                                   content:
//                                                   controller
//                                                       .text,
//                                                   type: 'A',
//                                                   background:
//                                                   colorsChoose,
//                                                   isHaveComment:
//                                                   isHaveComment,
//                                                   hashtags:
//                                                   idHashtag);
//                                               // if (controller
//                                               //     .text
//                                               //     .length <
//                                               //     20) {
//                                               //   BlocProvider.of<CommunityCubit>(
//                                               //       context)
//                                               //       .createPost(
//                                               //     content:
//                                               //     controller
//                                               //         .text,
//                                               //     type: 'A',
//                                               //   );
//                                               // } else {
//                                               //   BlocProvider.of<CommunityCubit>(context).createPost(
//                                               //       content:
//                                               //       controller
//                                               //           .text,
//                                               //       type:
//                                               //       'A',
//                                               //       background:
//                                               //       colorsChoose);
//                                               // }
//                                             } else if (checkBoxIndex ==
//                                                 1) {
//                                               if (_formKey
//                                                   .currentState!
//                                                   .validate()) {
//                                                 print(controllerUrlAds!
//                                                     .text
//                                                     .toString());
//                                                 print(controllerUrlAds!
//                                                     .text
//                                                     .toString());
//                                                 print(controllerUrlAds!
//                                                     .text
//                                                     .toString());
//                                                 BlocProvider.of<CommunityCubit>(context).createPost(
//                                                     content:
//                                                     controller
//                                                         .text,
//                                                     hashtags:
//                                                     idHashtag,
//                                                     isHaveComment:
//                                                     isHaveComment,
//                                                     type: 'C',
//                                                     video: controllerUrlAds!
//                                                         .text
//                                                         .toString());
//                                               }
//                                             } else if (checkBoxIndex ==
//                                                 2) {
//                                               if (_imagesAddProduct !=
//                                                   null) {
//                                                 BlocProvider.of<CommunityCubit>(context).createPost(
//                                                     content:
//                                                     controller
//                                                         .text,
//                                                     type: 'B',
//                                                     isHaveComment:
//                                                     isHaveComment,
//                                                     image: File(
//                                                         _imagesAddProduct!
//                                                             .path),
//                                                     hashtags:
//                                                     idHashtag);
//                                               } else {
//                                                 SnackBarHelper
//                                                     .mySnackBarError(
//                                                     'يجب اختيار صورة',
//                                                     context);
//                                               }
//                                             } else if (checkBoxIndex ==
//                                                 4) {
//                                               BlocProvider.of<
//                                                   CommunityCubit>(
//                                                   context)
//                                                   .createPost(
//                                                   content:
//                                                   controller
//                                                       .text,
//                                                   isHaveComment:
//                                                   isHaveComment,
//                                                   type:
//                                                   'A',
//                                                   hashtags:
//                                                   idHashtag);
//                                             }
//                                           }
//                                         }
//                                       },
//                                       width: 80.w,
//                                       buttonStyle:
//                                       ButtonStyle(
//                                         backgroundColor:
//                                         MaterialStateProperty
//                                             .all<Color>(
//                                             Colors
//                                                 .green),
//                                       )),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (checkBoxIndex == 2) ...{
//                     _imagesAddProduct == null
//                         ? Container()
//                         : Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 8.h, vertical: 6.w),
//                       child: ClipRRect(
//                         borderRadius:
//                         BorderRadius.circular(6.r),
//                         child: Stack(
//                           alignment: Alignment.topRight,
//                           children: [
//                             Image.file(
//                               File(_imagesAddProduct!
//                                   .path),
//                               fit: BoxFit.fill,
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsets.all(10.sp),
//                               child: Container(
//                                 // width: 100.w,
//
//                                 width:
//                                 MediaQuery.of(context)
//                                     .size
//                                     .width,
//                                 // height: 80.h,
//                                 // width: 80.w,
//                                 child: Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment
//                                       .start,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment
//                                       .spaceBetween,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         _imagesAddProduct =
//                                         null;
//                                         setState(() {});
//                                       },
//                                       child: Container(
//                                         width: 30.h,
//                                         height: 30.h,
//                                         decoration:
//                                         BoxDecoration(
//                                           color: appTheme
//                                               .deepPurpleA100,
//                                           borderRadius:
//                                           BorderRadius
//                                               .circular(
//                                               900.r),
//                                         ),
//                                         child: Center(
//                                             child: Icon(
//                                               Icons.cancel,
//                                               color: appTheme
//                                                   .black900,
//                                               size: 30.sp,
//                                             )),
//                                       ),
//                                     ),
//                                     sizeWidthNormal(),
//                                     InkWell(
//                                         onTap: () {
//                                           loadImages(
//                                               context);
//                                         },
//                                         child: Container(
//                                           width: 30.h,
//                                           height: 30.h,
//                                           decoration:
//                                           BoxDecoration(
//                                             color: appTheme
//                                                 .deepPurpleA100,
//                                             borderRadius:
//                                             BorderRadius
//                                                 .circular(
//                                                 900.r),
//                                           ),
//                                           child: Center(
//                                             child: Icon(
//                                               Icons.edit,
//                                               color: appTheme
//                                                   .black900,
//                                               size: 22.sp,
//                                             ),
//                                           ),
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   },
//                   if (checkBoxIndex == 3) ...[
//                     _isRecordingForTextFormFiled &&
//                         !_isStopRecording
//                         ? Padding(
//                       padding: EdgeInsets.only(top: 10.h),
//                       child: Container(
//                         // width: 10.w,
//                         height: 50.h,
//                         width: MediaQuery.of(context)
//                             .size
//                             .width *
//                             0.78,
//                         decoration: AppDecoration
//                             .outlineCircular
//                             .copyWith(
//                           borderRadius:
//                           BorderRadius.circular(9.h),
//                         ),
//                         child: Center(
//                             child: Text(formatDuration(
//                                 _recordingTime))),
//                       ),
//                     )
//                         : _isStopRecording
//                         ? Padding(
//                       padding:
//                       EdgeInsets.only(top: 10.h),
//                       child: Container(
//                         width: MediaQuery.of(context)
//                             .size
//                             .width *
//                             0.78,
//                         height: 50.h,
//                         decoration: AppDecoration
//                             .outlineCircular
//                             .copyWith(
//                           borderRadius:
//                           BorderRadius.circular(
//                               30.h),
//                         ),
//                         child: Row(
//                           crossAxisAlignment:
//                           CrossAxisAlignment
//                               .center,
//                           children: [
//
//                             Expanded(
//                               child: StreamBuilder<PositionData>(
//                                 stream: _positionDataStream,
//                                 builder: (context, snapshot) {
//                                   final positionData = snapshot.data;
//                                   return SeekBar(
//                                     duration: positionData?.duration ?? Duration.zero,
//                                     position: positionData?.position ?? Duration.zero,
//                                     bufferedPosition:
//                                     positionData?.bufferedPosition ?? Duration.zero,
//                                     onChangeEnd: _audioPlayer.seek,
//                                   );
//                                 },
//                               ),
//                             ),
//                             StreamBuilder<PlayerState>(
//                               stream: _audioPlayer.playerStateStream,
//                               builder: (context, snapshot) {
//                                 final playerState = snapshot.data;
//                                 final processingState = playerState?.processingState;
//                                 final playing = playerState?.playing;
//                                 if (processingState == ProcessingState.loading ||
//                                     processingState == ProcessingState.buffering) {
//                                   return Container(
//                                     margin: const EdgeInsets.all(8.0),
//                                     width: 20.0,
//                                     height: 20.0,
//                                     child: const CircularProgressIndicator(),
//                                   );
//                                 } else if (playing != true) {
//                                   return IconButton(
//                                     icon:  Icon(Icons.play_arrow,color: appTheme.deepPurple,),
//                                     iconSize: 30.0,
//                                     onPressed: _audioPlayer.play,
//                                   );
//                                 } else if (processingState != ProcessingState.completed) {
//                                   return IconButton(
//                                     icon:  Icon(Icons.pause,color: appTheme.deepPurple,),
//
//                                     iconSize: 30.0,
//                                     onPressed: _audioPlayer.pause,
//                                   );
//                                 } else {
//                                   return IconButton(
//                                     icon:  Icon(Icons.replay,color: appTheme.deepPurple,),
//                                     iconSize: 30.0,
//                                     onPressed: () => _audioPlayer.seek(Duration.zero,
//                                         index: _audioPlayer.effectiveIndices!.first),
//                                   );
//                                 }
//                               },
//                             ),
//                             // Container(
//                             //   width: MediaQuery.of(
//                             //               context)
//                             //           .size
//                             //           .width *
//                             //       0.5,
//                             //   child: Slider(
//                             //     value:
//                             //         _currentPosition,
//                             //     max: _totalDuration,
//                             //     onChanged: (value) {
//                             //       setState(() {
//                             //         _currentPosition =
//                             //             value;
//                             //       });
//                             //       _audioPlayer.seek(
//                             //           Duration(
//                             //               seconds: value
//                             //                   .toInt()));
//                             //     },
//                             //   ),
//                             // ),
//                             // isPlaying
//                             //     ? Text(formatDuration(
//                             //         _totalDuration))
//                             //     : Text(formatDuration(
//                             //         _currentPosition)),
//                             // sizeWidthNormal(),
//                             // InkWell(
//                             //   onTap: isPlaying
//                             //       ? _playRecording
//                             //       : _stopPlay,
//                             //   child: Icon(
//                             //     isPlaying
//                             //         ? Icons.play_arrow
//                             //         : Icons.stop,
//                             //     color:
//                             //         appTheme.black900,
//                             //   ),
//                             // ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 5),
//                               child: InkWell(
//                                 onTap: () {
//                                   _stopPlay();
//                                   restartPlay();
//                                 },
//                                 child: Icon(
//                                   Icons.delete,
//                                   color:
//                                   appTheme.black900,
//                                   size: 30,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                         : Container(),
//                   ],
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // String getHashtag({List<String>? hashtag}) {
//   //   String hash = '';
//   //   for (int i = 0; i < hashtag!.length; i++) {
//   //   if(hash ==''){
//   //     hash = hashtag[i];
//   //   }else{
//   //     hash = hash + ',' + hashtag[i];
//   //   }
//   //   }
//   //   return hash;
//   //
//   // }
//   bool isReadAll = false;
//   int checkBoxIndex = 4;
//
//   bool isImageNull = false;
//
//   Future<void> _pickImages(context) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(
//       imageQuality: 50,
//       source: ImageSource.gallery,
//     );
//     // if (pickedImages.length >= 6) {
//     //   SnackBarHelper.mySnackBarError('لايمكن اختيار أكثر من 5 صور ..', context);
//     //   return;
//     // }
//
//     isImageNull = false;
//
//     final File file = File(pickedImage!.path);
//     // File rotatedFile = await FlutterExifRotation.rotateAndSaveImage(path: file.path);
//     int fileSizeInBytes = File(pickedImage.path).lengthSync();
//     double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
//     print('fileSizeInMb : $fileSizeInMb');
//     final compressedFile = await FileManager.compressFile(file, false);
//     if (compressedFile != null) {
//       Directory tempDir = await getTemporaryDirectory();
//       String tempPath =
//           '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       await compressedFile.copy(tempPath);
//
//       _imagesAddProduct = File(tempPath);
//       int fileSizeInBytes2 = File(_imagesAddProduct!.path).lengthSync();
//       double fileSizeInMb = fileSizeInBytes2 / (1024 * 1024);
//       print('fileSizeInBytes2 : $fileSizeInMb');
//       setState(() {});
//       // }
//       // final File file = File(pickedImage!.path);
//       // final fileSize = await file.length();
//       //
//       // print('fileSize : $fileSize');
//       // if (fileSize <= 1048576) {
//       //   setState(() {
//       //     _imagesAddProduct = file;
//       //   });
//       // } else {
//       //   // Compress the image before adding it to the list
//       //   final compressedFile = await FileManager.compressFile(file, false);
//       //   if (compressedFile != null) {
//       //     setState(() {
//       //       _imagesAddProduct = compressedFile;
//       //     });
//       //   }
//     }
//   }
//
//   Widget checkBoxIcon(
//       {required void Function()? onPressed,
//       required String text,
//       required bool isChecked}) {
//     return Container(
//       width: 120.w,
//       child: Row(
//         children: [
//           IconButton(
//               onPressed: onPressed,
//               icon: Icon(
//                 isChecked
//                     ? Icons.check_box_outlined
//                     : Icons.check_box_outline_blank,
//                 color: appTheme.black900,
//               )),
//           Flexible(
//             // Wrap the text widget with Flexible
//             child: textNormal(
//               text: text,
//               fontSize: AppFontSize.fontSize_12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _addImage() {
//     return GestureDetector(
//       onTap: () {
//         _showChoiceDialog(context);
//       },
//       child: Icon(
//         Icons.camera_alt_outlined,
//         // color: AppColorsController().red,
//       ),
//     );
//   }
//
//   Future<void> _showChoiceDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       Navigator.pop(context);
//                       _pickImages(context);
//                     },
//                     title: Text('Gallery'),
//                     leading: Icon(
//                       Icons.image_sharp,
//                       color: AppColorsController().primaryColor,
//                     ),
//                   ),
//                   Divider(
//                     height: 1,
//                     color: AppColorsController().primaryColor,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.pop(context);
//                       _openCamera(context);
//                     },
//                     title: Text('Camera'),
//                     leading: Icon(
//                       Icons.camera,
//                       color: AppColorsController().primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   void _openCamera(BuildContext context) async {
//     final picker = ImagePicker();
//     XFile? result = await picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 35,
//     );
//     // if (images.length >= 1) {
//     //   return;
//     // }
//
//     final File file = File(result!.path);
//     // File rotatedFile = await FlutterExifRotation.rotateAndSaveImage(path: file.path);
//     int fileSizeInBytes = File(result.path).lengthSync();
//     double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
//     print('fileSizeInMb : $fileSizeInMb');
//     final compressedFile = await FileManager.compressFile(file, false);
//     if (compressedFile != null) {
//       Directory tempDir = await getTemporaryDirectory();
//       String tempPath =
//           '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       await compressedFile.copy(tempPath);
//
//       _imagesAddProduct = File(tempPath);
//       int fileSizeInBytes2 = File(_imagesAddProduct!.path).lengthSync();
//       double fileSizeInMb = fileSizeInBytes2 / (1024 * 1024);
//       print('fileSizeInBytes2 : $fileSizeInMb');
//       setState(() {});
//     }
//
//     //   if (result != null) {
//     //   File file = File(result.path);
//     //   int fileSizeInBytes = File(result.path).lengthSync();
//     //   double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
//     //   // print(fileSizeInMb);
//     //   if (fileSizeInMb > 1) {
//     //     // SnackBarHelper.mySnackBarError(AppLocalizations.of(context)!.error_size_photo, context);
//     //     //   return;
//     //     final compressedFile = await FileManager.compressFile(file, false);
//     //     if (compressedFile != null) {
//     //       setState(() {
//     //         // fileLicenseListImage = compressedFile;
//     //         _imagesAddProduct = File(compressedFile.path);
//     //       });
//     //     }
//     //   } else {
//     //     fileLicenseListImage = result;
//     //     _imagesAddProduct = File(fileLicenseListImage!.path);
//     //   }
//     // }
//     // setState(() {});
//   }
//
//   File? _imagesAddProduct;
//
//   XFile? fileLicenseListImage;
//
//   void showStatusImages(
//     BuildContext context,
//   ) {
//     // AddAdsCubit cubit = BlocProvider.of(context);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         double rating = 0.0;
//         return StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             backgroundColor: appTheme.buttonColor,
//             title: Text(
//               'تعديل حالة الصورة',
//               style: themeLite.textTheme.titleSmall
//                   ?.copyWith(color: appTheme.whiteA700),
//             ),
//             content: Container(
//               height: 80.h,
//               // width: 80.w,
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       _imagesAddProduct = null;
//                       Navigator.pop(context);
//                     },
//                     child: Center(
//                         child: Container(
//                       width: 110.h,
//                       height: 40.h,
//                       decoration: AppDecoration.outlineSelectedLite
//                           .copyWith(borderRadius: BorderRadius.circular(30.h)),
//                       child: Center(
//                         child: textNormal(text: 'حذف'),
//                       ),
//                     )),
//                   ),
//                   sizeWidthNormal(),
//                   InkWell(
//                     onTap: () {
//                       loadImages(context);
//                       Navigator.pop(context);
//                     },
//                     child: Center(
//                         child: Container(
//                       width: 110.h,
//                       height: 40.h,
//                       decoration: AppDecoration.outlineSelectedLite
//                           .copyWith(borderRadius: BorderRadius.circular(30.h)),
//                       child: Center(
//                         child: textNormal(text: 'تعديل'),
//                       ),
//                     )),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }
//
//   Future<void> loadImages(context) async {
//     final picker = ImagePicker();
//     XFile? result = await picker.pickImage(source: ImageSource.gallery
//         // imageQuality: 50,
//         );
//     if (result != null) {
//       File file = File(result.path);
//       int fileSizeInBytes = File(result.path).lengthSync();
//       double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
//       // print(fileSizeInMb);
//       if (fileSizeInMb > 1) {
//         // SnackBarHelper.mySnackBarError(AppLocalizations.of(context)!.error_size_photo, context);
//         //   return;
//         final compressedFile = await FileManager.compressFile(file, false);
//         if (compressedFile != null) {
//           setState(() {
//             // fileLicenseListImage = compressedFile;
//             _imagesAddProduct = File(compressedFile.path);
//           });
//         }
//       } else {
//         fileLicenseListImage = result;
//         _imagesAddProduct = File(fileLicenseListImage!.path);
//       }
//     }
//     setState(() {});
//   }
// }
//
// String colorWithoutHashtag(String colors) {
//   return colors.replaceAll('#', '');
// }
