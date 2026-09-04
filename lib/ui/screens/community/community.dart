import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/chats/cubit/apis_chat_firebase.dart';
import 'package:syrians_in_uae/ui/screens/community/search_post_screen.dart';
import 'package:syrians_in_uae/ui/screens/community/widget/error_page.dart';
import 'package:syrians_in_uae/ui/screens/community/widget/hashtag_widget.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/ui/theme/theme_text_form_field.dart';
import 'package:syrians_in_uae/widgets/custom_elevated_button.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:record/record.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/helper/snack_bar_helper.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/image_constant.dart';
import '../../../data/models/community/community_post_model.dart';
import '../../../data/models/community/hashtag_model.dart';
import '../../../data/models/parts_voice/common.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../auth/login/login_screen.dart';
import '../chats/chat_messages_ad.dart';
import '../../../widgets/community_shimmer.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/file_compress.dart';
import '../../theme/app_decoration.dart';
import 'cubit/community_cubit.dart';
import 'hashtag_screen.dart';
import 'list_coummunity.dart';
import 'package:rxdart/rxdart.dart';

import 'notice_to_users.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage();

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController? controllerUrlAds = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;
  List<String> idHashtag = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final FocusNode _secondFocusNode = FocusNode();
  List<CommunityModelDatum>? communityPostModel = [];
  bool isLoading = true;
  int page = 1;
  bool isLoadingHashtag = true;
  bool isError = false;
  List<bool> isSelectAvailableList =
      List.generate(100, (index) => index == 0 ? true : false);
  int checkIndexColors = 6;
  String colorsChoose = 'null';
  AllHashtagModel? allHashtagModel;
  List<Hashtag> hashtagModel = [];
  int isHaveComment = 1;
  int isHaveChat = 0;
  int isHaveChatGroup = 0;
  List<String> colorsBackground = [];
  bool _isSwitchedComment = true;
  bool _isSwitchedChat = false;
  bool _isSwitchedChatGroup = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _filePath;
  double _totalDuration = 0;
  bool _isRecordingForTextFormFiled = false;
  bool _isStopRecording = false;
  bool _isDoneRecording = false;

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      print('Permission not granted for recording.');
      return;
    }

    // بدء المؤقت
    startTimer();

    // إعداد المتغيرات المبدئية
    _isStopRecording = false;

    // تحديد مسار الملف في دليل المستندات
    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';

    // إعدادات التسجيل
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc, // استخدام ترميز AAC
      sampleRate: 22050, // معدل العينات
      bitRate: 32000, // معدل البت
    );

    try {
      // بدء التسجيل
      await _recorder.start(config, path: _filePath!);

      // تحديث حالة التسجيل
      setState(() {
        _isRecording = true;
        _isRecordingForTextFormFiled = true;
      });

      print('Recording started. File path: $_filePath');
      print('Time Voice: ${DIManager.findDep<SharedPrefs>().getTimeVoice()}');

      // إيقاف التسجيل تلقائيًا بعد الوقت المحدد
      Future.delayed(
        Duration(minutes: DIManager.findDep<SharedPrefs>().getTimeVoice()),
        () async {
          await _stopRecording();
        },
      );
    } catch (e) {
      print('Error while starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      // إيقاف التسجيل واسترجاع مسار الملف
      final path = await _recorder.stop();
      stopTimer();

      // التحقق من أن الملف تم تسجيله بنجاح
      if (_filePath != null) {
        // إعداد MediaItem لمصدر الصوت

        // final mediaItem = MediaItem(
        //   id: _filePath!,
        //   album: "Recording Album",
        //   title: "Recording Title",
        //   artist: "Unknown",playable: false,isLive: false,
        //   duration: null, // يمكن تحديث المدة لاحقًا بعد تحميل الملف
        // );

        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.file(_filePath!),
            // tag: mediaItem,
          ),
        );

        // final mediaItem = MediaItem(
        //   id: _filePath!,
        //   album: "Recording Album",
        //   title: "Recording Title",
        //   artist: "Unknown",
        //   duration: null, // يمكن تحديث المدة لاحقًا بعد تحميل الملف
        // );

        // await _audioPlayer.setAudioSource(
        //   AudioSource.uri(
        //     Uri.file(_filePath!),
        //     tag: mediaItem,
        //   ),
        // );

        // الاستماع لتحديث المدة عند توفرها
        _audioPlayer.durationStream.listen((duration) {
          if (duration != null) {
            setState(() {
              _totalDuration = duration.inSeconds.toDouble();
            });
            print('_totalDuration updated: $_totalDuration');
          }
        });

        print('Recording stopped. File saved at: $_filePath');

        // تحديث حالة التسجيل
        setState(() {
          _isRecording = false;
          _isStopRecording = true;
          _isDoneRecording = true;
        });
      } else {
        print('Recording stopped, but file path is null.');
      }
    } catch (e) {
      print('Error while stopping recording: $e');

      // إعادة تعيين الحالات عند حدوث خطأ
      setState(() {
        _isRecording = false;
        _isStopRecording = false;
        _isDoneRecording = false;
      });
    }
  }

  Timer? _timer;
  double _recordingTime = 0;

  void startTimer() {
    _recordingTime = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTime++;
      });
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  bool isPlaying = true;

  Future<void> _stopPlay() async {
    if (_filePath != null) {
      await _audioPlayer.stop();
      setState(() {
        isPlaying = true;
        // _currentPosition = 0; // إذا كنت تريد إعادة الموضع إلى البداية
      });
    }
  }

  restartPlay() {
    setState(() {
      _isDoneRecording = false;
      _isStopRecording = false;
      isPlaying = true;
      _isRecordingForTextFormFiled = false;
      _isRecording = false;
      _filePath = null;
    });
  }

  List<Map<String, dynamic>> chooseType = [
    {'id': 1, 'title': 'لون الخلفية'},
    {'id': 2, 'title': 'يحتوي فيديو'},
    {'id': 3, 'title': 'يحتوي صوت'},
    {'id': 4, 'title': 'يحتوي صورة'},
  ];

  List<Map<String, dynamic>> chooseVisibility = [
    {'id': 1, 'title': 'عام'},
    {'id': 2, 'title': 'للمتابعين فقط'},
  ];
  String selectedType = 'خيارات النشر';
  String selectedTypeVisibility = 'عام';
  int selectedTypeVisibilityId = 1;
  int? selectedTypeId;

  listenerPage(context, state) {
    if (state is ErrorGetAllCommunityPostState) {
      SnackBarHelper.mySnackBarError(state.message, context);
      isLoading = false;
      isError = true;
    }

    if (state is ErrorGetAllHashtagPostState) {
      // isLoadingHashtag = false;
    }

    if (state is SuccessGetAllHashtagPostState) {
      allHashtagModel = state.data;
      hashtagModel = state.data.hashtag;
      if (allHashtagModel!.hashtag.isNotEmpty) {
        idHashtag.add(allHashtagModel!.hashtag.first.id!);
      }
      isLoadingHashtag = false;
    }

    if (state is LoadingGetAllHashtagPostState) {
      isLoadingHashtag = true;
    }

    if (state is SuccessGetAllCommunityPostState) {
      // communityPostModel =[];
      communityPostModel = state.data.data!.data;

      isLoading = false;
      isError = false;
    }
    if (state is SuccessGetLoaderPostState) {
      communityPostModel!.addAll(state.data!.data!.data);
    }

    if (state is LoadingGetAllCommunityPostState) {
      // SnackBarHelper.mySnackBarLoading('جاري تحميل البيانات', context);
      isLoading = true;
      isError = false;
    }

    if (state is ErrorCreatePostState) {
      SnackBarHelper.mySnackBarError(state.message, context);
    }

    if (state is SuccessCreatePostState) {
      SnackBarHelper.mySnackBarPending(
          'شكراً لمشاركتك ،سيظهر منشورك بعد أن تتم الموافقة عليه', context);

      if (isHaveChatGroup == 1) {
        print("userId: ${state.data.data!.userId}");
        print(
            "userName: ${DIManager.findDep<SharedPrefs>().getAccountType() == 'company' ? DIManager.findDep<SharedPrefs>().getUserNameCompany() : DIManager.findDep<SharedPrefs>().getUserName()}");
        print(
            "profileImage: ${DIManager.findDep<SharedPrefs>().getImageProfile()}");

        APIs.createGroup(
          groupName: controller.text.isNotEmpty
              ? controller.text
              : checkBoxIndex == 3
                  ? 'تسجيل صوت'
                  : '',
          adminId: state.data.data?.userId?.toString() ?? '',
          groupImage: checkBoxIndex == 2 ? state.data.data?.image : null,
          initialMembers: [
            {
              "userId": state.data.data?.userId?.toString() ?? '',
              "userName":
                  DIManager.findDep<SharedPrefs>().getAccountType() == 'company'
                      ? DIManager.findDep<SharedPrefs>().getUserNameCompany() ??
                          'Unknown Company Name'
                      : DIManager.findDep<SharedPrefs>().getUserName() ??
                          'Unknown User Name',
              "profileImage":
                  DIManager.findDep<SharedPrefs>().getImageProfile() ??
                      'default_image_url',
              "joinDate": DateTime.now().toIso8601String(),
              // يفضل استخدام صيغة متوافقة مع Firestore
            }
          ],
          groupId: state.data.data?.id?.toString() ?? '',
        ).then((value) {
          SnackBarHelper.mySnackBarSuccess(
            'لقد تم إنشاء مجموعة للدردشة بنجاح.',
            context,
          );
        }).catchError((error) {
          print("Error creating group: $error");
          SnackBarHelper.mySnackBarError(
            'حدث خطأ أثناء إنشاء المجموعة. الرجاء المحاولة لاحقًا.',
            context,
          );
        });
      }
      selectedType = 'خيارات النشر';
      selectedTypeVisibility = 'عام';
      selectedTypeVisibilityId = 1;
      selectedTypeId = null;
      _imagesAddProduct = null;
      checkBoxIndex = 4;
      checkIndexColors = 0;
      _isSwitchedComment = true;
      isHaveComment = 1;
      isHaveChat = 0;
      colorsChoose = colorWithoutHashtag(allHashtagModel!.color[0].color1!);
      controller.clear();
      controllerUrlAds!.clear();
    }

    if (state is ErrorLikePostState) {
      SnackBarHelper.mySnackBarError(state.message, context);
    }

    /// state delete post
    if (state is ErrorDeletePostState) {
      SnackBarHelper.mySnackBarError(state.message, context);
    }

    if (state is SuccessDeletePostState) {}
  }

  refreshPage(context, state) async {
    page = 1;
    if (DIManager.findDep<SharedPrefs>().getToken() != null) {
      CommunityCubit.get(context).getStatusRecorder();
    }
    await BlocProvider.of<CommunityCubit>(context)
        .getAllCommunityPost(page: page);
    _refreshController.refreshCompleted();
  }

  loadingPage(context, state) async {
    page++;
    await BlocProvider.of<CommunityCubit>(context)
        .getAllLoadingCommunityPost(page: page);
    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    controller.dispose();
    _audioPlayer.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: BlocProvider(
        create: (context) {
          if (DIManager.findDep<SharedPrefs>().getToken() == null) {
            return CommunityCubit()
              ..getAllCommunityPost(page: 1)
              ..getAllHashtagPost();
          } else {
            return CommunityCubit()
              ..getAllCommunityPost(page: 1)
              ..getAllHashtagPost()
              ..getStatusRecorder();
          }
        },
        child: BlocConsumer<CommunityCubit, CommunityState>(
          listener: (context, state) {
            listenerPage(context, state);
          },
          builder: (context, state) {
            return HandelAndroidApp(
              child: Scaffold(
                appBar: appBarNormalWithIcon(
                    text: 'سوشال',
                    context: context,
                    isShowBack: true,
                    isHaveSearch: true,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SearchPostScreen();
                      }));
                    }),
                body: SmartRefreshWidget(
                  onRefresh: () {
                    refreshPage(context, state);
                  },
                  controller: _refreshController,
                  onLoading: () {
                    loadingPage(context, state);
                  },
                  child: SingleChildScrollView(
                    child: isLoading
                        ? CommunityShimmer()
                        : isError
                            ? const ErrorPage()
                            : Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    NoticeToUsers(),
                                    cratePost(context, state),
                                    if (checkBoxIndex == 2) ...{
                                      _imagesAddProduct == null
                                          ? Container()
                                          : showImageSelected(),
                                    },
                                    if (checkBoxIndex == 3) ...[
                                      _isRecordingForTextFormFiled &&
                                              !_isStopRecording
                                          ? playerTimerRecorder()
                                          : _isStopRecording
                                              ? playRecorder()
                                              : Container(),
                                    ],
                                    sizeHeightNormal(height: 4.h),
                                    HashtagWidget(
                                      hashtagList: hashtagModel,
                                    ),
                                    sizeHeightNormal(height: 4.h),
                                    ListCommunity(
                                      communityPostModel: communityPostModel!,
                                      page: page,
                                      isFromUserPage: false,
                                      // hashTagModel: allHashtagModel,
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ),
                // bottomSheet: bottomNavigationBarWidget(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget cratePost(context, state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'
          ? appTheme.borderImageColor
          : Colors.grey.withOpacity(.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizeHeightNormal(height: 10.h),
          Stack(
            alignment: Alignment.topRight,
            children: [
              ThemeTextFormField(
                child: TextFormField(
                  controller: controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Container(
                      width: 2.w,
                    ),
                    hintText:
                        DIManager.findDep<SharedPrefs>().getToken() == null
                            ? "يجب تسجيل الدخول حتى تستطيع المشاركة .."
                            : DIManager.findDep<SharedPrefs>()
                                        .getStatusUserIsBlocked() ==
                                    0
                                ? 'الحساب محظور لا يمكنك النشر ..'
                                : 'ماذا يخطر في بالك ..',
                    hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: DIManager.findDep<SharedPrefs>().getToken() ==
                                    null ||
                                DIManager.findDep<SharedPrefs>()
                                        .getStatusUserIsBlocked() ==
                                    0
                            ? Colors.red
                            : appTheme.black900),
                    counterStyle: TextStyle(
                      color: appTheme.black900,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.h),
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  onChanged: (value) {
                    if (DIManager.findDep<SharedPrefs>().getToken() == null) {
                      navigatorToPush(
                          context: context,
                          pageName: LoginScreen(
                            isNeedIconBac: true,
                          ));
                    }
                  },
                ),
              ),
              Positioned(
                // left: 0,
                right: 7.w,
                top: 11.h,
                child: CustomImageView(
                  imagePath: DIManager.findDep<SharedPrefs>()
                          .getImageProfile()
                          .toString()
                          .contains('http')
                      ? DIManager.findDep<SharedPrefs>()
                          .getImageProfile()
                          .toString()
                      : AppEndpoints.baseUrlWithoutApi +
                          DIManager.findDep<SharedPrefs>()
                              .getImageProfile()
                              .toString(),
                  height: 26.h,
                  width: 26.h,
                  radius: BorderRadius.circular(900.r),
                  fit: BoxFit.fill,
                  placeHolder: ImageConstant.imgPerson,
                ),
              ),
            ],
          ),
          Container(
              width: 350.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 17.w),
                          child: PopupMenuButton<Map<String, dynamic>>(
                            color: appTheme.whiteA700,
                            onSelected: (Map<String, dynamic> newValue) {
                              setState(() {
                                selectedType = newValue['title']; // حفظ العنوان
                                selectedTypeId = newValue['id']; // حفظ المعرف
                                if (selectedTypeId == 1) {
                                  checkBoxIndex = 0;
                                } else if (selectedTypeId == 2) {
                                  checkBoxIndex = 1;
                                } else if (selectedTypeId == 3) {
                                  checkBoxIndex = 3;
                                } else if (selectedTypeId == 4) {
                                  checkBoxIndex = 2;
                                }
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return chooseType
                                  .map((Map<String, dynamic> value) {
                                return PopupMenuItem<Map<String, dynamic>>(
                                  value: value,
                                  child: Text(value['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                );
                              }).toList();
                            },
                            child: Container(
                              decoration: AppDecoration.dropdownButtonChoose,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              height: 26.h,
                              width: 100.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedType ?? "اختر نوعًا",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 7.w),
                          child: PopupMenuButton<Map<String, dynamic>>(
                            color: appTheme.whiteA700,
                            onSelected: (Map<String, dynamic> newValue) {
                              setState(() {
                                selectedTypeVisibility =
                                    newValue['title']; // حفظ العنوان
                                selectedTypeVisibilityId = newValue['id'];
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return chooseVisibility
                                  .map((Map<String, dynamic> value) {
                                return PopupMenuItem<Map<String, dynamic>>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Text(value['title'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall),
                                      Spacer(),
                                      Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: selectedTypeVisibilityId ==
                                                value['id']
                                            ? AppDecoration.pointSelected
                                            : AppDecoration.pointNotSelected,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                            child: Container(
                              decoration: AppDecoration.dropdownButtonChoose,
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              height: 26.h,
                              // width: 80.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedTypeVisibility ?? "اختر نوعًا",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        isLoadingHashtag
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(right: 7.w),
                                child: PopupMenuButton<String>(
                                  color: appTheme.whiteA700,
                                  onSelected: (String newValue) {
                                    final selectedId = allHashtagModel!.hashtag
                                        .firstWhere((hashtag) =>
                                            hashtag.hashtag == newValue)
                                        .id!;

                                    if (idHashtag.isNotEmpty &&
                                        idHashtag.first == selectedId) {
                                      return;
                                    }

                                    setState(() {
                                      idHashtag
                                        ..clear()
                                        ..add(selectedId);
                                    });

                                    print(idHashtag);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return allHashtagModel!.hashtag
                                        .map((hashtag) {
                                      return PopupMenuItem<String>(
                                        value: hashtag.hashtag,
                                        child: Text(
                                          hashtag.hashtag!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  child: Container(
                                    decoration:
                                        AppDecoration.dropdownButtonChoose,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 26.h,
                                    width: 120.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          idHashtag.isNotEmpty
                                              ? allHashtagModel!.hashtag
                                                  .firstWhere((hashtag) =>
                                                      hashtag.id ==
                                                      idHashtag.first)
                                                  .hashtag!
                                              : allHashtagModel!
                                                      .hashtag.isNotEmpty
                                                  ? allHashtagModel!
                                                      .hashtag.first.hashtag!
                                                  : "اختر قسم",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    sizeHeightNormal(height: 5.h),
                    if (selectedTypeId == 1) ...{
                      Row(
                        children: [
                          checkBoxIcon(
                            text: 'لون الخلفية',
                            isChecked: checkBoxIndex == 0 ? true : false,
                            onPressed: () {
                              setState(() {
                                if (checkBoxIndex != 0) {
                                  checkBoxIndex = 0;
                                } else {
                                  checkBoxIndex = 4;
                                }
                              });
                            },
                          ),
                          checkBoxIndex == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 7.9.h),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkIndexColors = 0;
                                            colorsChoose = allHashtagModel!
                                                .color[0].color1!;
                                            // colorsChoose = '0xfff52323';
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 20.h,
                                              width: 20.h,
                                              color: Color(int.parse(
                                                  '0xff${colorWithoutHashtag(allHashtagModel?.color[0].color1 ?? colorsChoose)}')),
                                            ),
                                            if (checkIndexColors == 0)
                                              Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.white70,
                                                size: 20.h,
                                              ),
                                          ],
                                        ),
                                      ),
                                      sizeWidthNormal(),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkIndexColors = 1;
                                            colorsChoose = allHashtagModel!
                                                .color[0].color2!;

                                            // colorsChoose = '0xffF5A623';
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 20.h,
                                              width: 20.h,
                                              color: Color(int.parse(
                                                  '0xff${colorWithoutHashtag(allHashtagModel!.color[0].color2 ?? colorsChoose)}')),
                                            ),
                                            if (checkIndexColors == 1)
                                              Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.white70,
                                                size: 20.h,
                                              ),
                                          ],
                                        ),
                                      ),
                                      sizeWidthNormal(),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkIndexColors = 2;
                                            // colorsChoose = '0xff6819b1';
                                            colorsChoose = allHashtagModel!
                                                .color[0].color3!;
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 20.h,
                                              width: 20.h,
                                              color: Color(int.parse(
                                                  '0xff${colorWithoutHashtag(allHashtagModel!.color[0].color3 ?? colorsChoose)}')),
                                            ),
                                            if (checkIndexColors == 2)
                                              Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.white70,
                                                size: 20.h,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    },
                    if (selectedTypeId == 2) ...{
                      Row(
                        children: [
                          checkBoxIcon(
                            text: 'يحتوي فيديو',
                            isChecked: checkBoxIndex == 1 ? true : false,
                            onPressed: () {
                              setState(() {
                                if (checkBoxIndex != 1) {
                                  checkBoxIndex = 1;
                                } else {
                                  checkBoxIndex = 4;
                                }
                              });
                            },
                          ),
                          checkBoxIndex == 1
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: CustomTextFormField(
                                    width: 200.w,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 7.5.h),
                                    focusNode: _secondFocusNode,
                                    hintText:
                                        AppLocalizations.of(context)!.link_hint,
                                    hintStyle: themeLite.textTheme.bodySmall!
                                        .copyWith(color: Colors.grey),
                                    controller: controllerUrlAds,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .field_is_empty;
                                      }

                                      if (isURLValid(text) != true) {
                                        return AppLocalizations.of(context)!
                                            .should_link_active;
                                      }

                                      return null;
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    }
                  ],
                ),
              )),
          if (DIManager.findDep<SharedPrefs>()
                  .getIfUsersPermissionChatGroup() ==
              1) ...{
            Container(
              height: 30.h,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textNormal(
                      text: 'إنشاء مجموعة للدردشة',
                      fontSize: AppFontSize.fontSize_9,
                    ),
                    // sizeWidthNormal(),
                    Transform.scale(
                      scale: 0.8,
                      // تغيير الحجم (0.8 يعني تصغير بنسبة 20%)
                      child: Switch(
                        value: _isSwitchedChatGroup,
                        onChanged: (value) {
                          setState(() {
                            _isSwitchedChatGroup = value;
                            isHaveChatGroup = value ? 1 : 0;
                            print(isHaveChatGroup);
                          });
                        },
                        activeColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeTrackColor: Colors.green,
                        trackOutlineWidth: MaterialStateProperty.all(3),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        trackOutlineColor: MaterialStateColor.resolveWith(
                            (states) => appTheme.scaffoldBackgroundColor100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          },
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: Row(
              children: [
                // Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textNormal(
                      text: 'تفعيل التعليقات',
                      fontSize: AppFontSize.fontSize_9,
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isSwitchedComment,
                        onChanged: (value) {
                          setState(() {
                            _isSwitchedComment = !_isSwitchedComment;
                            if (_isSwitchedComment) {
                              isHaveComment = 1;
                            } else {
                              isHaveComment = 0;
                            }
                            print(isHaveComment);
                          });
                        },

                        activeColor: Colors.white,
                        // inactiveThumbColor: appTheme.white,
                        inactiveTrackColor: Colors.grey,
                        activeTrackColor: Colors.green,
                        trackOutlineWidth: MaterialStateProperty.all(3),

                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        trackOutlineColor: WidgetStateColor.resolveWith(
                            (states) => appTheme.scaffoldBackgroundColor100),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textNormal(
                      text: 'تفعيل الدردشة',
                      fontSize: AppFontSize.fontSize_9,
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isSwitchedChat,
                        onChanged: (value) {
                          setState(() {
                            _isSwitchedChat = !_isSwitchedChat;
                            if (_isSwitchedChat) {
                              isHaveChat = 1;
                            } else {
                              isHaveChat = 0;
                            }
                            print(isHaveChat);
                          });
                        },

                        activeColor: Colors.white,
                        // inactiveThumbColor: appTheme.white,
                        inactiveTrackColor: Colors.grey,
                        activeTrackColor: Colors.green,
                        trackOutlineWidth: MaterialStateProperty.all(3),

                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        trackOutlineColor: MaterialStateColor.resolveWith(
                            (states) => appTheme.scaffoldBackgroundColor100),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                sizeWidthNormal(),
                checkBoxIndex == 2 ? _addImage() : Container(),
                sizeWidthNormal(),
                if (checkBoxIndex == 3) ...[
                  if (DIManager.findDep<SharedPrefs>().getToken() == null) ...{
                    MaterialButton(
                      onPressed: () {
                        navigatorToPush(
                            context: context,
                            pageName: LoginScreen(
                              isNeedIconBac: true,
                            ));
                      },
                      minWidth: 0,
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
                      shape: const CircleBorder(),
                      color: Colors.green,
                      child: Icon(Icons.mic_none,
                          color: Colors.white, size: 28.fSize),
                    ),
                  } else ...{
                    state is LoadingCreatePostState
                        ? Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Container(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : MaterialButton(
                            onPressed: _isDoneRecording
                                ? () async {
                                    _stopPlay();
                                    if (_filePath != null) {
                                      _isDoneRecording = false;
                                      _isStopRecording = false;
                                      isPlaying = true;
                                      _isRecordingForTextFormFiled = false;
                                      _isRecording = false;
                                      // await chatBlocFirebase.sendChatVoice(
                                      //     DIManager.findDep<SharedPrefs>()
                                      //         .getUserID()
                                      //         .toString(),
                                      //     File(_filePath!));
                                    }
                                    // sendNotifications(
                                    //   massage: 'صوت',
                                    // );

                                    BlocProvider.of<CommunityCubit>(context)
                                        .createPost(
                                            content: controller.text,
                                            hashtags: idHashtag,
                                            isHaveComment: isHaveComment,
                                            isHaveChat: isHaveChat,
                                            isHaveChatGroup: isHaveChatGroup,
                                            visibility:
                                                selectedTypeVisibilityId == 1
                                                    ? 'public'
                                                    : 'followers',
                                            voice_time:
                                                _totalDuration.toString(),
                                            type: 'D',
                                            voice: File(_filePath!));

                                    ///
                                  }
                                : _isRecording
                                    ? _stopRecording
                                    : () {
                                        if (CommunityCubit.get(context)
                                                .isVoicePlay ==
                                            true) {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          SnackBarHelper.mySnackBarError(
                                              'قم بإيقاف التسجيل أولاً',
                                              context,
                                              duration:
                                                  Duration(milliseconds: 250));
                                          return;
                                        }

                                        _startRecording();
                                      },
                            minWidth: 0,
                            padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 10.h,
                                right: 10.w,
                                left: 10.w),
                            shape: const CircleBorder(),
                            color: _isDoneRecording
                                ? Colors.green
                                : _isRecording
                                    ? Colors.red
                                    : Colors.green,
                            child: Icon(
                                _isDoneRecording
                                    ? Icons.send
                                    : _isRecording
                                        ? Icons.mic
                                        : Icons.mic_none,
                                color: Colors.white,
                                size: 28.fSize),
                          ),
                  },
                ] else ...[
                  (state is LoadingCreatePostState)
                      ? loadingCreatePost()
                      : buttonCreatePost(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonCreatePost(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.4.h),
      child: CustomElevatedButton(
          text: 'نشر',
          height: 35.h,
          buttonTextStyle: themeLite.textTheme.titleMedium!
              .copyWith(fontSize: AppFontSize.fontSize_13),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (DIManager.findDep<SharedPrefs>().getToken() == null) {
              navigatorToPush(
                  context: context,
                  pageName: LoginScreen(
                    isNeedIconBac: true,
                  ));
            } else {
              if (DIManager.findDep<SharedPrefs>().getStatusUserIsBlocked() ==
                  0) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                SnackBarHelper.mySnackBarError(
                    'الحساب محظور لايمكنك النشر ..', context);
                return;
              }
              if (controller.text.isEmpty) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                SnackBarHelper.mySnackBarError('يجب إضافة نص ..', context);
              }
              if (controller.text.isNotEmpty) {
                if (checkBoxIndex == 0 && colorsChoose != 'null') {
                  BlocProvider.of<CommunityCubit>(context).createPost(
                      content: controller.text,
                      type: 'A',
                      background: colorsChoose,
                      isHaveChat: isHaveChat,
                      isHaveChatGroup: isHaveChatGroup,
                      visibility: selectedTypeVisibilityId == 1
                          ? 'public'
                          : 'followers',
                      isHaveComment: isHaveComment,
                      hashtags: idHashtag);
                  // if (controller
                  //     .text
                  //     .length <
                  //     20) {
                  //   BlocProvider.of<CommunityCubit>(
                  //       context)
                  //       .createPost(
                  //     content:
                  //     controller
                  //         .text,
                  //     type: 'A',
                  //   );
                  // } else {
                  //   BlocProvider.of<CommunityCubit>(context).createPost(
                  //       content:
                  //       controller
                  //           .text,
                  //       type:
                  //       'A',
                  //       background:
                  //       colorsChoose);
                  // }
                } else if (checkBoxIndex == 1) {
                  if (_formKey.currentState!.validate()) {
                    print(controllerUrlAds!.text.toString());
                    print(controllerUrlAds!.text.toString());
                    print(controllerUrlAds!.text.toString());
                    BlocProvider.of<CommunityCubit>(context).createPost(
                        content: controller.text,
                        hashtags: idHashtag,
                        isHaveComment: isHaveComment,
                        isHaveChat: isHaveChat,
                        visibility: selectedTypeVisibilityId == 1
                            ? 'public'
                            : 'followers',
                        isHaveChatGroup: isHaveChatGroup,
                        type: 'C',
                        video: controllerUrlAds!.text.toString());
                  }
                } else if (checkBoxIndex == 2) {
                  if (_imagesAddProduct != null) {
                    BlocProvider.of<CommunityCubit>(context).createPost(
                        content: controller.text,
                        type: 'B',
                        isHaveComment: isHaveComment,
                        isHaveChat: isHaveChat,
                        isHaveChatGroup: isHaveChatGroup,
                        visibility: selectedTypeVisibilityId == 1
                            ? 'public'
                            : 'followers',
                        image: File(_imagesAddProduct!.path),
                        hashtags: idHashtag);
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    SnackBarHelper.mySnackBarError('يجب اختيار صورة', context);
                  }
                } else if (checkBoxIndex == 4) {
                  BlocProvider.of<CommunityCubit>(context).createPost(
                      content: controller.text,
                      isHaveComment: isHaveComment,
                      isHaveChat: isHaveChat,
                      isHaveChatGroup: isHaveChatGroup,
                      visibility: selectedTypeVisibilityId == 1
                          ? 'public'
                          : 'followers',
                      type: 'A',
                      hashtags: idHashtag);
                }
              }
            }
          },
          width: 80.w,
          buttonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          )),
    );
  }

  Widget loadingCreatePost() {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, top: 13.8.h, bottom: 13.8.h),
      child: Container(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          color: appTheme.greenColor,
        ),
      ),
    );
  }

  Widget showImageSelected() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(
              File(_imagesAddProduct!.path),
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Container(
                // width: 100.w,

                width: MediaQuery.of(context).size.width,
                // height: 80.h,
                // width: 80.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _imagesAddProduct = null;
                        setState(() {});
                      },
                      child: Container(
                        width: 30.fSize,
                        height: 30.fSize,
                        decoration: BoxDecoration(
                          color: appTheme.deepPurpleA100,
                          borderRadius: BorderRadius.circular(900.r),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.cancel,
                          color: appTheme.black900,
                          size: 30.sp,
                        )),
                      ),
                    ),
                    sizeWidthNormal(),
                    InkWell(
                        onTap: () {
                          loadImages(context);
                        },
                        child: Container(
                          width: 30.fSize,
                          height: 30.fSize,
                          decoration: BoxDecoration(
                            color: appTheme.deepPurpleA100,
                            borderRadius: BorderRadius.circular(900.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.edit,
                              color: appTheme.black900,
                              size: 22.sp,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playerTimerRecorder() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        // width: 10.w,
        height: 50.h,
        width: MediaQuery.of(context).size.width * 0.78,
        decoration: AppDecoration.outlineCircular.copyWith(
          borderRadius: BorderRadius.circular(9.h),
        ),
        child: Center(child: textNormal(text: formatDuration(_recordingTime))),
      ),
    );
  }

  Widget playRecorder() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.78,
        height: 50.h,
        decoration: AppDecoration.outlineCircular.copyWith(
          borderRadius: BorderRadius.circular(30.fSize),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: _audioPlayer.seek,
                  );
                },
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: appTheme.greenColor,
                    ),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: appTheme.greenColor,
                    ),
                    iconSize: 30.0,
                    onPressed: _audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: Icon(
                      Icons.pause,
                      color: appTheme.greenColor,
                    ),
                    iconSize: 30.0,
                    onPressed: _audioPlayer.pause,
                  );
                } else {
                  return IconButton(
                    icon: Icon(
                      Icons.replay,
                      color: appTheme.greenColor,
                    ),
                    iconSize: 30.0,
                    onPressed: () => _audioPlayer.seek(Duration.zero,
                        index: _audioPlayer.effectiveIndices!.first),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onTap: () {
                  _stopPlay();
                  restartPlay();
                },
                child: Icon(
                  Icons.delete,
                  color: appTheme.black900,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isReadAll = false;
  int checkBoxIndex = 4;
  bool isImageNull = false;

  Future<void> _pickImages(context) async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(
        imageQuality: 50,
        source: ImageSource.gallery,
      );
      // if (pickedImages.length >= 6) {
      //   SnackBarHelper.mySnackBarError('لايمكن اختيار أكثر من 5 صور ..', context);
      //   return;
      // }

      isImageNull = false;

      final File file = File(pickedImage!.path);
      // File rotatedFile = await FlutterExifRotation.rotateAndSaveImage(path: file.path);
      int fileSizeInBytes = File(pickedImage.path).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print('fileSizeInMb : $fileSizeInMb');
      final compressedFile = await FileManager.compressFile(file, false);
      if (compressedFile != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await compressedFile.copy(tempPath);

        _imagesAddProduct = File(tempPath);
        int fileSizeInBytes2 = File(_imagesAddProduct!.path).lengthSync();
        double fileSizeInMb = fileSizeInBytes2 / (1024 * 1024);
        print('fileSizeInBytes2 : $fileSizeInMb');
        setState(() {});
        // }
        // final File file = File(pickedImage!.path);
        // final fileSize = await file.length();
        //
        // print('fileSize : $fileSize');
        // if (fileSize <= 1048576) {
        //   setState(() {
        //     _imagesAddProduct = file;
        //   });
        // } else {
        //   // Compress the image before adding it to the list
        //   final compressedFile = await FileManager.compressFile(file, false);
        //   if (compressedFile != null) {
        //     setState(() {
        //       _imagesAddProduct = compressedFile;
        //     });
        //   }
      }
    } on PlatformException catch (e) {
      await permissionPhoto(context: context, isCamera: false);
    }
  }

  Widget _addImage() {
    return GestureDetector(
      onTap: () {
        showChoiceDialog(
          context,
          onTapCamera: () {
            Navigator.pop(context);
            _openCamera(context);
          },
          onTapGallery: () {
            Navigator.pop(context);
            _pickImages(context);
          },
        );
      },
      child: Icon(
        Icons.camera_alt_outlined,
        // color: AppColorsController().red,
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    // permissionPhoto(context: context,isCamera: true);
    final picker = ImagePicker();

    try {
      XFile? result = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 35,
      );
      final File file = File(result!.path);
      int fileSizeInBytes = File(result.path).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print('fileSizeInMb : $fileSizeInMb');
      final compressedFile = await FileManager.compressFile(file, false);
      if (compressedFile != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await compressedFile.copy(tempPath);

        _imagesAddProduct = File(tempPath);
        int fileSizeInBytes2 = File(_imagesAddProduct!.path).lengthSync();
        double fileSizeInMb = fileSizeInBytes2 / (1024 * 1024);
        print('fileSizeInBytes2 : $fileSizeInMb');
        setState(() {});
      }
    } on PlatformException catch (e) {
      await permissionPhoto(context: context, isCamera: true);
    }
  }

  File? _imagesAddProduct;
  XFile? fileLicenseListImage;

  Future<void> loadImages(context) async {
    final picker = ImagePicker();
    XFile? result = await picker.pickImage(source: ImageSource.gallery
        // imageQuality: 50,
        );
    if (result != null) {
      File file = File(result.path);
      int fileSizeInBytes = File(result.path).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print(fileSizeInMb);
      if (fileSizeInMb > 1) {
        // SnackBarHelper.mySnackBarError(AppLocalizations.of(context)!.error_size_photo, context);
        //   return;
        final compressedFile = await FileManager.compressFile(file, false);
        if (compressedFile != null) {
          setState(() {
            // fileLicenseListImage = compressedFile;
            _imagesAddProduct = File(compressedFile.path);
          });
        }
      } else {
        fileLicenseListImage = result;
        _imagesAddProduct = File(fileLicenseListImage!.path);
      }
    }
    setState(() {});
  }
}
