// import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// import 'package:just_audio_background/just_audio_background.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/theme/theme_text_form_field.dart';
import 'package:syrians_in_uae/widgets/comments_shimmer.dart';
import 'package:syrians_in_uae/widgets/community_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/widgets/user_image_profile.dart';
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
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../chats/chat_messages_ad.dart';
import '../chats/chat_messages_post.dart';
import '../company/company_details_page.dart';
import '../parts_voice/widget/control_button.dart';
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
import 'list_coummunity.dart';

import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';

class PostScreen extends StatefulWidget {
  PostScreen(
      {super.key,
      this.communityPostModel,
      this.page,
      required this.idPost,
      this.hashtag,
      this.isFromHashtagScreen = false,
      this.isFromHomePage = false});

  CommunityModelDatum? communityPostModel;
  int? page;
  int? idPost;
  bool isFromUserPage = false;
  bool isFromHomePage = false;
  bool isFromHashtagScreen = false;
  String? hashtag;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with WidgetsBindingObserver {
  bool isLoadingDelete = false;

  final FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  TextEditingController controllerEdit = TextEditingController();
  bool isPostLiked = false;
  late List<CommentsListModel> commentsList = [];
  bool isLoadingComments = true;
  bool isLoading = true;
  String color = '0xffF5A623';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int page = 1;
  int counter = 0;
  bool isPostEmpty = false;
  final AudioPlayer _player = AudioPlayer();

  bool isPlaying = true;

  double _currentPosition = 0.0;

  double _totalDuration = 1.0;

  Future<void> _playRecording(String url) async {
    try {
      setState(() {
        isPlaying = false;
      });

      // إعداد مصدر الصوت مع MediaItem
      // await _player.setAudioSource(
      //   AudioSource.uri(
      //     Uri.parse(url),
      //     tag: MediaItem(
      //       id: url, // معرف فريد للصوت
      //       title: 'Recording', // يمكنك استخدام عنوان مناسب
      //       artist: 'Unknown', // يمكنك استخدام اسم الفنان إذا كان متاحًا
      //     ),
      //   ),
      // );

      // بدء التشغيل
      _player.play();

      // متابعة الموضع الحالي للصوت
      _player.positionStream.listen((position) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });
      });

