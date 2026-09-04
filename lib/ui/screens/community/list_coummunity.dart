import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// import 'package:just_audio_background/just_audio_background.dart';
import 'package:syrians_in_uae/core/constants/app_consts.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/community/hashtag_model.dart';
import 'package:syrians_in_uae/ui/screens/chats/chat_messages_post.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/apis_chat_firebase.dart';
import 'package:syrians_in_uae/ui/screens/community/post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import 'package:just_audio/just_audio.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:audio_session/audio_session.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/chats/message_model.dart';
import '../../../data/models/community/comments__id_posts_model.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../../data/models/parts_voice/common.dart';
import '../../../widgets/user_image_profile.dart';
import '../company/company_details_page.dart';
import '../reminders/cubit/reminder_cubit.dart';
import 'comments.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/loader_for_page.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../widget/url_webview.dart';
import '../auth/login/login_screen.dart';
import '../details_product/details_product.dart';
import 'community.dart';
import 'cubit/community_cubit.dart';
import 'edit_post.dart';
import 'hashtag_screen.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class ListCommunity extends StatefulWidget {
  ListCommunity(
      {super.key,
      this.communityPostModel,
      this.page,
      bool isFromUserPage = false,
      this.hashtag,
      this.company,
      this.isFromHashtagScreen = false,
      this.isStopNavigation = false,
      this.isFromHomePage = false});

  List<CommunityModelDatum>? communityPostModel;
  int? page;
  bool isFromUserPage = false;
  bool isStopNavigation = false;
  bool isFromHomePage = false;
  bool isFromHashtagScreen = false;
  String? hashtag;
  String? company;

  @override
  State<ListCommunity> createState() => _ListCommunityState();
}
ValueNotifier<List<CommunityModelDatum>>? notifier ;

class _ListCommunityState extends State<ListCommunity> {
  bool isLoadingDelete = false;
  bool isReadAll = false;
  bool isPostLiked = false;
  Map<int, bool> isReadAllMap = {};
  Map<int, bool> postAllLikes = {};
  Map<int, int> counterPostAllLikes = {};
  Map<String, PreviewData> datas = {};
  PreviewData? previewData;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // bool isPlaying = true;
  List<bool> isPlayingList = []; // قائمة لتتبع حالة التشغيل لكل عنصر

  // double _currentPosition = 0;
  List<double> currentPositionList = [];
  double _totalDuration = 0;
  List<double> totalDurationList = [];

  Stream<FileResponse>? fileStream;

  List<bool> isLoadingList =
      []; // تأكد من تهيئتها بطول يساوي عدد العناصر في widget.communityPostModel

  StreamSubscription<FileResponse>? downloadStreamSubscription;

  Stream<FileResponse> _getFileFromCacheWithProgress(url) {
    return DefaultCacheManager().getFileStream(url, withProgress: true);
  }

  void cancelDownload(index) {
    downloadStreamSubscription?.cancel();
    setState(() {
      isLoadingList[index] = false;
    });
  }

  double downloadProgress = 0.0;




  Future<void> _playRecording(String url, int index) async {
    try {

      CommunityCubit.get(context).changeVoicePlay(true);
      setState(() {
        isLoadingList[index] = true;
      });

      var file = await DefaultCacheManager().getSingleFile(url);

      if (!cancelVoice) {
        setState(() {
          isLoadingList[index] = false;
          isPlayingList[index] = false;
        });

        await _audioPlayer.setAudioSource(
          AudioSource.file(
            file.path,
            // tag: MediaItem(
            //   id:     file.path,
            //   title: 'Audio $index',
            //   artist: 'Unknown',playable: true,isLive: false,
            //   duration: Duration(seconds: totalDurationList[index].toInt()),
            // ),
          ),
        );
        await _audioPlayer.setSpeed(playbackSpeedList[index]);

        _audioPlayer.play();
        // تحديث الموضع أثناء التشغيل
        _audioPlayer.positionStream.listen((position) {
          setState(() {
            currentPositionList[index] = position.inSeconds.toDouble();
          });
        });

        // التحقق عند انتهاء الصوت
        _audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            setState(() {
              isPlayingList[index] = true;
              _stopPlay(url, index);
            });
          }
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
      setState(() {
        isLoadingList[index] = false; // في حالة حدوث خطأ
      });
    }
  }

  bool cancelVoice = false;

  void deleteCache(url, index) async {
    // DefaultCacheManager().removeFile(url);
    // await DefaultCacheManager().getSingleFile(url)..exists();
    CommunityCubit.get(context).changeVoicePlay(false);
    setState(() {
      isLoadingList[index] = false;
      cancelVoice = true;
    });
    _stopPlay(url, index);
  }

  delete(url) {
    DefaultCacheManager().removeFile(url);
  }

