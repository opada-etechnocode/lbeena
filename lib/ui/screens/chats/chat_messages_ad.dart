import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/loader_for_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/constants/app_font.dart';
import '../../../data/models/chats/ads_chats_model.dart';
import '../../../data/models/chats/data_massage_model.dart';
import '../../../data/models/chats/message_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../../widgets/components.dart';
import '../../../widgets/message_avis_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../details_product/details_product.dart';
import 'cubit/apis_chat_firebase.dart';
import 'receiver_message.dart';
import 'sender_message.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatMessagesPage extends StatefulWidget {
  final ArgumentMessage? dataMessage;

  const ChatMessagesPage({Key? key, this.dataMessage}) : super(key: key);

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage>
    with WidgetsBindingObserver, LifecycleMixin {
  // final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  bool isLoading = true;
  List<File> files = [];
  TextEditingController controller = TextEditingController();

  String value = "";
  int _lineCount = 1;

  void _checkLineCount() {
    final text = controller.text;
    final lines = text.split('\n').length;
    if (lines != _lineCount) {
      setState(() {
        _lineCount = lines;
        if (_lineCount > 4) {
          // هنا يمكن تنفيذ الإجراء المطلوب عندما يتجاوز عدد الأسطر 4
          print('More than 4 lines entered');
        }
      });
    }
  }

  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  final ScrollController _scrollController = ScrollController(
    // initialScrollOffset: 2573,
    // initialScrollOffset: 20,
  );
  late ScrollController controllerScroller;
  void move() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 2),
        // duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

    }
  }

  bool isMove = true;
  bool tapOnKeyboard = false;

  String statusUser = 'resumed';
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  String? _filePath;
  double _currentPosition = 0;
  double _totalDuration = 0;
  Timer? _timer;
  double _recordingTime = 0;
  bool isPlaying = true;


  void startTimer() {
    _recordingTime = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      setState(() {
        _recordingTime++;
        // _totalDuration++;
      });
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    startTimer();
    _isStopRecording = false;
    final directory = await getApplicationDocumentsDirectory();
    // Generate a unique file name using the current timestamp
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';
    const config = RecordConfig(
      // Specify the format, encoder, sample rate, etc., as needed
      encoder: AudioEncoder.aacLc, // For example, using AAC codec
      sampleRate: 11025, // Sample rate
      bitRate: 32000, // Bit rate
    );
/*
 sampleRate: 22050, // Sample rate
      bitRate: 32000,
 */
    // Start recording to file with the specified configuration
    await _recorder.start(config, path: _filePath!);
    setState(() {
      _isRecording = true;
      _isRecordingForTextFormFiled = true;
    });
  }
  Future<void> _stopRecording() async {
    print('_filePath :$_filePath');
    // إيقاف التسجيل
    final path = await _recorder.stop();
    stopTimer();

    // تعيين المدة الكلية للملف الصوتي
    if (_filePath != null) {
      try {
        // استخدام audioplayers بدون تشغيل الصوت مباشرة
        AudioPlayer player = AudioPlayer();
        await player.setSourceDeviceFile(_filePath!); // أو setSourceUrl إذا كان الملف عبر الإنترنت

        // الحصول على المدة الكلية (Duration)
        Duration? duration = await player.getDuration(); // جلب المدة الكلية
        setState(() {
          _totalDuration = duration?.inSeconds.toDouble() ?? 0; // تعيين المدة الكلية
          print("Total Duration: $_totalDuration");
        });
      } catch (e) {
        print("Error: $e");
      }
    }

    setState(() {
      _isRecording = false;
      _isStopRecording = true;
      _isDoneRecording = true;
    });
  }

  Future<void> _playRecording() async {
    if (_filePath != null) {
      // تأكد من أن الملف ليس قيد التشغيل بالفعل
      setState(() {
        isPlaying = false;
      });

      // إذا كان الملف محليًا، استخدم setSourceFile بدلاً من setSourceUrl
      try {
        await _player.setSourceDeviceFile(_filePath!);// استخدم هذه الطريقة إذا كان الملف محليًا
        await _player.resume(); // بدء التشغيل
      } catch (e) {
        print("Error setting source: $e");
      }

      // الاستماع للتقدم أثناء التشغيل
      _player.onPositionChanged.listen((Duration event) {
        setState(() {
          // تحديث الموضع الحالي
          _currentPosition = event.inSeconds.toDouble();
        });
      });

      _player.onDurationChanged.listen((Duration event) {
        setState(() {
          // تحديث المدة الكلية
          _totalDuration = event.inSeconds.toDouble();
        });
      });

      // الاستماع عند الانتهاء من التشغيل
      _player.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.completed) {
          setState(() {
            isPlaying = true; // تغيير الحالة إلى مشغل
          });
          _stopPlaying(); // إيقاف التشغيل عند الانتهاء
        }
      });
    }
  }

  Future<void> _stopPlaying() async {
    await _player.stop();
    // إيقاف التشغيل
    setState(() {
      isPlaying = true; // إعادة الحالة إلى "مكتمل"
    });
  }
  @override
  void onAppLifecycleChange(AppLifecycleState state) {
    setState(() {
      if (DIManager.findDep<SharedPrefs>().getUserID() != null) {
        if (state == AppLifecycleState.resumed) {
          APIs.updateStatusUser(
            userStatus: 'inChatPage',
          );
        } else {
          APIs.updateStatusUser(
            userStatus: DateTime.now().toString(),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // scrollController = ScrollController(initialScrollOffset: 3000);
    // initScroll();
    onAppLifecycleChange(AppLifecycleState.resumed);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // move();
    //   _scrollToEndScreen();
    // });

    APIs.updateMessageReadStatus(
      user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
      user_id_2: widget.dataMessage!.user_id_2.toString() ==
              DIManager.findDep<SharedPrefs>().getUserID().toString()
          ? widget.dataMessage!.user_id.toString()
          : widget.dataMessage!.user_id_2.toString(),
      ad_id: widget.dataMessage!.ad_id.toString(),
      type: 'ads',
      read: DIManager.findDep<SharedPrefs>().getUserID().toString(),
    );

    APIs.getMessageReadStatus(
      user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
      user_id_2: widget.dataMessage!.user_id_2.toString() ==
              DIManager.findDep<SharedPrefs>().getUserID().toString()
          ? widget.dataMessage!.user_id.toString()
          : widget.dataMessage!.user_id_2.toString(),
      ad_id: widget.dataMessage!.ad_id.toString(),type: 'ads',
    );

    APIs.deleteNotificationsToUser(
      user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
      user_id_2: widget.dataMessage!.user_id_2.toString() ==
              DIManager.findDep<SharedPrefs>().getUserID().toString()
          ? widget.dataMessage!.user_id.toString()
          : widget.dataMessage!.user_id_2.toString(),
      ad_id: widget.dataMessage!.ad_id.toString(),
    );
    // }

    APIs.getStatusUser(
      userID: widget.dataMessage!.user_id_2.toString() ==
              DIManager.findDep<SharedPrefs>().getUserID().toString()
          ? widget.dataMessage!.user_id.toString()
          : widget.dataMessage!.user_id_2.toString(),
    );

    chatBlocFirebase.getAdsLastInfoForUserReceiver(
      user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
      user_id_2: widget.dataMessage!.user_id_2.toString() ==
              DIManager.findDep<SharedPrefs>().getUserID().toString()
          ? widget.dataMessage!.user_id.toString()
          : widget.dataMessage!.user_id_2.toString(),
      ad_id: widget.dataMessage!.ad_id.toString(),
      type: 'ads'
    );

    controller.addListener(_checkLineCount);
    chatBlocFirebase.getDeviceTokenUser(
        userId: widget.dataMessage!.user_id_2.toString() ==
                DIManager.findDep<SharedPrefs>().getUserID().toString()
            ? widget.dataMessage!.user_id.toString()
            : widget.dataMessage!.user_id_2.toString());
    WidgetsBinding.instance.addObserver(this);

    controllerScroller   = ScrollController();
  }

  @override
  void dispose() {
    controller.removeListener(_checkLineCount);
    controller.dispose();
    _player.dispose();
    _recorder.dispose();
    // scrollController.dispose();
    textValueNotifier.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
 
  bool isLoadingChats = true;
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();
  List deviceTokenUser = [];

  Map<String, List<DataMassageModel>> groupMessagesByDate(
      List<DataMassageModel> messages) {
    Map<String, List<DataMassageModel>> groupedMessages = {};
    for (var message in messages) {
      String date =
          DateFormat('yyyy-MM-dd').format(message.dateTime!);
      if (groupedMessages[date] == null) {
        groupedMessages[date] = [message];
      } else {
        groupedMessages[date]!.add(message);
      }
    }
    return groupedMessages;
  }

  @override
  Widget build(BuildContext context) {
    print('statusUser: $statusUser');

    return PopScope(
      onPopInvoked: (isBackPressed) {
        APIs.updateStatusUser(userStatus: 'resumed');
        print('Status updated to resumed');
      },
      child: HandelAndroidApp(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar:  AppBar(
            backgroundColor: appTheme.scaffoldBackgroundColor100,
            leading: SizedBox(),
            title: Builder(builder: (context) {
              // APIs.updateStatusUser(userStatus: statusUser);
              print( widget.dataMessage?.imageCompany);
              print( widget.dataMessage?.imageCompany);
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('${AppEndpoints.starBaseUrl}users')
                    .doc(widget.dataMessage!.user_id_2.toString() ==
                    DIManager.findDep<SharedPrefs>()
                        .getUserID()
                        .toString()
                    ? widget.dataMessage!.user_id.toString()
                    : widget.dataMessage!.user_id_2.toString())
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data() != null) {
                      if (snapshot.data.data()!['userStatus'] == 'resumed' ||
                          snapshot.data.data()!['userStatus'] == 'inChatPage') {
                        // APIs.updateStatusUser(userStatus: statusUser);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                                APIs.updateStatusUser(userStatus: 'resumed');
                              },
                            ),
                            if (userId == widget.dataMessage!.user_id.toString()) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.sp),
                                // Adjust the border radius as needed
                                child: widget.dataMessage?.imageCompany.toString() == 'null' ||
                                    widget.dataMessage?.imageCompany.toString() ==
                                        '${AppEndpoints.baseUrlWithoutApi}null' || widget.dataMessage?.imageCompany.toString() ==
                                    '${AppEndpoints.baseUrlImageFirebase}null'|| widget.dataMessage?.imageCompany.toString() ==
                                    '${AppEndpoints.baseUrlWithoutApi}'
                                    ? CustomImageView(
                                  imagePath: ImageConstant.imgPerson,
                                  fit: BoxFit.contain,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                )
                                    : CustomImageView(
                                  imagePath:
                                  widget.dataMessage!.imageCompany.toString(),
                                  fit: BoxFit.cover,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                ),
                              ),
                            ] else ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.sp),
                                // Adjust the border radius as needed
                                child: widget.dataMessage?.imageUser == null ||
                                    widget.dataMessage?.imageUser ==
                                        '${AppEndpoints.baseUrlWithoutApi}null' || widget.dataMessage?.imageUser.toString()=='https://www.syriansinuae.com'|| widget.dataMessage?.imageUser.toString()=='https://syriansinuae.com'
                                    ? CustomImageView(
                                  imagePath: ImageConstant.imgCompanyD,
                                  fit: BoxFit.contain,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                )
                                    : CustomImageView(
                                  imagePath:
                                  widget.dataMessage!.imageUser.toString(),
                                  fit: BoxFit.cover,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                ),
                              ),
                            ],
                            SizedBox(width: 7.w), // Space between image and text
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userId ==
                                        widget.dataMessage!.user_id.toString()
                                        ? widget.dataMessage!.nameOwnerAds
                                        .toString()
                                        : widget
                                        .dataMessage!.user_name_person_sender
                                        .toString(),
                                    style: themeLite.textTheme.titleSmall,
                                  ),

                                  sizeHeightNormal(height: 2.h),
                                  //اخر ظهور
                                  textNormal(
                                    text: 'متصل الآن',
                                    fontSize: AppFontSize.fontSize_10,
                                    color: appTheme.black900,
                                  ),
                                ],
                              ),
                            ),
                            sizeWidthNormal(),
                            Padding(
                              padding: EdgeInsets.only(top: 7.h),
                              child: Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                                APIs.updateStatusUser(userStatus: 'resumed');
                              },
                            ),
                            if (userId == widget.dataMessage!.user_id.toString()) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.sp),
                                // Adjust the border radius as needed
                                child: widget.dataMessage?.imageCompany.toString() == 'null' ||
                                    widget.dataMessage?.imageCompany.toString() ==
                                        '${AppEndpoints.baseUrlWithoutApi}null' || widget.dataMessage?.imageCompany.toString() ==
                                    '${AppEndpoints.baseUrlImageFirebase}null'|| widget.dataMessage?.imageCompany.toString() ==
                                    '${AppEndpoints.baseUrlWithoutApi}'
                                    ? CustomImageView(
                                  imagePath: ImageConstant.imgPerson,
                                  fit: BoxFit.contain,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                )
                                    : CustomImageView(
                                  imagePath:
                                  widget.dataMessage!.imageCompany.toString(),
                                  fit: BoxFit.cover,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                ),
                              ),
                            ] else ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.sp),
                                // Adjust the border radius as needed
                                child: widget.dataMessage?.imageUser == null ||
                                    widget.dataMessage?.imageUser ==
                                        '${AppEndpoints.baseUrlWithoutApi}null' || widget.dataMessage?.imageUser.toString()=='https://www.syriansinuae.com'|| widget.dataMessage?.imageUser.toString()=='https://syriansinuae.com'
                                    ? CustomImageView(
                                  imagePath: ImageConstant.imgCompanyD,
                                  fit: BoxFit.contain,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                )
                                    : CustomImageView(
                                  imagePath:
                                  widget.dataMessage!.imageUser.toString(),
                                  fit: BoxFit.cover,
                                  height: 30.fSize,
                                  width: 30.fSize,
                                ),
                              ),
                            ],
                            SizedBox(width: 7.w), // Space between image and text
                            Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userId ==
                                        widget.dataMessage!.user_id.toString()
                                        ? widget.dataMessage!.nameOwnerAds
                                        .toString()
                                        : widget
                                        .dataMessage!.user_name_person_sender
                                        .toString(),
                                    style: themeLite.textTheme.titleSmall,
                                  ),
                                  sizeHeightNormal(height: 2.h),
                                  //اخر ظهور
                                  textNormal(
                                    text: (snapshot.data.data()!['userStatus'])
                                        .toString()
                                        .isDateTime
                                        ? 'آخر ظهور: ${DateFormat('hh:mm a').format(DateTime.parse(snapshot.data.data()!['userStatus']))}'
                                        : '',
                                    fontSize: AppFontSize.fontSize_10,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            sizeWidthNormal(),
                            Padding(
                              padding: EdgeInsets.only(top: 7.h),
                              child: Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    }
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                          APIs.updateStatusUser(userStatus: 'resumed');
                        },
                      ),
                      if (userId == widget.dataMessage!.user_id.toString()) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.sp),
                          // Adjust the border radius as needed
                          child: widget.dataMessage?.imageCompany.toString() == 'null' ||
                              widget.dataMessage?.imageCompany.toString() ==
                                  '${AppEndpoints.baseUrlWithoutApi}null' || widget.dataMessage?.imageCompany.toString() ==
                              '${AppEndpoints.baseUrlImageFirebase}null'|| widget.dataMessage?.imageCompany.toString() ==
                              '${AppEndpoints.baseUrlWithoutApi}'
                              ? CustomImageView(
                            imagePath: ImageConstant.imgPerson,
                            fit: BoxFit.contain,
                            height: 30.fSize,
                            width: 30.fSize,
                          )
                              : CustomImageView(
                            imagePath:
                            widget.dataMessage!.imageCompany.toString(),
                            fit: BoxFit.cover,
                            height: 30.fSize,
                            width: 30.fSize,
                          ),
                        ),
                      ] else ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.sp),
                          // Adjust the border radius as needed
                          child: widget.dataMessage?.imageUser == null ||
                              widget.dataMessage?.imageUser ==
                                  '${AppEndpoints.baseUrlWithoutApi}null' || widget.dataMessage?.imageUser.toString()=='https://www.syriansinuae.com'|| widget.dataMessage?.imageUser.toString()=='https://syriansinuae.com'
                              ? CustomImageView(
                            imagePath: ImageConstant.imgCompanyD,
                            fit: BoxFit.contain,
                            height: 30.fSize,
                            width: 30.fSize,
                          )
                              : CustomImageView(
                            imagePath:
                            widget.dataMessage!.imageUser.toString(),
                            fit: BoxFit.cover,
                            height: 30.fSize,
                            width: 30.fSize,
                          ),
                        ),
                      ],
                      SizedBox(width: 7.w), // Space between image and text
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          userId == widget.dataMessage!.user_id.toString()
                              ? widget.dataMessage!.nameOwnerAds.toString()
                              : widget.dataMessage!.user_name_person_sender
                              .toString(),
                          style: themeLite.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
            leadingWidth: 0.w,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Builder(builder: (context) {
              chatBlocFirebase.getMessages(
                  user_id: DIManager.findDep<SharedPrefs>().getUserID(),
                  ad_id: widget.dataMessage!.ad_id.toString(),
                  user_id_2: widget.dataMessage!.user_id_2.toString() ==
                          DIManager.findDep<SharedPrefs>().getUserID().toString()
                      ? widget.dataMessage!.user_id.toString()
                      : widget.dataMessage!.user_id_2.toString(),
                  receiverId: widget.dataMessage!.user_id_2.toString() ==
                          DIManager.findDep<SharedPrefs>().getUserID().toString()
                      ? widget.dataMessage!.user_id.toString()
                      : widget.dataMessage!.user_id_2.toString(),
                  type: 'ads');
              return BlocProvider(
                create: (context) => ChatCubitFirebase(),
                child: BlocConsumer<ChatCubitFirebase, ChatStateFirebase>(
                  bloc: chatBlocFirebase,
                  listener: (context, state) {
                    if (state is GetMessagesSuccessState) {
                      // initScroll();
                      isMove = true;
                      // if (_isScrolledToEnd) {
                      //   move();
                      // }
                      // move();
                    }

                    if (state is SuccessDeviceTokenUserState) {
                      // state.deviceTokenUserModel.data.

                      deviceTokenUser =
                          state.deviceTokenUserModel.data!.androidTokens;
                      deviceTokenUser
                          .addAll(state.deviceTokenUserModel.data!.iosTokens);
                      print(
                          state.deviceTokenUserModel.data!.androidTokens.length);
                      print(state.deviceTokenUserModel.data!.iosTokens.length);
                      print(deviceTokenUser.length);
                    }

                    if (state is SendMessageSuccessUploadImageState) {
                      chatBlocFirebase.sendMassageFirebaseToFireStore(
                        user_id: DIManager.findDep<SharedPrefs>()
                            .getUserID()
                            .toString(),
                         type: 'ads',
                        user_id_2: widget.dataMessage!.user_id_2.toString() ==
                                DIManager.findDep<SharedPrefs>()
                                    .getUserID()
                                    .toString()
                            ? widget.dataMessage!.user_id.toString()
                            : widget.dataMessage!.user_id_2.toString(),
                        ad_id: widget.dataMessage!.ad_id.toString(),
                        dataMassageModel: DataMassageModel(
                          text: state.imageUrl,
                          dateTime: DateTime.now(),
                          receiverId: widget.dataMessage!.user_id_2.toString() ==
                                  DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString()
                              ? widget.dataMessage!.user_id.toString()
                              : widget.dataMessage!.user_id_2.toString(),
                          read: DIManager.findDep<SharedPrefs>()
                              .getUserID()
                              .toString(),
                          totalDurationRecord: '',
                          type: 'image',
                          sent: DateTime.now().millisecondsSinceEpoch.toString(),
                          senderId: DIManager.findDep<SharedPrefs>()
                              .getUserID()
                              .toString(),
                        ),
                        adsChatsModel: AdsChatsModel(
                          dateTime: DateTime.now().toString(),
                          ad_id: widget.dataMessage!.ad_id.toString(),
                          imageAds: widget.dataMessage!.imageAds.toString(),
                          idAdOnwerCompany:
                              widget.dataMessage!.idAdOnwerCompany.toString(),
                          nameAds: widget.dataMessage!.nameAds.toString(),
                          isBanner: widget.dataMessage!.isBanner,
                          categoryId: widget.dataMessage!.categoryId,
                          isBannerInOut: widget.dataMessage!.isBannerInOut,
                          idBannerOrProduct:
                              widget.dataMessage!.idBannerOrProduct,
                          nameOwnerAds:
                              widget.dataMessage!.nameOwnerAds.toString(),
                          massage: state.imageUrl,
                          type: 'image',
                          user_id: widget.dataMessage!.user_id.toString(),
                          user_id_2: widget.dataMessage!.user_id_2.toString(),
                          userNamePersonSender: widget
                              .dataMessage!.user_name_person_sender
                              .toString(),
                          imageCompany:
                              widget.dataMessage!.imageCompany.toString(),
                          imageUser: widget.dataMessage!.imageUser.toString(),
                          read: DIManager.findDep<SharedPrefs>()
                              .getUserID()
                              .toString(),
                        ),
                      );
                    }

                    if (state is SendMessageSuccessUploadRecordState) {
                      restartPlay();
                      chatBlocFirebase.sendMassageFirebaseToFireStore(
                        user_id: DIManager.findDep<SharedPrefs>()
                            .getUserID()
                            .toString(),  type: 'ads',
                        user_id_2: widget.dataMessage!.user_id_2.toString() ==
                                DIManager.findDep<SharedPrefs>()
                                    .getUserID()
                                    .toString()
                            ? widget.dataMessage!.user_id.toString()
                            : widget.dataMessage!.user_id_2.toString(),
                        ad_id: widget.dataMessage!.ad_id.toString(),
                        dataMassageModel: DataMassageModel(
                          text: state.recorderUrl,
                          dateTime: DateTime.now(),
                          receiverId: widget.dataMessage!.user_id_2.toString() ==
                                  DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString()
                              ? widget.dataMessage!.user_id.toString()
                              : widget.dataMessage!.user_id_2.toString(),
                          read: DIManager.findDep<SharedPrefs>()
                              .getUserID()
                              .toString(),
                          type: 'record',
                          sent: DateTime.now().millisecondsSinceEpoch.toString(),
                          totalDurationRecord: _totalDuration.toString(),
                          senderId: DIManager.findDep<SharedPrefs>()
                              .getUserID()
                              .toString(),
                        ),
                        adsChatsModel: AdsChatsModel(
                          dateTime: DateTime.now().toString(),
                          ad_id: widget.dataMessage!.ad_id.toString(),
                          imageAds: widget.dataMessage!.imageAds.toString(),
                          idAdOnwerCompany:
                              widget.dataMessage!.idAdOnwerCompany.toString(),
                          nameAds: widget.dataMessage!.nameAds.toString(),
                          isBanner: widget.dataMessage!.isBanner,
                          categoryId: widget.dataMessage!.categoryId,
                          isBannerInOut: widget.dataMessage!.isBannerInOut,
                          idBannerOrProduct:
                              widget.dataMessage!.idBannerOrProduct,
                          nameOwnerAds:
                              widget.dataMessage!.nameOwnerAds.toString(),
                          massage: state.recorderUrl,
                          type: 'record',
                          user_id: widget.dataMessage!.user_id.toString(),
                          user_id_2: widget.dataMessage!.user_id_2.toString(),
                          userNamePersonSender: widget
                              .dataMessage!.user_name_person_sender
                              .toString(),
                          imageCompany:
                              widget.dataMessage!.imageCompany.toString(),
                          imageUser: widget.dataMessage!.imageUser.toString(),
                          read: DIManager.findDep<SharedPrefs>()
                              .getUserID()
                              .toString(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    DateTime timeMessage = chatBlocFirebase.messages.isNotEmpty
                        ? chatBlocFirebase.messages[0].dateTime!
                        : DateTime.now();
                    // DateTime timeMessage2 = DateTime.parse(chatBlocFirebase.messages.last.dateTime.toString());
                    String _dateTimeNow = DateFormat.yMMMMd().format(timeMessage);

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            navigatorToPush(
                                context: context,
                                pageName: DetailsProduct(
                                  idBannerOrProduct:
                                      widget.dataMessage!.idBannerOrProduct!,
                                  isBanner: widget.dataMessage!.isBanner!,
                                  idAdOnwerCompany: int.parse(
                                      widget.dataMessage!.idAdOnwerCompany!),
                                  categoryId: widget.dataMessage!.categoryId!,
                                  idAds: widget.dataMessage!.ad_id!.toString(),
                                  adsName: '',
                                  isBannerInOut:
                                      widget.dataMessage!.isBannerInOut!,
                                ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: 60.h,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(15.r),
                              color: appTheme.lightBlueBottomNavigatorBar
                                  .withOpacity(0.8),
                              border: Border.all(
                                color: appTheme.lightBlueBottomNavigatorBar,
                                width: 0.2,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10.sp),
                                  widget.dataMessage!.imageAds.toString() =='null' || widget.dataMessage!.imageAds.toString()=='https://syriansinuae.com' || widget.dataMessage!.imageAds.toString()=='https://www.syriansinuae.com'  ?Container(): CustomImageView(
                                    imagePath:
                                        widget.dataMessage!.imageAds.toString(),
                                    fit: BoxFit.fill,
                                    height: 50.sp,
                                    width: 50.sp,
                                    radius: BorderRadius.circular(15.r),
                                  ),
                                  //
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(widget.dataMessage!.nameAds.toString(),
                                          style: themeLite.textTheme.titleSmall!
                                              .copyWith( fontSize: AppFontSize.fontSize_12,)),
                                      // Text(
                                      //     userId == widget.dataMessage!.user_id.toString()
                                      //         ? widget.dataMessage!.nameOwnerAds
                                      //             .toString()
                                      //         : widget
                                      //             .dataMessage!.user_name_person_sender
                                      //             .toString(),
                                      //     style: themeLite.textTheme.titleSmall),
                                      sizeHeightNormal(height: 5.h),
                                      textNormal(
                                          text: _dateTimeNow,
                                          fontSize: AppFontSize.fontSize_10,
                                          color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              chatBlocFirebase.messages.isNotEmpty
                                  ? Container()
                                  : MessageAvisWidget(),


                              buildMessages(
                                  groupMessagesByDate(
                                      chatBlocFirebase.messages),
                                  state),
                              state is ChatFirebaseLoadingUploadImageState
                                  ? LoadingAnimationWidget.threeRotatingDots(color: appTheme.greenColor, size: 60,)
                                  : Container(),
                              state is ChatFirebaseLoadingUploadRecordState
                                  ? LoadingAnimationWidget.threeRotatingDots(color: appTheme.greenColor, size: 60,)
                                  : Container(),
                              Padding(
                                padding:  EdgeInsets.only(bottom: 20.h),
                                child: _chatInput(),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  String formatDateString(String inputDateString) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(inputDateString);

    // Create a DateFormat object with the desired output format
    // EEEE: Day of week in full (e.g., Saturday)
    // d: Day of month (e.g., 8)
    // MMM: Abbreviated month (e.g., Jun)
    DateFormat outputFormat = DateFormat('EEE d MMM', 'en_US');

    // Format the DateTime object into the desired string format
    String outputDateString = outputFormat.format(dateTime);

    return outputDateString;
  }

  Widget buildMessages(Map<String, List<DataMassageModel>> groupedMessages,
      ChatStateFirebase state) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        scrollDirection: Axis.vertical,
        itemCount: groupedMessages.keys.length,
        itemBuilder: (context, index) {
          String date = groupedMessages.keys.elementAt(index);
          List<DataMassageModel> dateMessages = groupedMessages[date]!;
          //   _scrollController.position.maxScrollExtent !=null?  move():null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (index == groupedMessages.keys.length -1) ...{
                MessageAvisWidget(),
              },
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date, // Format this date string as needed
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                // to disable scrolling inside nested ListView
                shrinkWrap: true,
                reverse: true,
                // to make ListView take the size of its children
                itemCount: dateMessages.length,
                itemBuilder: (context, messageIndex) {
                  DataMassageModel message = dateMessages[messageIndex];
                  if (message.senderId ==
                      DIManager.findDep<SharedPrefs>()
                          .getUserID()
                          .toString()) {
                    return SenderMessageWidget(dataMessages: message,
                    index: messageIndex,);
                  } else {
                    return ReceivedMessageWidget(dataMessages: message);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  bool _isRecordingForTextFormFiled = false;
  bool _isStopRecording = false;
  bool _isDoneRecording = false;
  bool _isScrolledToEnd = true;


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
  ValueNotifier<String> textValueNotifier = ValueNotifier<String>("");

  Widget _chatInput() {
    return ValueListenableBuilder<String>(
      valueListenable: textValueNotifier,
      builder: (context,value,child){
        return Builder(builder: (context) {
          // APIs.updateStatusUser(userStatus: statusUser);
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('${AppEndpoints.starBaseUrl}users')
                .doc(widget.dataMessage!.user_id_2.toString() ==
                DIManager.findDep<SharedPrefs>().getUserID().toString()
                ? widget.dataMessage!.user_id.toString()
                : widget.dataMessage!.user_id_2.toString())
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if (snapshot.hasData) {
                if (snapshot.data.data() != null) {
                  if (snapshot.data.data()!['userStatus'] != 'inChatPage') {
                    // APIs.updateStatusUser(userStatus: statusUser);
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: Row(
                        children: [
                          //input field & buttons
                          !_isRecordingForTextFormFiled
                              ? Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: Row(
                                children: [
                                  sizeWidthNormal(),

                                  Expanded(
                                      child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: _lineCount < 5 ? null : 5,
                                        // onChanged: (value) {
                                        //   setState(() {
                                        //     this.value = value;
                                        //   });
                                        // },
              onChanged: (newValue) {
              textValueNotifier.value = newValue;
              },
                                        style: TextStyle(color: Colors.black),
                                        decoration: const InputDecoration(
                                            hintText: 'ارسل',
                                            hintStyle: TextStyle(
                                                color: Colors.blueAccent),
                                            border: InputBorder.none),
                                      )),

                                  //pick image from gallery button
                                  IconButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                        ImagePicker();

                                        // Picking multiple images
                                        final List<XFile> images =
                                        await picker.pickMultiImage(
                                            imageQuality: 50);

                                        for (var i in images) {
                                          log('Image Path: ${i.path}');

                                          await chatBlocFirebase
                                              .sendChatImage(
                                              DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getUserID()
                                                  .toString(),
                                              File(i.path));
                                        }
                                        sendNotifications(
                                          massage: 'صورة',
                                        );
                                      },
                                      icon: Icon(Icons.image,
                                          color: Colors.blueAccent,
                                          size: 22.r)),

                                  //take image from camera button
                                  IconButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                        ImagePicker();

                                        // Pick an image
                                        final XFile? image =
                                        await picker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 70);
                                        if (image != null) {
                                          await chatBlocFirebase
                                              .sendChatImage(
                                              DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getUserID()
                                                  .toString(),
                                              File(image.path));
                                          sendNotifications(
                                            massage: 'صورة',
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.camera_alt_rounded,
                                          color: Colors.blueAccent,
                                          size: 24.r)),

                                  //adding some space
                                  SizedBox(width: 6.w),
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          _isRecordingForTextFormFiled && !_isStopRecording
                              ? Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Container(
                              // width: 10.w,
                              height: 50.h,
                              width: MediaQuery.of(context).size.width * 0.78,
                              decoration:
                              AppDecoration.outlineCircular.copyWith(
                                borderRadius: BorderRadius.circular(30.h),
                              ),
                              child: Center(
                                  child:
                                  textNormal(text:formatDuration(_recordingTime))),
                            ),
                          )
                              : _isStopRecording
                              ? Padding(
                            padding:  EdgeInsets.only(left: 10),
                                child: Container(
                                                            width:
                                                            MediaQuery.of(context).size.width * 0.78,
                                                            height: 50.h,
                                                            decoration:
                                                            AppDecoration.outlineCircular.copyWith(
                                borderRadius: BorderRadius.circular(30.h),
                                                            ),
                                                            child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width *
                                        0.5,
                                    child: Slider(
                                      value: _currentPosition,
                                      max: _totalDuration,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentPosition = value;
                                        });
                                        _player.seek(Duration(
                                            seconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                  isPlaying
                                      ? textNormal(text:
                                      '${formatDuration(_totalDuration)}')
                                      : textNormal(text:
                                      formatDuration(_currentPosition)),
                                  sizeWidthNormal(),
                                  InkWell(
                                    onTap: isPlaying
                                        ? _playRecording
                                        : _stopPlaying,
                                    child: Icon(
                                      isPlaying
                                          ? Icons.play_arrow
                                          : Icons.stop,
                                      color: appTheme.black900,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      restartPlay();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: appTheme.black900,
                                    ),
                                  ),
                                ],
                                                            ),
                                                          ),
                              )
                              : Container(),
                          //send message button
                          controller.text == ''
                              ? MaterialButton(
                            onPressed: _isDoneRecording
                                ? () async {
                              if (_filePath != null) {
                                _isDoneRecording = false;
                                _isStopRecording = false;
                                isPlaying = true;
                                _isRecordingForTextFormFiled = false;
                                _isRecording = false;
                                await chatBlocFirebase.sendChatVoice(
                                    DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                    File(_filePath!));

                                sendNotifications(
                                  massage: 'صوت',
                                );
                              }
                            }
                                : _isRecording
                                ? _stopRecording
                                : _startRecording,
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
                                size: 28.r),
                          )
                              : MaterialButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                print('object');
                                chatBlocFirebase
                                    .sendMassageFirebaseToFireStore(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),  type: 'ads',
                                  user_id_2: widget.dataMessage!.user_id_2
                                      .toString() ==
                                      DIManager.findDep<SharedPrefs>()
                                          .getUserID()
                                          .toString()
                                      ? widget.dataMessage!.user_id.toString()
                                      : widget.dataMessage!.user_id_2
                                      .toString(),
                                  ad_id: widget.dataMessage!.ad_id.toString(),
                                  dataMassageModel: DataMassageModel(
                                    text: controller.text.toString(),
                                    dateTime: DateTime.now(),
                                    receiverId: widget.dataMessage!.user_id_2
                                        .toString() ==
                                        DIManager.findDep<SharedPrefs>()
                                            .getUserID()
                                            .toString()
                                        ? widget.dataMessage!.user_id
                                        .toString()
                                        : widget.dataMessage!.user_id_2
                                        .toString(),
                                    read: DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                    type: 'text',
                                    totalDurationRecord: '',
                                    sent: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    senderId: DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                  ),
                                  adsChatsModel: AdsChatsModel(
                                    dateTime: DateTime.now().toString(),
                                    ad_id:
                                    widget.dataMessage!.ad_id.toString(),
                                    imageAds: widget.dataMessage!.imageAds
                                        .toString(),
                                    nameAds: widget.dataMessage!.nameAds
                                        .toString(),
                                    idAdOnwerCompany: widget
                                        .dataMessage!.idAdOnwerCompany
                                        .toString(),
                                    nameOwnerAds: widget
                                        .dataMessage!.nameOwnerAds
                                        .toString(),
                                    massage: controller.text.toString(),
                                    isBanner: widget.dataMessage!.isBanner,
                                    categoryId:
                                    widget.dataMessage!.categoryId,
                                    isBannerInOut:
                                    widget.dataMessage!.isBannerInOut,
                                    idBannerOrProduct:
                                    widget.dataMessage!.idBannerOrProduct,
                                    type: 'text',
                                    user_id: widget.dataMessage!.user_id
                                        .toString(),
                                    user_id_2: widget.dataMessage!.user_id_2
                                        .toString(),
                                    userNamePersonSender: widget
                                        .dataMessage!.user_name_person_sender
                                        .toString(),
                                    imageCompany: widget
                                        .dataMessage!.imageCompany
                                        .toString(),
                                    imageUser: widget.dataMessage!.imageUser
                                        .toString(),
                                    read: DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                  ),
                                );
                                sendNotifications(
                                    massage: controller.text.toString());
                                value = "";
                                controller.text = "";
                                // Future.delayed(
                                //         Duration(milliseconds: 500))
                                //     .then((value) => move());
                              }
                            },
                            // onLongPress: _isRecording ?_stopRecording: _startRecording,

                            minWidth: 0,
                            padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 10.h,
                                right: 10.w,
                                left: 10.w),
                            shape: const CircleBorder(),
                            color: Colors.green,
                            child: Icon(Icons.send,
                                color: Colors.white, size: 28.r),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: Row(
                        children: [
                          //input field & buttons
                          !_isRecordingForTextFormFiled
                              ? Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: Row(
                                children: [
                                  sizeWidthNormal(),

                                  Expanded(
                                      child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: _lineCount < 5 ? null : 5,
                                        onTap: () {
                                          // if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                                        },
                                        // onChanged: (value) {
                                        //   setState(() {
                                        //     this.value = value;
                                        //   });
                                        // },
                                        onChanged: (newValue) {
                                          textValueNotifier.value = newValue;
                                        },
                                        style: TextStyle(color: Colors.black),
                                        decoration: const InputDecoration(
                                            hintText: 'ارسل',
                                            hintStyle: TextStyle(
                                                color: Colors.blueAccent),
                                            border: InputBorder.none),
                                      )),

                                  //pick image from gallery button
                                  IconButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                        ImagePicker();

                                        // Picking multiple images
                                        final List<XFile> images =
                                        await picker.pickMultiImage(
                                            imageQuality: 50);

                                        for (var i in images) {
                                          log('Image Path: ${i.path}');

                                          await chatBlocFirebase
                                              .sendChatImage(
                                              DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getUserID()
                                                  .toString(),
                                              File(i.path));
                                        }

                                      },
                                      icon: Icon(Icons.image,
                                          color: Colors.blueAccent,
                                          size: 22.r)),

                                  //take image from camera button
                                  IconButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                        ImagePicker();

                                        // Pick an image
                                        final XFile? image =
                                        await picker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 70);
                                        if (image != null) {
                                          await chatBlocFirebase
                                              .sendChatImage(
                                              DIManager.findDep<
                                                  SharedPrefs>()
                                                  .getUserID()
                                                  .toString(),
                                              File(image.path));
                                        }
                                      },
                                      icon: Icon(Icons.camera_alt_rounded,
                                          color: Colors.blueAccent,
                                          size: 24.r)),

                                  //adding some space
                                  SizedBox(width: 6.w),
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          _isRecordingForTextFormFiled && !_isStopRecording
                              ? Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Container(
                              // width: 10.w,
                              height: 50.h,
                              width: MediaQuery.of(context).size.width * 0.78,
                              decoration:
                              AppDecoration.outlineCircular.copyWith(
                                borderRadius: BorderRadius.circular(9.h),
                              ),
                              child: Center(
                                  child:
                                  textNormal(text:formatDuration(_recordingTime))),
                            ),
                          )
                              : _isStopRecording
                              ? Container(
                            width:
                            MediaQuery.of(context).size.width * 0.78,
                            height: 50.h,
                            decoration:
                            AppDecoration.outlineCircular.copyWith(
                              borderRadius: BorderRadius.circular(30.h),
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.5,
                                  child: Slider(
                                    value: _currentPosition,
                                    max: _totalDuration,
                                    onChanged: (value) {
                                      setState(() {
                                        _currentPosition = value;
                                      });
                                      _player.seek(Duration(
                                          seconds: value.toInt()));
                                    },
                                  ),
                                ),
                                isPlaying
                                    ? textNormal(text:
                                    '${formatDuration(_totalDuration)}')
                                    : textNormal(text:
                                    formatDuration(_currentPosition)),
                                sizeWidthNormal(),
                                InkWell(
                                  onTap: isPlaying
                                      ? _playRecording
                                      : _stopPlaying,
                                  child: Icon(
                                    isPlaying
                                        ? Icons.play_arrow
                                        : Icons.stop,
                                    color: appTheme.black900,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    restartPlay();
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: appTheme.black900,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          //send message button
                          controller.text == ''
                              ? MaterialButton(
                            onPressed: _isDoneRecording
                                ? () async {
                              if (_filePath != null) {
                                _isDoneRecording = false;
                                _isStopRecording = false;
                                isPlaying = true;
                                _isRecordingForTextFormFiled = false;
                                _isRecording = false;
                                await chatBlocFirebase.sendChatVoice(
                                    DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                    File(_filePath!));
                              }
                            }
                                : _isRecording
                                ? _stopRecording
                                : _startRecording,
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
                          )
                              : MaterialButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                print('object');
                                chatBlocFirebase
                                    .sendMassageFirebaseToFireStore(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),  type: 'ads',
                                  user_id_2: widget.dataMessage!.user_id_2
                                      .toString() ==
                                      DIManager.findDep<SharedPrefs>()
                                          .getUserID()
                                          .toString()
                                      ? widget.dataMessage!.user_id.toString()
                                      : widget.dataMessage!.user_id_2
                                      .toString(),
                                  ad_id: widget.dataMessage!.ad_id.toString(),
                                  dataMassageModel: DataMassageModel(
                                    text: controller.text.toString(),
                                    dateTime: DateTime.now(),
                                    receiverId: widget.dataMessage!.user_id_2
                                        .toString() ==
                                        DIManager.findDep<SharedPrefs>()
                                            .getUserID()
                                            .toString()
                                        ? widget.dataMessage!.user_id
                                        .toString()
                                        : widget.dataMessage!.user_id_2
                                        .toString(),
                                    read: DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                    type: 'text',
                                    totalDurationRecord: '',
                                    sent: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    senderId: DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                  ),
                                  adsChatsModel: AdsChatsModel(
                                    dateTime: DateTime.now().toString(),
                                    ad_id:
                                    widget.dataMessage!.ad_id.toString(),
                                    imageAds: widget.dataMessage!.imageAds
                                        .toString(),
                                    nameAds: widget.dataMessage!.nameAds
                                        .toString(),
                                    idAdOnwerCompany: widget
                                        .dataMessage!.idAdOnwerCompany
                                        .toString(),
                                    nameOwnerAds: widget
                                        .dataMessage!.nameOwnerAds
                                        .toString(),
                                    massage: controller.text.toString(),
                                    isBanner: widget.dataMessage!.isBanner,
                                    categoryId:
                                    widget.dataMessage!.categoryId,
                                    isBannerInOut:
                                    widget.dataMessage!.isBannerInOut,
                                    idBannerOrProduct:
                                    widget.dataMessage!.idBannerOrProduct,
                                    type: 'text',
                                    user_id: widget.dataMessage!.user_id
                                        .toString(),
                                    user_id_2: widget.dataMessage!.user_id_2
                                        .toString(),
                                    userNamePersonSender: widget
                                        .dataMessage!.user_name_person_sender
                                        .toString(),
                                    imageCompany: widget
                                        .dataMessage!.imageCompany
                                        .toString(),
                                    imageUser: widget.dataMessage!.imageUser
                                        .toString(),
                                    read: DIManager.findDep<SharedPrefs>()
                                        .getUserID()
                                        .toString(),
                                  ),
                                );
                                APIs.sendNotificationsToUser(
                                  user_id: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),
                                  user_id_2: widget.dataMessage!.user_id_2
                                      .toString() ==
                                      DIManager.findDep<SharedPrefs>()
                                          .getUserID()
                                          .toString()
                                      ? widget.dataMessage!.user_id.toString()
                                      : widget.dataMessage!.user_id_2
                                      .toString(),
                                  ad_id: widget.dataMessage!.ad_id.toString(),
                                  read: DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString(),
                                );

                                value = "";
                                controller.text = "";
                              }
                            },
                            // onLongPress: _isRecording ?_stopRecording: _startRecording,

                            minWidth: 0,
                            padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 10.h,
                                right: 10.w,
                                left: 10.w),
                            shape: const CircleBorder(),
                            color: Colors.green,
                            child: Icon(Icons.send,
                                color: Colors.white, size: 28.fSize),
                          )
                        ],
                      ),
                    );
                  }
                }
              }
              // print(snapshot.data.data()!['userStatus']);
              // print(snapshot.data.data()!['userStatus']);
              // print(snapshot.data.data()!['userStatus']);
              // print(snapshot.data.data()!['userStatus']);
              // print(snapshot.data.data()!['userStatus']);
              // print(snapshot.data.data()!['userStatus']);
              // print(snapshot.data.data()!['userStatus']);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Row(
                  children: [
                    //input field & buttons
                    !_isRecordingForTextFormFiled
                        ? Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Row(
                          children: [
                            sizeWidthNormal(),

                            Expanded(
                                child: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: _lineCount < 5 ? null : 5,
                                  onTap: () {
                                    // if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                                  },
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     this.value = value;
                                  //   });
                                  // },
                                  onChanged: (newValue) {
                                    textValueNotifier.value = newValue;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                      hintText: 'ارسل',
                                      hintStyle:
                                      TextStyle(color: Colors.blueAccent),
                                      border: InputBorder.none),
                                )),

                            //pick image from gallery button
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();

                                  // Picking multiple images
                                  final List<XFile> images = await picker
                                      .pickMultiImage(imageQuality: 50);

                                  for (var i in images) {
                                    log('Image Path: ${i.path}');

                                    await chatBlocFirebase.sendChatImage(
                                        DIManager.findDep<SharedPrefs>()
                                            .getUserID()
                                            .toString(),
                                        File(i.path));
                                  }
                                  sendNotifications(
                                    massage: 'صورة',
                                  );
                                },
                                icon: Icon(Icons.image,
                                    color: Colors.blueAccent,
                                    size: AppFontSize.fontSize_22)),

                            //take image from camera button
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();

                                  // Pick an image
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 70);
                                  if (image != null) {
                                    await chatBlocFirebase.sendChatImage(
                                        DIManager.findDep<SharedPrefs>()
                                            .getUserID()
                                            .toString(),
                                        File(image.path));
                                  }
                                  sendNotifications(
                                    massage: 'صورة',
                                  );
                                },
                                icon: Icon(Icons.camera_alt_rounded,
                                    color: Colors.blueAccent,
                                    size: 24.fSize)),

                            //adding some space
                            SizedBox(width: 6.w),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    _isRecordingForTextFormFiled && !_isStopRecording
                        ? Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Container(
                        // width: 10.w,
                        height: 50.h,
                        width: MediaQuery.of(context).size.width * 0.78,
                        decoration: AppDecoration.outlineCircular.copyWith(
                          borderRadius: BorderRadius.circular(9.h),
                        ),
                        child: Center(
                            child:textNormal(text:formatDuration(_recordingTime))),
                      ),
                    )
                        : _isStopRecording
                        ? Container(
                      width: MediaQuery.of(context).size.width * 0.78,
                      height: 50.h,
                      decoration: AppDecoration.outlineCircular.copyWith(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width:
                            MediaQuery.of(context).size.width * 0.5,
                            child: Slider(
                              value: _currentPosition,
                              max: _totalDuration,
                              onChanged: (value) {
                                setState(() {
                                  _currentPosition = value;
                                });
                                _player.seek(
                                    Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                          isPlaying
                              ? textNormal(text:'${formatDuration(_totalDuration)}')
                              : textNormal(text:formatDuration(_currentPosition)),
                          sizeWidthNormal(),
                          InkWell(
                            onTap: isPlaying ? _playRecording : _stopPlaying,
                            child: Icon(
                              isPlaying ? Icons.play_arrow : Icons.stop,
                              color: appTheme.black900,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              restartPlay();
                            },
                            child: Icon(
                              Icons.delete,
                              color: appTheme.black900,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),
                    //send message button
                    controller.text == ''
                        ? MaterialButton(
                      onPressed: _isDoneRecording
                          ? () async {
                        if (_filePath != null) {
                          _isDoneRecording = false;
                          _isStopRecording = false;
                          isPlaying = true;
                          _isRecordingForTextFormFiled = false;
                          _isRecording = false;
                          await chatBlocFirebase.sendChatVoice(
                              DIManager.findDep<SharedPrefs>()
                                  .getUserID()
                                  .toString(),
                              File(_filePath!));
                        }
                        sendNotifications(
                          massage: 'صوت',
                        );
                      }
                          : _isRecording
                          ? _stopRecording
                          : _startRecording,
                      minWidth: 0,
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
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
                    )
                        : MaterialButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          print('object');
                          chatBlocFirebase.sendMassageFirebaseToFireStore(
                            user_id: DIManager.findDep<SharedPrefs>()
                                .getUserID()
                                .toString(),  type: 'ads',
                            user_id_2: widget.dataMessage!.user_id_2
                                .toString() ==
                                DIManager.findDep<SharedPrefs>()
                                    .getUserID()
                                    .toString()
                                ? widget.dataMessage!.user_id.toString()
                                : widget.dataMessage!.user_id_2.toString(),
                            ad_id: widget.dataMessage!.ad_id.toString(),
                            dataMassageModel: DataMassageModel(
                              text: controller.text.toString(),
                              dateTime: DateTime.now(),
                              receiverId: widget.dataMessage!.user_id_2
                                  .toString() ==
                                  DIManager.findDep<SharedPrefs>()
                                      .getUserID()
                                      .toString()
                                  ? widget.dataMessage!.user_id.toString()
                                  : widget.dataMessage!.user_id_2.toString(),
                              read: DIManager.findDep<SharedPrefs>()
                                  .getUserID()
                                  .toString(),
                              totalDurationRecord: '',
                              type: 'text',
                              sent: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              senderId: DIManager.findDep<SharedPrefs>()
                                  .getUserID()
                                  .toString(),
                            ),
                            adsChatsModel: AdsChatsModel(
                              dateTime: DateTime.now().toString(),
                              ad_id: widget.dataMessage!.ad_id.toString(),
                              imageAds:
                              widget.dataMessage!.imageAds.toString(),
                              nameAds: widget.dataMessage!.nameAds.toString(),
                              idAdOnwerCompany: widget
                                  .dataMessage!.idAdOnwerCompany
                                  .toString(),
                              nameOwnerAds:
                              widget.dataMessage!.nameOwnerAds.toString(),
                              massage: controller.text.toString(),
                              isBanner: widget.dataMessage!.isBanner,
                              categoryId: widget.dataMessage!.categoryId,
                              isBannerInOut:
                              widget.dataMessage!.isBannerInOut,
                              idBannerOrProduct:
                              widget.dataMessage!.idBannerOrProduct,
                              type: 'text',
                              user_id: widget.dataMessage!.user_id.toString(),
                              user_id_2:
                              widget.dataMessage!.user_id_2.toString(),
                              userNamePersonSender: widget
                                  .dataMessage!.user_name_person_sender
                                  .toString(),
                              imageCompany:
                              widget.dataMessage!.imageCompany.toString(),
                              imageUser:
                              widget.dataMessage!.imageUser.toString(),
                              read: DIManager.findDep<SharedPrefs>()
                                  .getUserID()
                                  .toString(),
                            ),
                          );

                          sendNotifications(
                              massage: controller.text.toString());
                          value = "";
                          controller.text = "";
                          // Future.delayed(
                          //         Duration(milliseconds: 500))
                          //     .then((value) => move());
                        }
                      },
                      // onLongPress: _isRecording ?_stopRecording: _startRecording,

                      minWidth: 0,
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
                      shape: const CircleBorder(),
                      color: Colors.green,
                      child: Icon(Icons.send,
                          color: Colors.white, size: 28.fSize),
                    )
                  ],
                ),
              );
            },
          );
        });
      },

    );
  }

  void sendNotifications({required String massage}) {
    APIs.sendNotificationsToUser(
      user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
      user_id_2: widget.dataMessage!.user_id_2.toString() ==
              DIManager.findDep<SharedPrefs>().getUserID().toString()
          ? widget.dataMessage!.user_id.toString()
          : widget.dataMessage!.user_id_2.toString(),
      ad_id: widget.dataMessage!.ad_id.toString(),
      read: DIManager.findDep<SharedPrefs>().getUserID().toString(),
    );

    for (int i = 0; i < deviceTokenUser.length; i++) {
      chatBlocFirebase.sendNotificationsToUser(
          deviceToken: deviceTokenUser[i],
          userNamSender: userId == widget.dataMessage!.user_id.toString()
              ? widget.dataMessage!.user_name_person_sender.toString()
              : widget.dataMessage!.nameOwnerAds.toString(),
          message: massage,
          dataMessage: widget.dataMessage!);
    }
  }
}

String formatDuration(double seconds) {
  int minutes = (seconds / 60).floor();
  int secs = (seconds % 60).floor();
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}