      // التحقق من انتهاء التشغيل
      _player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = true;
          });
        }
      });
    } catch (e) {
      print("Error during playback: $e");
    }
  }

  Future<void> _stopPlay(String url) async {
    try {
      setState(() {
        isPlaying = true;
        _currentPosition = 0; // إعادة الموضع إلى البداية
      });

      // إعداد مصدر الصوت مع MediaItem
      // await _player.setAudioSource(
      //   AudioSource.uri(
      //     Uri.parse(url),
      //     tag: MediaItem(
      //       id: url,
      //       title: 'Recording',
      //       artist: 'Unknown',
      //     ),
      //   ),
      // );

      // إيقاف التشغيل
      await _player.stop();
    } catch (e) {
      print("Error stopping playback: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.communityPostModel!.voice.toString()),
          // tag: MediaItem(playable: true,isLive: false,
          //   id: widget.communityPostModel!.voice.toString(), // معرف فريد للصوت
          //   title: 'Recording', // يمكنك استخدام عنوان مناسب
          //   artist: 'Unknown', // يمكنك استخدام اسم الفنان إذا كان متاحًا
          // ),
        ),
      );
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void initState() {
    _init();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    super.initState();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    print(widget.idPost);
    print(widget.idPost);

    var lang = Localizations.localeOf(context).languageCode;
    print(widget.idPost);
    return BlocProvider(
      create: (context) {
        if (widget.communityPostModel == null) {
          return CommunityCubit()
            ..getPostById(idPost: widget.idPost!)
            ..getCommentsByIdPosts(
                idPost: widget.idPost.toString(), page: 1, isLoadMore: false);
        } else {
          isLoading = false;
          // isLoadingComments = false;
          commentsList.clear();
          print(commentsList.length);
          // commentsList = widget.communityPostModel!.comments!;
          print(commentsList.length);
          return CommunityCubit()
            ..getCommentsByIdPosts(
                idPost: widget.communityPostModel!.id.toString(),
                page: 1,
                isLoadMore: false);
        }
      },
      child: BlocConsumer<CommunityCubit, CommunityState>(
        listener: (context, state) {
          ///Loading
          if (state is LoadingGetPostByIdState) {
            isLoading = true;
          }

          if (state is LoadingGetCommentsByIdPostsState) {
            commentsList = [];
            isLoadingComments = true;
          }

          ///Success
          if (state is SuccessGetPostByIdState) {
            if (state.data.data.isNotEmpty) {
              widget.communityPostModel = state.data.data[0];
              commentsList = state.data.data![0].comments!;
              buttonCounter = state.data.data[0].isHaveComment.toString();
            } else {
              isPostEmpty = true;
            }

            isLoading = false;
          }
          if (state is SuccessDeleteCommentState) {
            commentsList.removeAt(state.indexComment);
            // isLoadingComments = true;
            print('commentsList: ${commentsList.length}');
            print('commentsList: ${commentsList.length}');
          }
          if (state is SuccessAddCommentState) {
            controller.clear();
            controller.text = '';

            // إضافة العنصر في بداية القائمة
            commentsList.insert(0, state.data.comment!);
            print(commentsList);
            print('commentsList: ${commentsList.length}');
            if (commentsList.length == 1) {
              CommunityCubit.get(context).getCommentsByIdPosts(
                idPost: widget.idPost.toString(),
                page: 1,
                isLoadMore: false,
              );
            }
          }

          if (state is SuccessDeletePostState) {
            Navigator.pop(context);
            SnackBarHelper.mySnackBarSuccess(state.data.message, context);
            navigatorToPushReplacement(
                context: context, pageName: CommunityPage());
          }

          if (state is SuccessGetCommentsByIdPostsState) {
            commentsList.addAll(state.data.data!.data);
            isLoadingComments = false;
            for (int index = 0; index < commentsList.length; index++) {
              controllerEdit.text = commentsList[index].content!;
              buttonCounter = commentsList[index].isHaveComment.toString();
            }
          }

          if (state is SuccessEditCommentState) {
            commentsList[state.indexComment].content =
                state.data.comment!.content;
          }

          /// Error
          if (state is ErrorDeletePostState) {
            isLoadingDelete = false;
            SnackBarHelper.mySnackBarError(state.message, context);
          }
          if (state is ErrorGetCommentsByIdPostsState) {
            isLoadingComments = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textNormal(text:state.message.toString()),
              ),
            );
          }

          if (state is ErrorGetPostByIdState) {
            SnackBarHelper.mySnackBarError(state.message.toString(), context);
            isLoading = false;
          }
          if (state is ErrorEditCommentState) {
            SnackBarHelper.mySnackBarError(state.message.toString(), context);
          }
          if (state is ErrorDeleteCommentState) {
            SnackBarHelper.mySnackBarError(state.message.toString(), context);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: HandelAndroidApp(
              child: Scaffold(
                appBar: appBarNormalWithIcon(
                    text: ' المنشور', context: context, isShowBack: true),
                body: Column(
                  children: [
                    if (DIManager.findDep<SharedPrefs>().getToken() == null) ...{
                      Container(
                        height: 58.h,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        color: appTheme.deepPurpleA10001,
                        child: SizedBox(
                          height: 25.h,
                          child: Marquee(
                            textDirection: lang == 'ar'
                                ? TextDirection.ltr
                                : TextDirection.ltr,
                            text:
                                '    من أجل النشر والتفاعل عليك تسجيل الدخول أولاً',
                            style:
                                Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontSize: AppFontSize.fontSize_12,
                                    ),
                          ),
                        ),
                      )
                    },
                    Expanded(
                      child: SmartRefreshWidget(
                        onRefresh: () async {
                          page = 1;
                          await BlocProvider.of<CommunityCubit>(context)
                              .getPostById(idPost: widget.idPost!);
                          _refreshController.refreshCompleted();
                        },
                        controller: _refreshController,
                        onLoading: () async {
                          page++;
                          await BlocProvider.of<CommunityCubit>(context)
                              .getCommentsByIdPosts(
                                  idPost:
                                      widget.communityPostModel!.id.toString(),
                                  page: page,
                                  isLoadMore: true);
                          _refreshController.loadComplete();
                        },
                        child: Container(
                          child: isLoading
                              ? CommunityShimmer(isFromPostPage: true)
                              : isPostEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        textNormal(text: 'المنشور محذوف ..'),
                                      ],
                                    )
                                  : isLoadingDelete
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            textNormal(
                                                text: 'جاري حذف المنشور',
                                                fontSize: AppFontSize.fontSize_12,
                                                fontWeight: FontWeight.w500),
                                            sizeHeightNormal(),
                                            loaderNormal(),
                                          ],
                                        )
                                      : widget.communityPostModel == null
                                          ? Container()
                                          : SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    decoration: widget
                                                            .isFromHomePage
                                                        ? AppDecoration
                                                            .outlineBlueGray
                                                            .copyWith(
                                                            boxShadow: [],
                                                            color: widget.communityPostModel!.type ==
                                                                        'A' &&
                                                                    widget.communityPostModel!
                                                                            .background !=
                                                                        null
                                                                ? widget.communityPostModel!
                                                                        .background!
                                                                        .contains(
                                                                            '0xff')
                                                                    ? Color(int.parse(widget.communityPostModel!.background.toString()))
                                                                        .withOpacity(
                                                                            .8)
                                                                    : widget.communityPostModel!
                                                                            .background!
                                                                            .contains(
                                                                                '#')
                                                                        ? Color(int.parse('0xff${colorWithoutHashtag(widget.communityPostModel!.background!)}'))
                                                                            .withOpacity(
                                                                                .8)
                                                                        : Color(int.parse("0xff${widget.communityPostModel!.background}"))
                                                                            .withOpacity(.8)
                                                                : appTheme.lightBlue100,
                                                          )
                                                        : null,
                                                    color: widget.isFromHomePage
                                                        ? null
                                                        : widget.communityPostModel!
                                                                        .type ==
                                                                    'A' &&
                                                                widget.communityPostModel!
                                                                        .background !=
                                                                    null
                                                            ? widget.communityPostModel!
                                                                    .background!
                                                                    .contains(
                                                                        '0xff')
                                                                ? Color(int.parse(widget
                                                                        .communityPostModel!
                                                                        .background
                                                                        .toString()))
                                                                    .withOpacity(
                                                                        .8)
                                                                : widget.communityPostModel!
                                                                        .background!
                                                                        .contains('#')
                                                                    ? Color(int.parse('0xff${colorWithoutHashtag(widget.communityPostModel!.background!)}')).withOpacity(.8)
                                                                    : Color(int.parse("0xff${widget.communityPostModel!.background}")).withOpacity(.8)
                                                            : appTheme.lightBlue100,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 3.h),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.sp),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              UserImageProfile(
                                                                imageUrl: widget
                                                                    .communityPostModel!
                                                                    .profilePic
                                                                    .toString(),
                                                                onTap: () {
                                                                  navigatorToPush(
                                                                      context:
                                                                      context,
                                                                      pageName:
                                                                      CompanyDetailsPage(
                                                                        idCompany: int.parse(widget
                                                                            .communityPostModel!
                                                                            .userId
                                                                            .toString()),
                                                                      ));
                                                                },
                                                              ),
                                                              SizedBox(
                                                                width: 5.sp,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  textNormal(
                                                                      text: widget
                                                                              .communityPostModel!
                                                                              .name ??
                                                                          '',
                                                                      fontSize:
                                                                          AppFontSize
                                                                              .fontSize_15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textNormal(
                                                                      text: widget.communityPostModel!.acceptDate ==
                                                                              null
                                                                          ? ''
                                                                          : getComparedTime(widget.communityPostModel!.acceptDate!) ??
                                                                              '',
                                                                      fontSize:
                                                                          AppFontSize
                                                                              .fontSize_11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              widget.communityPostModel!
                                                                          .userId ==
                                                                      DIManager.findDep<
                                                                              SharedPrefs>()
                                                                          .getUserID()
                                                                  ? PopupMenuButton(
                                                                      color: appTheme
                                                                          .lightBlueBottomNavigatorBar,
                                                                      child:
                                                                          CustomImageView(
                                                                        imagePath:
                                                                            ImageConstant
                                                                                .iconList,
                                                                        height:
                                                                            15.h,
                                                                        width:
                                                                            15.h,
                                                                        color: appTheme
                                                                            .deepPurpleA10002,
                                                                      ),
                                                                      itemBuilder:
                                                                          (BuildContext
                                                                                  context) =>
                                                                              [
                                                                        PopupMenuItem(
                                                                          value:
                                                                              'delete',
                                                                          child: textNormal(
                                                                              text:
                                                                                  'حذف'),
                                                                        ),
                                                                        if (widget
                                                                                .communityPostModel!
                                                                                .type !=
                                                                            "D") ...{
                                                                          PopupMenuItem(
                                                                            value:
                                                                                'Edit',
                                                                            child:
                                                                                textNormal(text: 'تعديل'),
                                                                          ),
                                                                        }
                                                                      ],
                                                                      onSelected:
                                                                          (value) {
                                                                        if (value ==
                                                                            "delete") {
                                                                          showDeletePostPostEdit(
                                                                              context,widget.communityPostModel!.id.toString());
                                                                        }

                                                                        if (value ==
                                                                            "Edit") {
                                                                          navigatorToPush(
                                                                              context:
                                                                                  context,
                                                                              pageName:
                                                                                  EditPostScreen(
                                                                                postModel: widget.communityPostModel!,isFromPostScreen: true,
                                                                              ));
                                                                        }
                                                                      },
                                                                    )
                                                                  : widget.communityPostModel!
                                                                              .pin ==
                                                                          '1'
                                                                      ? Container(
                                                                          child:
                                                                              CustomImageView(
                                                                          imagePath:
                                                                              ImageConstant.pinIcon,
                                                                          height:
                                                                              15.h,
                                                                          width:
                                                                              15.h,
                                                                          color: appTheme
                                                                              .red300,
                                                                        ))
                                                                      : Container(),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        12.h),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text: widget
                                                                              .communityPostModel!
                                                                              .content ??
                                                                          '',
                                                                      style: themeLite
                                                                          .textTheme
                                                                          .bodyMedium),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          if (widget
                                                                  .communityPostModel!
                                                                  .type ==
                                                              'A') ...[
                                                            for (int i = 0;
                                                                i <
                                                                    widget
                                                                        .communityPostModel!
                                                                        .hashtags!
                                                                        .length;
                                                                i++) ...{
                                                              widget
                                                                  .communityPostModel!
                                                                  .hashtags[
                                                              i]
                                                                  .toString() =='null'?Container():  InkWell(
                                                                onTap: () {
                                                                  navigatorToPush(
                                                                      context:
                                                                          context,
                                                                      pageName:
                                                                          HashtagScreen(
                                                                        hashtagName: widget
                                                                            .communityPostModel!
                                                                            .hashtags[
                                                                                i]
                                                                            .toString(),
                                                                      ));
                                                                },
                                                                child: textNormal(
                                                                    text: widget
                                                                        .communityPostModel!
                                                                        .hashtags[
                                                                            i]
                                                                        .toString(),
                                                                    fontSize:
                                                                        AppFontSize
                                                                            .fontSize_12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: appTheme
                                                                        .deepPurpleA100),
                                                              ),
                                                            },
                                                          ] else ...[
                                                            for (int i = 0;
                                                                i <
                                                                    widget
                                                                        .communityPostModel!
                                                                        .hashtags!
                                                                        .length;
                                                                i++) ...{
                                                              widget
                                                                  .communityPostModel!
                                                                  .hashtags[
                                                              i]
                                                                  .toString() =='null'?Container():    InkWell(
                                                                onTap: () {
                                                                  navigatorToPush(
                                                                      context:
                                                                          context,
                                                                      pageName:
                                                                          HashtagScreen(
                                                                        hashtagName: widget
                                                                            .communityPostModel!
                                                                            .hashtags[
                                                                                i]
                                                                            .toString(),
                                                                      ));
                                                                },
                                                                child: textNormal(
                                                                    text: widget
                                                                        .communityPostModel!
                                                                        .hashtags[
                                                                            i]
                                                                        .toString(),
                                                                    fontSize:
                                                                        AppFontSize
                                                                            .fontSize_12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: appTheme
                                                                        .deepPurpleA100),
                                                              ),
                                                            },
                                                            sizeHeightNormal(
                                                                height: 6.h),
                                                            if (widget
                                                                    .communityPostModel!
                                                                    .type ==
                                                                'B') ...[
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            12.h),
                                                                child: Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration: AppDecoration
                                                                        .outlinePurple
                                                                        .copyWith(
                                                                      boxShadow: [],
                                                                    ),
                                                                    child:
                                                                        CustomImageView(
                                                                      imagePath: widget
                                                                              .communityPostModel!
                                                                              .image ??
                                                                          '',
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      radius: BorderRadius
                                                                          .circular(
                                                                              25.r),
                                                                    )),
                                                              ),
                                                            ] else if (widget
                                                                    .communityPostModel!
                                                                    .type ==
                                                                'C') ...[
                                                              imageFromUrlVideo(
                                                                  link: widget
                                                                      .communityPostModel!
                                                                      .video!,
                                                                  onTap: () {
                                                                    navigatorToPush(
                                                                        context:
                                                                            context,
                                                                        pageName:
                                                                            UrlWebViewPage(
                                                                          titleAppBer:
                                                                              '',
                                                                          urlPage:
                                                                              widget.communityPostModel!.video ??
                                                                                  '',
                                                                        ));
                                                                  }),
                                                            ]
                                                          ],
                                                          if (widget
                                                                  .communityPostModel!
                                                                  .type ==
                                                              'D') ...{
                                                            Center(
                                                              child:
                                                                  ControlButtons(
                                                                _player,
                                                                isFromPost: true,
                                                              ),
                                                            ),
                                                            StreamBuilder<
                                                                PositionData>(
                                                              stream:
                                                                  _positionDataStream,
                                                              builder: (context,
                                                                  snapshot) {
                                                                final positionData =
                                                                    snapshot.data;
                                                                return SeekBar(
                                                                  duration: positionData
                                                                          ?.duration ??
                                                                      Duration
                                                                          .zero,
                                                                  position: positionData
                                                                          ?.position ??
                                                                      Duration
                                                                          .zero,
                                                                  bufferedPosition:
                                                                      positionData
                                                                              ?.bufferedPosition ??
                                                                          Duration
                                                                              .zero,
                                                                  onChangeEnd:
                                                                      _player
                                                                          .seek,
                                                                );
                                                              },
                                                            ),
                                                            // Padding(
                                                            //   padding: EdgeInsets
                                                            //       .symmetric(
                                                            //           vertical:
                                                            //               5.h),
                                                            //   child: ChatBubble(
                                                            //     clipper: ChatBubbleClipper9(
                                                            //         type: BubbleType
                                                            //             .receiverBubble),
                                                            //     // alignment: Alignment.topRight,
                                                            //     // margin: EdgeInsets.only(top: 20),
                                                            //
                                                            //     backGroundColor:
                                                            //         Colors.blueGrey
                                                            //             .withOpacity(
                                                            //                 .4),
                                                            //     child: Row(
                                                            //       crossAxisAlignment:
                                                            //           CrossAxisAlignment
                                                            //               .center,
                                                            //       children: [
                                                            //         Container(
                                                            //           width: MediaQuery.of(context).size.width * 0.6,
                                                            //           child: Slider(
                                                            //             value: _currentPosition.clamp(0.0, _totalDuration), // Ensures value stays within bounds
                                                            //             max: _totalDuration > 0.0 ? _totalDuration : 1.0, // Prevents max from being 0.0
                                                            //             onChanged: _totalDuration > 0.0 // Enable slider only if there's a valid duration
                                                            //                 ? (value) {
                                                            //               setState(() {
                                                            //                 _currentPosition = value;
                                                            //               });
                                                            //               _player.seek(Duration(seconds: value.toInt()));
                                                            //             }
                                                            //                 : null,
                                                            //           ),
                                                            //         ),
                                                            //
                                                            //         isPlaying
                                                            //             ? Text(formatDuration(double.parse(widget
                                                            //                     .communityPostModel!
                                                            //                     .voice_time ??
                                                            //                 _totalDuration
                                                            //                     .toString())))
                                                            //             : Text(formatDuration(
                                                            //                 _currentPosition)),
                                                            //         sizeWidthNormal(),
                                                            //         InkWell(
                                                            //           onTap: () {
                                                            //             isPlaying
                                                            //                 ? _playRecording(widget
                                                            //                     .communityPostModel!
                                                            //                     .voice.toString())
                                                            //
                                                            //                 : _stopPlay(widget
                                                            //                     .communityPostModel!
                                                            //                     .voice.toString());
                                                            //           },
                                                            //           child: Icon(
                                                            //             isPlaying
                                                            //                 ? Icons
                                                            //                     .play_arrow
                                                            //                 : Icons
                                                            //                     .stop,
                                                            //             color: appTheme
                                                            //                 .black900,
                                                            //           ),
                                                            //         ),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          },
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 10.h,
                                                              right: 10.w,
                                                              left: 10.w,
                                                            ),
                                                            child: Container(
                                                              // width: 250.w,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (DIManager.findDep<SharedPrefs>()
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
                                                                        BlocProvider.of<CommunityCubit>(context).likePost(
                                                                            idPost: int.parse(widget
                                                                                .communityPostModel!
                                                                                .id
                                                                                .toString()),
                                                                            isFromUserPage: widget
                                                                                .isFromUserPage,
                                                                            hashtag: widget
                                                                                .hashtag,
                                                                            isSearchHashtag:
                                                                                widget.isFromHashtagScreen);

                                                                        setState(
                                                                            () {
                                                                          if (widget.communityPostModel!.isLikePost ==
                                                                              true) {
                                                                            widget
                                                                                .communityPostModel!
                                                                                .isLikePost = false;
                                                                            // counter = 0;
                                                                            print(widget
                                                                                .communityPostModel!
                                                                                .likesCount!);
                                                                            widget.communityPostModel!.likesCount! == 0
                                                                                ? widget.communityPostModel!.likesCount = 0
                                                                                : widget.communityPostModel!.likesCount = widget.communityPostModel!.likesCount! - 1;
                                                                            print(widget
                                                                                .communityPostModel!
                                                                                .likesCount!);
                                                                            // postAllLikes = false;
                                                                          } else {
                                                                            widget
                                                                                .communityPostModel!
                                                                                .isLikePost = true;
                                                                            widget
                                                                                .communityPostModel!
                                                                                .likesCount = widget
                                                                                    .communityPostModel!.likesCount! +
                                                                                1;
                                                                            // postAllLikes = true;
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        CustomImageView(
                                                                          imagePath:widget.communityPostModel!.isLikePost ==
                                                                              true
                                                                              ? ImageConstant
                                                                              .likeIcon
                                                                              : ImageConstant
                                                                              .unlikeIcon,
                                                                          color: widget.communityPostModel!.isLikePost ==
                                                                                  true
                                                                              ? appTheme.deepPurpleA100
                                                                              : appTheme.black900,
                                                                          height:
                                                                              25.sp,
                                                                          width: 25
                                                                              .sp,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              12.w,
                                                                        ),
                                                                        textNormal(
                                                                          text:
                                                                              '${sum(widget.communityPostModel!.likesCount!, counter)} أعجبني',
                                                                          fontSize:
                                                                              AppFontSize.fontSize_10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  widget.communityPostModel!
                                                                              .isHaveComment
                                                                              .toString() ==
                                                                          '0'
                                                                      ? Container()
                                                                      : InkWell(
                                                                          onTap:
                                                                              () {
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
                                                                            //               .data
                                                                            //               .id
                                                                            //               .toString(),),
                                                                            //       commentsList: widget.communityPostModel!
                                                                            //           .data
                                                                            //           .comments,
                                                                            //       );
                                                                            //     });
                                                                            if (DIManager.findDep<SharedPrefs>().getToken() ==
                                                                                null) {
                                                                              navigatorToPush(
                                                                                  context: context,
                                                                                  pageName: LoginScreen(
                                                                                    isNeedIconBac: true,
                                                                                  ));
                                                                            } else {
                                                                              showModalBottomSheet(
                                                                                  context: context,
                                                                                  isScrollControlled: true,
                                                                                  builder: (BuildContext bc) {
                                                                                    return CommentsPostScreen(
                                                                                      idPost: int.parse(
                                                                                        widget.communityPostModel!.id.toString(),
                                                                                      ),
                                                                                      idUserCreatePost: int.parse(widget.communityPostModel!.userId!),
                                                                                      isHaveGroup: widget.communityPostModel!.is_content_group!,
                                                                                      // commentsList: widget
                                                                                      //     .communityPostModel![
                                                                                      //         index]
                                                                                      //     .comments,
                                                                                    );
                                                                                  });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.chat_outlined,
                                                                                size: 25.sp,         color: appTheme.black900,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 12.w,
                                                                              ),
                                                                              textNormal(
                                                                                text: '${widget.communityPostModel!.comments.length} تعليق',
                                                                                // ' 33 تعليق',
                                                                                fontSize: AppFontSize.fontSize_10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                  if (DIManager.findDep<
                                                                              SharedPrefs>()
                                                                          .getIfUsersCanChatsCommunity() ==
                                                                      1) ...{
                                                                    widget.communityPostModel!
                                                                                .is_have_chat
                                                                                .toString() ==
                                                                            '0'
                                                                        ? Container()
                                                                        : widget.communityPostModel!.userId.toString() ==
                                                                                DIManager.findDep<SharedPrefs>().getUserID()
                                                                            ? Container()
                                                                            : Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                                                                    //               .data
                                                                                    //               .id
                                                                                    //               .toString(),),
                                                                                    //       commentsList: widget.communityPostModel!
                                                                                    //           .data
                                                                                    //           .comments,
                                                                                    //       );
                                                                                    //     });
                                                                                    if (DIManager.findDep<SharedPrefs>().getToken() == null) {
                                                                                      navigatorToPush(
                                                                                          context: context,
                                                                                          pageName: LoginScreen(
                                                                                            isNeedIconBac: true,
                                                                                          ));
                                                                                    } else {
                                                                                      if (DIManager.findDep<SharedPrefs>().getStatusUserIsBlocked() == 0) {
                                                                                        SnackBarHelper.mySnackBarError('الحساب محظور لايمكنك الدردشة ..', context);
                                                                                        return;
                                                                                      }
                                                                                      navigatorToPush(
                                                                                          context: context,
                                                                                          pageName: ChatMessagesPost(
                                                                                            dataMessage: ArgumentMessage(
                                                                                              nameOwnerAds: widget.communityPostModel!.name,
                                                                                              nameAds: widget.communityPostModel!.content,
                                                                                              imageAds: widget.communityPostModel!.image,
                                                                                              imageCompany: widget.communityPostModel!.profilePic,
                                                                                              imageUser: DIManager.findDep<SharedPrefs>().getImageProfile().toString().contains('http') ? DIManager.findDep<SharedPrefs>().getImageProfile().toString() : AppEndpoints.baseUrlWithoutApi + DIManager.findDep<SharedPrefs>().getImageProfile().toString(),
                                                                                              ad_id: int.parse(widget.communityPostModel!.id.toString()),
                                                                                              idBannerOrProduct: int.parse(widget.communityPostModel!.id.toString()),
                                                                                              user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                                                                                              user_id_2: int.parse(widget.communityPostModel!.userId.toString()),
                                                                                              idAdOnwerCompany: widget.communityPostModel!.userId.toString(),
                                                                                              isBanner: false,
                                                                                              isBannerInOut: false,
                                                                                              categoryId: '2',
                                                                                              user_name_person_sender: DIManager.findDep<SharedPrefs>().getAccountType() == 'individual' ? DIManager.findDep<SharedPrefs>().getUserName() : DIManager.findDep<SharedPrefs>().getUserNameCompany(),
                                                                                            ),
                                                                                          ));
                                                                                    }
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      CustomImageView(
                                                                                        imagePath: ImageConstant.chatPost,
                                                                                        height: 25.h,
                                                                                        width: 25.h,color: appTheme
                                                                                          .black900,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 12.w,
                                                                                      ),
                                                                                      textNormal(
                                                                                        text: 'دردشة',
                                                                                        // ' 33 تعليق',
                                                                                        fontSize: AppFontSize.fontSize_10,
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
                                                  isLoadingComments
                                                      ? CommentsShimmer()
                                                      : CommentsPostScreen(
                                                          idPost: widget.idPost!,
                                                          isHaveGroup: widget
                                                              .communityPostModel!
                                                              .is_content_group!,
                                                          idUserCreatePost:
                                                              int.parse(widget
                                                                  .communityPostModel!
                                                                  .userId!),
                                                          commentsList:
                                                              commentsList,
                                                          isFromPostPage: true),
                                                ],
                                              ),
                                            ),
                        ),
                      ),
                    ),
                    if (DIManager.findDep<SharedPrefs>().getToken() != null &&
                        widget.communityPostModel?.isHaveComment == '1') ...{
                      // Divider(
                      //   color: appTheme.black900,
                      //     thickness: 0.4,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Container(
                          width: 365.w,
                          decoration: AppDecoration.pointChoose.copyWith(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ThemeTextFormField(
                              child: TextFormField(
                                controller: controller,
                                focusNode: _focusNode,
                                maxLines: controller.text.split('\n').length > 3 ||
                                        controller.text.length > 150
                                    ? 4
                                    : null,
                                style: themeLite.textTheme.titleSmall!.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'إضافة تعليق ..',
                                  hintStyle: TextStyle(
                                      fontSize: 10.sp, color: Colors.grey),
                                  prefixIcon: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(
                                      minWidth: 24.w, // عرض صغير للأيقونة
                                      minHeight: 24.h, // ارتفاع صغير للأيقونة
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<CommunityCubit>(context)
                                          .addComment(
                                        idPost: int.parse(widget.idPost.toString()),
                                        content: controller.text,
                                      );
                                      controller.clear();
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.black,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                    horizontal:
                                        5.w, // تقليل المسافة بين النص والأيقونة
                                  ),
                                  counterStyle: TextStyle(
                                    color: appTheme.black900,
                                    fontSize: 10,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    }
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String buttonCounter = '1';

  int sum(int a, int b) {
    return a + b;
  }
}