  Future<void> _stopPlay(String url, int index) async {
    try {
      CommunityCubit.get(context).changeVoicePlay(false);
      setState(() {
        isPlayingList[index] = true;
        currentPositionList[index] = 0; // إعادة تعيين الموضع الحالي
      });

      // إعداد مصدر الصوت باستخدام MediaItem
      //   await _audioPlayer.setAudioSource(
      //     AudioSource.uri(
      //       Uri.parse(url),
      //       tag: MediaItem(
      //         id: url, // معرف فريد للصوت
      //         title: 'Audio $index', // قم باستبدالها بعنوان فعلي إذا كان متاحًا
      //         artist: 'Unknown', // قم باستبدالها باسم الفنان إذا كان متاحًا
      //         duration: Duration(seconds: totalDurationList[index].toInt()),
      //       ),
      //     ),
      //   );

      // إيقاف التشغيل
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  @override
  void initState() {
    // isPlayingList = List<bool>.filled(widget.communityPostModel!.length, true);
    // currentPositionList =
    //     List<double>.filled(widget.communityPostModel!.length, 0.0);
    // totalDurationList =
    //     List<double>.filled(widget.communityPostModel!.length, _totalDuration);
    isPlayingList = List<bool>.filled(1000, true);
    currentPositionList = List<double>.filled(1000, 0.0);
    totalDurationList = List<double>.filled(1000, _totalDuration);
    isLoadingList = List.filled(1000, false);
    playbackSpeedList = List.filled(1000, 1.0);
    notifier = ValueNotifier([...widget.communityPostModel!]);
    super.initState();
  }

  final _player = AudioPlayer();

  // double playbackSpeed = 1.0;
  List<double> playbackSpeedList = [];


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  int? indexVideoStop;

  int? indexLoaderStop;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CommunityCubit, CommunityState>(
      listener: (context, state) {

        if (state is SuccessGetAllCommunityPostForLikeState) {
          widget.communityPostModel = state.communityPostModel;
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: notifier!,
          builder: (BuildContext context, List<CommunityModelDatum>? value, Widget? child) {
            return Container(
              // height: 100000.h,
              // flex: 3,
              child: isLoadingDelete
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textNormal(
                      text: 'جاري حذف المنشور',
                      fontSize: AppFontSize.fontSize_12,
                      fontWeight: FontWeight.w500),
                  sizeHeightNormal(),
                  loaderNormal(),
                ],
              )
                  : ListView.builder(
                  itemCount: widget.communityPostModel!.length,
                  shrinkWrap: true,
                  padding: widget.isFromHomePage
                      ? EdgeInsets.symmetric(vertical: 10)
                      : null,
                  // reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String text =
                        widget.communityPostModel![index].content ?? '';
                    String displayText = text.length > 200
                        ? '${text.substring(0, 200)}...'
                        : text;
                    String color = widget.communityPostModel![index].background
                        ?.replaceRange(0, 1, '0xff') ??
                        '0xffF5A623';
                    isReadAll = isReadAllMap[index] ?? false;
                    isPostLiked = postAllLikes[index] ?? false;
                    counterPostAllLikes[index] =
                        counterPostAllLikes[index] ?? 0;
                    return InkWell(
                      onTap: () {
                        navigatorToPush(
                            context: context,
                            pageName: PostScreen(
                              communityPostModel:
                              widget.communityPostModel![index],
                              idPost: int.parse(widget
                                  .communityPostModel![index].id
                                  .toString()),
                            ));
                      },
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            // height: 48.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: widget.isFromHomePage
                                ? AppDecoration.outlineBlueGray.copyWith(
                              boxShadow: [],
                              color: widget.communityPostModel![index].type == 'A' &&
                                  widget.communityPostModel![index]
                                      .background !=
                                      null
                                  ? widget.communityPostModel![index]
                                  .background!
                                  .contains('0xff')
                                  ? Color(int.parse(widget
                                  .communityPostModel![index]
                                  .background
                                  .toString()))
                                  .withOpacity(.8)
                                  : widget.communityPostModel![index]
                                  .background!
                                  .contains('#')
                                  ? Color(int.parse(color))
                                  .withOpacity(.8)
                                  : Color(int.parse("0xff${widget.communityPostModel![index].background}"))
                                  .withOpacity(.8)
                                  : widget.isFromHomePage? appTheme.backgroundContainer :appTheme.lightBlue100,
                            )
                                : null,
                            color: widget.isFromHomePage
                                ? null
                                : widget.communityPostModel![index].type ==
                                'A' &&
                                widget.communityPostModel![index]
                                    .background !=
                                    null
                                ? widget.communityPostModel![index]
                                .background!
                                .contains('0xff')
                                ? Color(int.parse(widget
                                .communityPostModel![index]
                                .background
                                .toString()))
                                .withOpacity(.8)
                                : widget.communityPostModel![index]
                                .background!
                                .contains('#')
                                ? Color(int.parse('0xff${colorWithoutHashtag(widget.communityPostModel![index].background!)}'))
                                .withOpacity(.8)
                                : Color(int.parse("0xff${widget.communityPostModel![index].background}"))
                                .withOpacity(.8)
                                : appTheme.lightBlue100,
                            // color: Colors.grey.withOpacity(0.2),
                            margin: EdgeInsets.symmetric(vertical: 3.h),
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      UserImageProfile(
                                          imageUrl:  widget
                                              .communityPostModel![index]
                                              .profilePic.toString(),
                                        onTap: () {
                                          if (!widget.isStopNavigation) {
                                            navigatorToPush(
                                                context: context,
                                                pageName: CompanyDetailsPage(
                                                  idCompany: int.parse(widget
                                                      .communityPostModel![
                                                  index]
                                                      .userId
                                                      .toString()),
                                                ));
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 5.sp,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          textNormal(
                                              text: widget
                                                  .communityPostModel![
                                              index]
                                                  .name ??
                                                  '',
                                              // color: AppColorsController().black900,
                                              fontSize: AppFontSize.fontSize_15,
                                              fontWeight: FontWeight.bold),
                                          // SizedBox(
                                          //   height: 5.sp,
                                          // ),s
                                          textNormal(
                                              text: widget
                                                  .communityPostModel![
                                              index]
                                                  .acceptDate ==
                                                  null
                                                  ? ''
                                                  : getComparedTime(widget
                                                  .communityPostModel![
                                              index]
                                                  .acceptDate!) ??
                                                  '',
                                              // color: AppColorsController().black900,
                                              fontSize: AppFontSize.fontSize_11,
                                              fontWeight: FontWeight.w300),
                                        ],
                                      ),
                                      Spacer(),
                                      widget.communityPostModel![index]
                                          .userId ==
                                          DIManager.findDep<SharedPrefs>()
                                              .getUserID()
                                          ? PopupMenuButton(
                                        color: appTheme
                                            .lightBlueBottomNavigatorBar,
                                        child: CustomImageView(
                                          imagePath:
                                          ImageConstant.iconList,
                                          height: 20.h,
                                          width: 20.h,
                                          color:
                                          appTheme.deepPurpleA10002,
                                        ),
                                        // Use a specific widget
                                        itemBuilder:
                                            (BuildContext context) => [
                                          PopupMenuItem(
                                            value: 'delete',
                                            child:
                                            textNormal(text: 'حذف'),
                                          ),
                                          if (widget
                                              .communityPostModel![
                                          index]
                                              .type !=
                                              'D')
                                            PopupMenuItem(
                                              value: 'Edit',
                                              child: textNormal(
                                                  text: 'تعديل'),
                                            ),
                                        ],
                                        onSelected: (value) {
                                          if (value == "delete") {
                                            // showDeletePost(context,
                                            // widget
                                            //     .communityPostModel![
                                            // index]
                                            //     .id
                                            //     .toString()
                                            //     , state,);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context2) {
                                                double rating = 0.0;
                                                return StatefulBuilder(
                                                  builder: (BuildContext context3, StateSetter setState) {
                                                    return AlertDialog(
                                                      backgroundColor: appTheme.buttonColor,
                                                      title: Text(
                                                        'هل أنت متأكد من حذف المنشور ؟',
                                                        style: themeLite.textTheme.titleSmall,
                                                      ),
                                                      content: Container(
                                                        height: 40.h,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            CustomElevatedButton(
                                                              text: 'إلغاء',
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              width: 90.w,
                                                            ),
                                                            sizeWidthNormal(),
                                                            // Moved BlocConsumer here for the correct context usage
                                                            BlocConsumer<CommunityCubit, CommunityState>(
                                                              listener: (context, state) {
                                                                if (state is ErrorDeletePostState) {
                                                                  SnackBarHelper.mySnackBarError(state.message, context);
                                                                }
                                                                if (state is SuccessDeletePostState) {
                                                                  print("الحجم قبل الحذف: ${widget.communityPostModel?.length}");

                                                                  // حذف من المصدر الأساسي
                                                                  widget.communityPostModel?.removeWhere(
                                                                          (element) => element.id.toString() == widget
                                                                              .communityPostModel![
                                                                          index]
                                                                              .id
                                                                              .toString()
                                                                  );

                                                                  // تحديث الـ Notifier
                                                                  notifier!.value = List.from(widget.communityPostModel!);

                                                                  print("الحجم بعد الحذف: ${widget.communityPostModel?.length}");

                                                                  Navigator.pop(context);
                                                                  SnackBarHelper.mySnackBarSuccess(state.data.message, context);
                                                                }
                                                              },
                                                              builder: (context, state) {
                                                                return CustomElevatedButton(
                                                                  text: 'حذف',
                                                                  onPressed: (){
                                                                    BlocProvider.of<CommunityCubit>(
                                                                        context)
                                                                        .deletePost(
                                                                        idPost: int.parse(widget
                                                                            .communityPostModel![
                                                                        index]
                                                                            .id
                                                                            .toString()),
                                                                        indexPost: 0);
                                                                  },
                                                                  width: 90.w,
                                                                  child: state is LoadingDeletePostState
                                                                      ? loadingButton(    color: appTheme.greenColor)  // Show loading state
                                                                      : null,  // Show normal button
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }

                                          if (value == "Edit") {
                                            // showModalBottomSheet(
                                            //     context: context,
                                            //     isScrollControlled: true,
                                            //     builder: (BuildContext bc) {
                                            //       return EditPostScreen(
                                            //         postModel: widget
                                            //             .communityPostModel!
                                            //             .data[index],
                                            //       );
                                            //     });
                                            navigatorToPush(
                                                context: context,
                                                pageName: EditPostScreen(
                                                  postModel: widget
                                                      .communityPostModel![
                                                  index],
                                                  communityPostModel: widget
                                                      .communityPostModel!,
                                                  index: index,
                                                  isFromPostScreen: false,
                                                ));
                                          }

                                          // Handle menu item selection here
                                        },
                                      )
                                          : widget.communityPostModel![index]
                                          .pin ==
                                          '1'
                                          ? Container(
                                          child: CustomImageView(
                                            imagePath:
                                            ImageConstant.pinIcon,
                                            height: 15.h,
                                            width: 15.h,
                                            color: appTheme.red300,
                                          ))
                                          : Container(),
                                    ],
                                  ),
                                  if (widget.communityPostModel![index].type ==
                                      'A') ...[
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 12.h),
                                      child: text.length > 200
                                          ? RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                isReadAllMap[index] ??
                                                    false
                                                    ? text
                                                    : displayText,
                                                style: themeLite.textTheme
                                                    .bodyMedium),
                                            isReadAll
                                                ? TextSpan()
                                                : TextSpan(
                                              text: AppLocalizations
                                                  .of(context)!
                                                  .read_more,
                                              style: themeLite
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                fontSize: AppFontSize
                                                    .fontSize_12,
                                                color: Colors.blue,
                                                // لون "اقرأ المزيد"
                                                decoration:
                                                TextDecoration
                                                    .underline, // جعل النص تحته خط للدلالة على إمكانية النقر
                                              ),
                                              recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    // تبديل حالة isReadAll للعنصر الحالي
                                                    isReadAllMap[
                                                    index] =
                                                    true;
                                                  });
                                                  // setState(() {
                                                  //   isReadAll =
                                                  //       !isReadAll;
                                                  // });
                                                },
                                            ),
                                          ],
                                        ),
                                      )
                                          : RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                isReadAllMap[index] ??
                                                    false
                                                    ? text
                                                    : displayText,
                                                style: themeLite.textTheme
                                                    .bodyMedium),
                                          ],
                                        ),
                                      ),
                                    ),
                                    for (int i = 0;
                                    i <
                                        widget.communityPostModel![index]
                                            .hashtags.length;
                                    i++) ...{
                                      widget
                                          .communityPostModel![index]
                                          .hashtags[i]
                                          .toString() =='null'?Container():  InkWell(
                                        onTap: () {
                                          navigatorToPush(
                                              context: context,
                                              pageName: HashtagScreen(
                                                hashtagName: widget
                                                    .communityPostModel![index]
                                                    .hashtags[i]
                                                    .toString(),
                                              ));
                                        },
                                        child: textNormal(
                                            text: widget
                                                .communityPostModel![index]
                                                .hashtags[i]
                                                .toString(),
                                            fontSize: AppFontSize.fontSize_12,
                                            fontWeight: FontWeight.w800,
                                            color:
                                            appTheme.deepPurpleAndYellow),
                                      ),
                                    },
                                  ] else ...[
                                    text.length > 200
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                isReadAllMap[index] ??
                                                    false
                                                    ? text
                                                    : displayText,
                                                style: themeLite.textTheme
                                                    .bodyMedium),
                                            isReadAll
                                                ? TextSpan()
                                                : TextSpan(
                                              text: AppLocalizations
                                                  .of(context)!
                                                  .read_more,
                                              style: themeLite
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                fontSize: AppFontSize
                                                    .fontSize_12,
                                                color: Colors.blue,
                                                // لون "اقرأ المزيد"
                                                decoration:
                                                TextDecoration
                                                    .underline, // جعل النص تحته خط للدلالة على إمكانية النقر
                                              ),
                                              recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    // تبديل حالة isReadAll للعنصر الحالي
                                                    isReadAllMap[
                                                    index] =
                                                    true;
                                                  });
                                                  // setState(() {
                                                  //   isReadAll =
                                                  //       !isReadAll;
                                                  // });
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                        : Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                isReadAllMap[index] ??
                                                    false
                                                    ? text
                                                    : displayText,
                                                style: themeLite.textTheme
                                                    .bodyMedium),
                                          ],
                                        ),
                                      ),
                                    ),
                                    for (int i = 0;
                                    i <
                                        widget.communityPostModel![index]
                                            .hashtags!.length;
                                    i++) ...{
                                      widget
                                          .communityPostModel![index]
                                          .hashtags[i]
                                          .toString() =='null'?Container(): InkWell(
                                        onTap: () {
                                          navigatorToPush(
                                              context: context,
                                              pageName: HashtagScreen(
                                                hashtagName: widget
                                                    .communityPostModel![index]
                                                    .hashtags[i]
                                                    .toString(),
                                              ));
                                        },
                                        child: textNormal(
                                            text: widget
                                                .communityPostModel![index]
                                                .hashtags[i]
                                                .toString(),
                                            fontSize: AppFontSize.fontSize_12,
                                            fontWeight: FontWeight.w800,
                                            color:
                                            appTheme.deepPurpleAndYellow),
                                      ),
                                    },
                                    sizeHeightNormal(height: 6.h),
                                    if (widget
                                        .communityPostModel![index].type ==
                                        'B') ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // height: 214.h,
                                            decoration: AppDecoration
                                                .outlinePurple
                                                .copyWith(
                                              boxShadow: [],
                                            ),
                                            child: CustomImageView(
                                              imagePath: widget
                                                  .communityPostModel![
                                              index]
                                                  .image ??
                                                  '',
                                              // color: appTheme
                                              //     .deepPurpleA100,
                                              // height: 214.h,

                                              fit: BoxFit.fill,
                                              radius:
                                              BorderRadius.circular(25.r),
                                              // width: 214.sp,
                                            )),
                                      ),
                                    ] else if (widget
                                        .communityPostModel![index].type ==
                                        'C') ...[
                                      imageFromUrlVideo(
                                          link: widget
                                              .communityPostModel![index]
                                              .video!,
                                          onTap: () {
                                            navigatorToPush(
                                                context: context,
                                                pageName: UrlWebViewPage(
                                                  titleAppBer: '',
                                                  urlPage: widget
                                                      .communityPostModel![
                                                  index]
                                                      .video ??
                                                      '',
                                                ));
                                          }),
                                    ]
                                  ],
                                  if (widget.communityPostModel![index].type ==
                                      'D') ...{
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 5.h),
                                      child: ChatBubble(
                                        clipper: ChatBubbleClipper9(
                                            type: BubbleType.receiverBubble),
                                        backGroundColor:
                                        Colors.blueGrey.withOpacity(.4),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.r),
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (isPlayingList[
                                                      index]) {
                                                        if (indexVideoStop !=
                                                            null) {
                                                          _stopPlay(
                                                            widget
                                                                .communityPostModel![
                                                            indexVideoStop!]
                                                                .voice
                                                                .toString(),
                                                            indexVideoStop!,
                                                          );
                                                        }
                                                        if (indexLoaderStop !=
                                                            null) {
                                                          deleteCache(
                                                              widget
                                                                  .communityPostModel![
                                                              indexLoaderStop!]
                                                                  .voice
                                                                  .toString(),
                                                              indexLoaderStop);
                                                        }
                                                        cancelVoice = false;
                                                        indexVideoStop = index;
                                                        indexLoaderStop = index;
                                                        ReminderCubit.get(context).stopRadioIfPlay();
                                                        _playRecording(
                                                          widget
                                                              .communityPostModel![
                                                          index]
                                                              .voice
                                                              .toString(),
                                                          index,
                                                        );
                                                      } else {
                                                        _stopPlay(
                                                          widget
                                                              .communityPostModel![
                                                          index]
                                                              .voice
                                                              .toString(),
                                                          index,
                                                        );
                                                      }
                                                      print(isPlayingList);
                                                      print(
                                                          isPlayingList[index]);
                                                    },
                                                    child: Container(
                                                      width: 50.h,
                                                      height: 50.h,
                                                      decoration: AppDecoration
                                                          .pointChoose
                                                          .copyWith(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(40.r),
                                                        boxShadow: [],
                                                      ),
                                                      child:
                                                      isLoadingList[index]
                                                          ? Stack(
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        children: [
                                                          CircularProgressIndicator(
                                                            color: appTheme
                                                                .black900,
                                                            strokeWidth:
                                                            2,
                                                          ),
                                                          InkWell(
                                                            onTap: () => deleteCache(
                                                                widget
                                                                    .communityPostModel![index]
                                                                    .voice
                                                                    .toString(),
                                                                index),
                                                            child:
                                                            Icon(
                                                              Icons
                                                                  .close,
                                                              color: appTheme
                                                                  .black900,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          : Icon(
                                                        isPlayingList[
                                                        index]
                                                            ? Icons
                                                            .play_arrow
                                                            : Icons
                                                            .stop,
                                                        color: appTheme
                                                            .black900,
                                                      ),
                                                    ),
                                                  ),

                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      sizeWidthNormal(),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.fast_forward),
                                                        onPressed: () {
                                                          setState(() {
                                                            playbackSpeedList[
                                                            index] =
                                                                (playbackSpeedList[
                                                                index] -
                                                                    0.25)
                                                                    .clamp(0.5,
                                                                    2.0);
                                                          });
                                                          _audioPlayer.setSpeed(
                                                              playbackSpeedList[
                                                              index]);
                                                        },
                                                      ),
                                                      Text(
                                                          '${playbackSpeedList[index]}x',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.fast_rewind),
                                                        onPressed: () {
                                                          setState(() {
                                                            playbackSpeedList[
                                                            index] =
                                                                (playbackSpeedList[
                                                                index] +
                                                                    0.25)
                                                                    .clamp(0.5,
                                                                    2.0);
                                                          });
                                                          _audioPlayer.setSpeed(
                                                              playbackSpeedList[
                                                              index]);
                                                        },
                                                      ),
                                                      sizeWidthNormal(),
                                                    ],
                                                  ),
                                                  //
                                                  // IconButton(onPressed: (){
                                                  //   delete(   widget.communityPostModel![index!].voice.toString());
                                                  // }, icon: Icon(Icons.abc))
                                                ],

                                                //       sizeWidthNormal(),
                                              ),
                                              isPlayingList[index]
                                                  ? textNormal(text:formatDuration(
                                                  double.parse(widget
                                                      .communityPostModel![
                                                  index]
                                                      .voice_time ??
                                                      totalDurationList[
                                                      index]
                                                          .toString())))
                                                  : textNormal(text:formatDuration(
                                                  currentPositionList[
                                                  index])),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.h,
                                      right: 10.w,
                                      left: 10.w,
                                    ),
                                    child: Container(
                                      // width: 250.w,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: InkWell(
                                              onTap: () {
                                                if (DIManager.findDep<
                                                    SharedPrefs>()
                                                    .getToken() ==
                                                    null) {
                                                  navigatorToPush(
                                                      context: context,
                                                      pageName: LoginScreen(
                                                        isNeedIconBac: true,
                                                      ));
                                                } else {
                                                  BlocProvider.of<
                                                      CommunityCubit>(
                                                      context)
                                                      .likePost(
                                                      idPost: int.parse(widget
                                                          .communityPostModel![
                                                      index]
                                                          .id
                                                          .toString()),
                                                      isFromUserPage: widget
                                                          .isFromUserPage,
                                                      hashtag:
                                                      widget.hashtag,
                                                      isSearchHashtag: widget
                                                          .isFromHashtagScreen);

                                                  setState(() {
                                                    if (widget
                                                        .communityPostModel![
                                                    index]
                                                        .isLikePost ==
                                                        true) {
                                                      widget
                                                          .communityPostModel![
                                                      index]
                                                          .isLikePost = false;

                                                      postAllLikes[index] =
                                                      false;
                                                    } else {
                                                      widget
                                                          .communityPostModel![
                                                      index]
                                                          .isLikePost = true;
                                                      postAllLikes[index] =
                                                      true;
                                                    }
                                                    _toggleLike(
                                                        index,
                                                        widget
                                                            .communityPostModel![
                                                        index]
                                                            .likesCount!);
                                                  });
                                                }
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  CustomImageView(
                                                    imagePath: widget
                                                        .communityPostModel![
                                                    index]
                                                        .isLikePost ==
                                                        true
                                                        ? ImageConstant.likeIcon
                                                        : (postAllLikes[
                                                    index] ??
                                                        false
                                                        ? ImageConstant
                                                        .likeIcon
                                                        : ImageConstant
                                                        .unlikeIcon),
                                                    color: widget
                                                        .communityPostModel![
                                                    index]
                                                        .isLikePost ==
                                                        true
                                                        ? appTheme
                                                        .deepPurpleA100
                                                        : postAllLikes[index] ??
                                                        false
                                                        ? appTheme
                                                        .deepPurpleA100
                                                        : appTheme.black900,
                                                    height: 25.sp,
                                                    width: 25.sp,
                                                  ),
                                                  SizedBox(
                                                    width: 12.w,
                                                  ),
                                                  textNormal(
                                                    text:
                                                    '${sum(widget.communityPostModel![index].likesCount!, counterPostAllLikes[index]!)} أعجبني',
                                                    fontSize:
                                                    AppFontSize.fontSize_10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          widget.communityPostModel![index]
                                              .isHaveComment
                                              .toString() ==
                                              '0'
                                              ? Container()
                                              : Padding(
                                            padding: const EdgeInsets
                                                .symmetric(horizontal: 5),
                                            child: InkWell(
                                              onTap: () {
                                                // showModalBottomSheet(
                                                //     context:
                                                //         context,
                                                //     isScrollControlled:
                                                //         true,
                                                //     builder:
                                                //         (BuildContext
                                                //             bc) {
                                                //       return CommentsPostScreen(
                                                //           idPost: int.parse(widget.communityPostModel!
                                                //               .data[index]
                                                //               .id
                                                //               .toString(),),
                                                //       commentsList: widget.communityPostModel!
                                                //           .data[index]
                                                //           .comments,
                                                //       );
                                                //     });
                                                if (DIManager.findDep<
                                                    SharedPrefs>()
                                                    .getToken() ==
                                                    null) {
                                                  navigatorToPush(
                                                      context: context,
                                                      pageName:
                                                      LoginScreen(
                                                        isNeedIconBac:
                                                        true,
                                                      ));
                                                } else {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled:
                                                      true,
                                                      builder:
                                                          (BuildContext
                                                      bc) {
                                                        return CommentsPostScreen(
                                                          idPost:
                                                          int.parse(
                                                            widget
                                                                .communityPostModel![
                                                            index]
                                                                .id
                                                                .toString(),
                                                          ),
                                                          isHaveGroup: widget
                                                              .communityPostModel![
                                                          index]
                                                              .is_content_group!,
                                                          idUserCreatePost:
                                                          int.parse(widget
                                                              .communityPostModel![
                                                          index]
                                                              .userId!),
                                                          // commentsList: widget
                                                          //     .communityPostModel![
                                                          //         index]
                                                          //     .comments,
                                                        );
                                                      });
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.chat_outlined,
                                                    size: 25.sp,
                                                    color: appTheme.black900,
                                                  ),
                                                  SizedBox(
                                                    width: 12.w,
                                                  ),
                                                  textNormal(
                                                    text:
                                                    '${widget.communityPostModel![index].comments.length} تعليق',
                                                    // ' 33 تعليق',
                                                    fontSize: AppFontSize
                                                        .fontSize_10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (DIManager.findDep<SharedPrefs>()
                                              .getIfUsersCanChatsCommunity() ==
                                              1) ...{
                                            widget.communityPostModel![index]
                                                .is_have_chat
                                                .toString() ==
                                                '0'
                                                ? Container()
                                                : widget
                                                .communityPostModel![
                                            index]
                                                .userId
                                                .toString() ==
                                                DIManager.findDep<
                                                    SharedPrefs>()
                                                    .getUserID()
                                                ? Container()
                                                : Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  // showModalBottomSheet(
                                                  //     context:
                                                  //         context,
                                                  //     isScrollControlled:
                                                  //         true,
                                                  //     builder:
                                                  //         (BuildContext
                                                  //             bc) {
                                                  //       return CommentsPostScreen(
                                                  //           idPost: int.parse(widget.communityPostModel!
                                                  //               .data[index]
                                                  //               .id
                                                  //               .toString(),),
                                                  //       commentsList: widget.communityPostModel!
                                                  //           .data[index]
                                                  //           .comments,
                                                  //       );
                                                  //     });
                                                  if (DIManager.findDep<
                                                      SharedPrefs>()
                                                      .getToken() ==
                                                      null) {
                                                    navigatorToPush(
                                                        context:
                                                        context,
                                                        pageName:
                                                        LoginScreen(
                                                          isNeedIconBac:
                                                          true,
                                                        ));
                                                  } else {
                                                    if (DIManager.findDep<
                                                        SharedPrefs>()
                                                        .getStatusUserIsBlocked() ==
                                                        0) {
                                                      SnackBarHelper
                                                          .mySnackBarError(
                                                          'الحساب محظور لايمكنك الدردشة ..',
                                                          context);
                                                      return;
                                                    }
                                                    List<
                                                        String> words = widget
                                                        .communityPostModel![
                                                    index]
                                                        .content
                                                        ?.split(
                                                        ' ') ??
                                                        [
                                                          ''
                                                        ]; // تقسيم النص إلى كلمات
                                                    String
                                                    firstThreeWords =
                                                    words
                                                        .take(3)
                                                        .join(
                                                        ' '); // أخذ أول ثلاث كلمات ودمجها

                                                    navigatorToPush(
                                                        context:
                                                        context,
                                                        pageName:
                                                        ChatMessagesPost(
                                                          dataMessage:
                                                          ArgumentMessage(
                                                            nameOwnerAds: widget
                                                                .communityPostModel![
                                                            index]
                                                                .name,
                                                            nameAds:
                                                            firstThreeWords,
                                                            imageAds: widget
                                                                .communityPostModel![
                                                            index]
                                                                .image,
                                                            imageCompany: widget
                                                                .communityPostModel![
                                                            index]
                                                                .profilePic,
                                                            imageUser: DIManager.findDep<SharedPrefs>()
                                                                .getImageProfile()
                                                                .toString()
                                                                .contains(
                                                                'http')
                                                                ? DIManager.findDep<SharedPrefs>()
                                                                .getImageProfile()
                                                                .toString()
                                                                : AppEndpoints.baseUrlWithoutApi +
                                                                DIManager.findDep<SharedPrefs>().getImageProfile().toString(),
                                                            ad_id: int.parse(widget
                                                                .communityPostModel![
                                                            index]
                                                                .id
                                                                .toString()),
                                                            idBannerOrProduct: int.parse(widget
                                                                .communityPostModel![
                                                            index]
                                                                .id
                                                                .toString()),
                                                            user_id: DIManager.findDep<
                                                                SharedPrefs>()
                                                                .getUserID(),
                                                            user_id_2: int.parse(widget
                                                                .communityPostModel![
                                                            index]
                                                                .userId
                                                                .toString()),
                                                            idAdOnwerCompany: widget
                                                                .communityPostModel![
                                                            index]
                                                                .userId
                                                                .toString(),
                                                            isBanner:
                                                            false,
                                                            isBannerInOut:
                                                            false,
                                                            categoryId:
                                                            '2',
                                                            user_name_person_sender: DIManager.findDep<SharedPrefs>().getAccountType() ==
                                                                'individual'
                                                                ? DIManager.findDep<SharedPrefs>()
                                                                .getUserName()
                                                                : DIManager.findDep<SharedPrefs>()
                                                                .getUserNameCompany(),
                                                          ),
                                                        ));
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    // Icon(
                                                    //   Icons.chat,
                                                    //   size: 25.sp,
                                                    // ),
                                                    CustomImageView(
                                                      imagePath:
                                                      ImageConstant
                                                          .chatPost,
                                                      height: 25.h,
                                                      width: 25.h,
                                                      color: appTheme
                                                          .black900,
                                                    ),
                                                    SizedBox(
                                                      width: 12.w,
                                                    ),
                                                    textNormal(
                                                      text: 'دردشة',
                                                      // ' 33 تعليق',
                                                      fontSize:
                                                      AppFontSize
                                                          .fontSize_10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          }
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.company == '1') ...{
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.h,
                                  left: 30.w,
                                  right: 3.w,
                                  bottom: 5.h),
                              child: Container(
                                decoration: AppDecoration.fillWhiteA.copyWith(
                                    color: widget.communityPostModel![index]
                                        .status ==
                                        '0'
                                        ? Colors.yellow
                                        : widget.communityPostModel![index]
                                        .status ==
                                        '1'
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(20.r)),
                                width: 50.w,
                                height: 20.w,
                                child: Center(
                                  child: textNormal(
                                      color: widget.communityPostModel![index]
                                          .status ==
                                          '0'
                                          ? Colors.black
                                          : Colors.white,
                                      text: widget.communityPostModel![index]
                                          .status ==
                                          '0'
                                          ? 'قيد الانتظار'
                                          : widget.communityPostModel![index]
                                          .status ==
                                          '1'
                                          ? 'فعال'
                                          : (widget
                                              .communityPostModel![
                                          index]
                                              .status ==
                                          '2' || widget
                                          .communityPostModel![
                                      index]
                                          .status ==
                                          '3')
                                          ? 'مرفوض'
                                          : "",
                                      fontSize: AppFontSize.fontSize_8),
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                    );
                  }),
            );
          },

        );
      },
    );

  }

  bool isClickLikePost = false;

  void _toggleLike(int index, int likesCount) {
    bool isTrueLikePost = widget.communityPostModel![index].isLikePost!;

    setState(() {
      if (likesCount == 0) {
        counterPostAllLikes[index] = isTrueLikePost ? 1 : 0;
      } else {
        if (likesCount != 0 && !isTrueLikePost) {
          if (!isClickLikePost) {
            counterPostAllLikes[index] = -1;
          } else {
            counterPostAllLikes[index] = 0;
          }
          isClickLikePost = !isClickLikePost;
        } else {
          if (!isClickLikePost) {
            counterPostAllLikes[index] = 1;
          } else {
            counterPostAllLikes[index] = 0;
          }
          isClickLikePost = !isClickLikePost;
        }
      }
    });
  }

  int sum(int a, int b) {
    return a + b;
  }

}

class PostLikeInfo {
  bool isLiked;
  int likeCount;

  PostLikeInfo({required this.isLiked, required this.likeCount});
}
void showDeletePostPostEdit(BuildContext context, String idPost,) {
  showDialog(
    context: context,
    builder: (BuildContext context2) {
      double rating = 0.0;
      return StatefulBuilder(
        builder: (BuildContext context3, StateSetter setState) {
          return AlertDialog(
            backgroundColor: appTheme.buttonColor,
            title: Text(
              'هل أنت متأكد من حذف المنشور ؟',
              style: themeLite.textTheme.titleSmall,
            ),
            content: Container(
              height: 40.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    text: 'إلغاء',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    width: 90.w,
                  ),
                  sizeWidthNormal(),
                  // Moved BlocConsumer here for the correct context usage
                  BlocConsumer<CommunityCubit, CommunityState>(
                    listener: (context, state) {
                      if (state is SuccessDeletePostState) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                          // navigatorToPushReplacement(
                          //     context: context, pageName: CommunityPage());

                        SnackBarHelper.mySnackBarSuccess(state.data.message, context);
                      }
                    },
                    builder: (context, state) {
                      return CustomElevatedButton(
                        text: 'حذف',
                        onPressed: (){
                          BlocProvider.of<CommunityCubit>(
                              context)
                              .deletePost(
                              idPost: int.parse(idPost),
                              indexPost: 0);
                        },
                        width: 90.w,
                        child: state is LoadingDeletePostState
                            ? loadingButton(
                          color: appTheme.greenColor
                        )  // Show loading state
                            : null,  // Show normal button
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

