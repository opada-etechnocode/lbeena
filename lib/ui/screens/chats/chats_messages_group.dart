import 'dart:async';
import 'dart:developer';
import 'dart:io';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
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
import 'chats_details_group.dart';
import 'cubit/apis_chat_firebase.dart';
import 'receiver_message.dart';
import 'sender_message.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatMessagesGroup extends StatefulWidget {
  final ArgumentMessageGroup? dataMessage;

  const ChatMessagesGroup({Key? key, this.dataMessage}) : super(key: key);

  @override
  State<ChatMessagesGroup> createState() => _ChatMessagesGroupState();
}

class _ChatMessagesGroupState extends State<ChatMessagesGroup>
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

  Future<void> startRecording() async {
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
  Future<void> stopRecording() async {
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

  Future<void> playRecording() async {
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
          stopPlaying(); // إيقاف التشغيل عند الانتهاء
        }
      });
    }
  }

  Future<void> stopPlaying() async {
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

    APIs.markMessageAsRead(groupId: widget.dataMessage!.groupId.toString(), userId: DIManager.findDep<SharedPrefs>().getUserID().toString());
    // APIs.updateMessageReadStatus(
    //   user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
    //   user_id_2: widget.dataMessage!.user_id_2.toString() ==
    //       DIManager.findDep<SharedPrefs>().getUserID().toString()
    //       ? widget.dataMessage!.user_id.toString()
    //       : widget.dataMessage!.user_id_2.toString(),
    //   ad_id: widget.dataMessage!.ad_id.toString(),
    //   type: 'ads',
    //   read: DIManager.findDep<SharedPrefs>().getUserID().toString(),
    // );
    //
    // APIs.getMessageReadStatus(
    //   user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
    //   user_id_2: widget.dataMessage!.user_id_2.toString() ==
    //       DIManager.findDep<SharedPrefs>().getUserID().toString()
    //       ? widget.dataMessage!.user_id.toString()
    //       : widget.dataMessage!.user_id_2.toString(),
    //   ad_id: widget.dataMessage!.ad_id.toString(),type: 'ads',
    // );
    //
    APIs.deleteNotificationsToUser(
      user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
      user_id_2: '',
      type: 'group',
      ad_id: widget.dataMessage!.groupId.toString(),
    );
    //
    // chatBlocFirebase.getAdsLastInfoForUserReceiver(
    //     user_id: DIManager.findDep<SharedPrefs>().getUserID().toString(),
    //     user_id_2: widget.dataMessage!.user_id_2.toString() ==
    //         DIManager.findDep<SharedPrefs>().getUserID().toString()
    //         ? widget.dataMessage!.user_id.toString()
    //         : widget.dataMessage!.user_id_2.toString(),
    //     ad_id: widget.dataMessage!.ad_id.toString(),
    //     type: 'ads'
    // );

    // APIs.getStatusUser(
    //   userID: widget.dataMessage!.user_id_2.toString() ==
    //       DIManager.findDep<SharedPrefs>().getUserID().toString()
    //       ? widget.dataMessage!.user_id.toString()
    //       : widget.dataMessage!.user_id_2.toString(),
    // );

    controller.addListener(_checkLineCount);
    // chatBlocFirebase.getDeviceTokenUser(
    //     userId: widget.dataMessage!.user_id_2.toString() ==
    //         DIManager.findDep<SharedPrefs>().getUserID().toString()
    //         ? widget.dataMessage!.user_id.toString()
    //         : widget.dataMessage!.user_id_2.toString());
    WidgetsBinding.instance.addObserver(this);

    controllerScroller = ScrollController();
  }

  @override
  void dispose()async {
    controller.removeListener(_checkLineCount);
    controller.dispose();
    // _audioPlayer.dispose();
    _recorder.dispose();
    // scrollController.dispose();
    // await _recorder.closeRecorder();
     _player.dispose();
    textValueNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  bool isLoadingChats = true;
  String? userId = DIManager.findDep<SharedPrefs>().getUserID();
  List deviceTokenUser = [];

  Map<String, List<DataMassageModel>> groupMessagesByDate(
      List<DataMassageModel> messages) {
    Map<String, List<DataMassageModel>> groupedMessages = {};
    for (var message in messages) {
      String date =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(message.dateTime.toString()));
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
    // print('statusUser: $statusUser');

    return HandelAndroidApp(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: appTheme.scaffoldBackgroundColor100,
          leading: SizedBox(),
          title: Row(
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

              SizedBox(width: 7.w), // Space between image and text
              InkWell(
                onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return ChatDetailsGroup(
          dataMessage: ArgumentMessageGroup(
      groupName: widget.dataMessage!.groupName.toString(),
      adminId: widget.dataMessage!.adminId.toString(),
      groupId: widget.dataMessage!.groupId .toString(),),
        );
      }));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                    width: 240.w,
                    child: textNormal(text:
                        widget.dataMessage!.groupName.toString(),
                        // style: themeLite.textTheme.titleSmall,
                      ),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          leadingWidth: 0.w,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Builder(builder: (context) {
            chatBlocFirebase.getGroupMessages(widget.dataMessage!.groupId!);
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

                  if (state is SendMessageSuccessUploadImageState) {
                    APIs.sendMessageToGroup(
                        groupId: widget.dataMessage!.groupId!,
                        dataMassageModel: DataMassageModel(
                          text: state.imageUrl,
                          senderId: DIManager.findDep<SharedPrefs>().getUserID(),
                          senderName:DIManager.findDep<SharedPrefs>().getAccountType() =='company'? DIManager.findDep<SharedPrefs>().getUserNameCompany(): DIManager.findDep<SharedPrefs>().getUserName(),
                          senderImage:  DIManager.findDep<SharedPrefs>().getImageProfile(),
                          type: 'image',
                        ));
                    APIs.lastMessage(groupId:  widget.dataMessage!.groupId!, lastMessage: state.imageUrl!,
                        type: 'image',
                        senderId:  DIManager.findDep<SharedPrefs>().getUserID().toString());
                  }
                  if (state is SendMessageSuccessUploadRecordState) {
                    restartPlay();
                    APIs.sendMessageToGroup(
                        groupId: widget.dataMessage!.groupId!,
                        dataMassageModel: DataMassageModel(
                          text: state.recorderUrl,
                          senderId: DIManager.findDep<SharedPrefs>().getUserID(),
                          senderName:DIManager.findDep<SharedPrefs>().getAccountType() =='company'? DIManager.findDep<SharedPrefs>().getUserNameCompany(): DIManager.findDep<SharedPrefs>().getUserName(),
                          senderImage:  DIManager.findDep<SharedPrefs>().getImageProfile(),
                          type: 'record',
                          totalDurationRecord: _totalDuration.toString(),
                        ));

                    APIs.lastMessage(groupId:  widget.dataMessage!.groupId!, lastMessage: 'تسجيل صوتي جديد',
                        type: 'record',
                        senderId:  DIManager.findDep<SharedPrefs>().getUserID().toString());
                  }
                },
                builder: (context, state) {
                  DateTime timeMessage = chatBlocFirebase.messages.isNotEmpty
                      ? chatBlocFirebase.messages[0].dateTime!
                      : DateTime.now();
                  String _dateTimeNow = DateFormat.yMMMMd().format(timeMessage);

                  return Column(
                    children: [

                      chatBlocFirebase.messagesGroup.isNotEmpty
                          ? Container()
                          : MessageAvisWidget(),
                        buildMessages(
                        groupMessagesByDate(chatBlocFirebase.messagesGroup),
                        state),


                      state is ChatFirebaseLoadingUploadImageState
                          ? LoadingAnimationWidget.threeRotatingDots(color: appTheme.greenColor, size: 60,)
                          : Container(),
                      state is ChatFirebaseLoadingUploadRecordState
                          ? LoadingAnimationWidget.threeRotatingDots(color: appTheme.greenColor, size: 60,)
                          : Container(),

                      Padding(
                        padding:  EdgeInsets.only(bottom: 20.h),
                        child:_chatInput(),
                      )
                    ],
                  );
                },
              ),
            );
          }),
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

              //     for(int i = dateMessages.length -1;i<0;i--)...{
              // if (dateMessages[i].senderId ==
              // DIManager.findDep<SharedPrefs>()
              //     .getUserID()
              //     .toString())... {
              //  SenderMessageWidget(dataMessages: dateMessages[i])
              // } else... {
              //  ReceivedMessageWidget(dataMessages: dateMessages[i])
              // }
              //     }
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
                    return SenderMessageWidget(dataMessages: message,index: index,);
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
      builder: (context, value, child) {
        return Builder(builder: (context) {
          // APIs.updateStatusUser(userStatus: statusUser);
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
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                          child: Center(
                              child: Text(formatDuration(_recordingTime))),
                        ),
                      )
                    : _isStopRecording
                        ? Padding(
                          padding:  EdgeInsets.only(left: 10),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.78,
                              height: 50.h,
                              decoration: AppDecoration.outlineCircular.copyWith(
                                borderRadius: BorderRadius.circular(30.h),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: Slider(
                                      value: _currentPosition,
                                      max: _totalDuration,
                                      onChanged: (value) async {
                                        setState(() {
                                          _currentPosition = value;
                                        });
                                        // Seek to the new position
                                        await _player.seek(Duration(seconds: value.toInt()));

                                      },
                                    ),
                                  ),
                                  Text(isPlaying ? '${formatDuration(_totalDuration)}' : formatDuration(_currentPosition)),
                                  sizeWidthNormal(),
                                  InkWell(
                                    onTap: () async {
                                      if (isPlaying) {
                                        await playRecording();
                                      } else {
                                        await stopPlaying();
                                      }
                                    },
                                    child: Icon(
                                      isPlaying ? Icons.play_arrow : Icons.stop,
                                      color: appTheme.black900,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await restartPlay();
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
                                }
                                sendNotifications(
                                  massage: 'صوت',
                                );
                              }
                            : _isRecording
                                ? stopRecording
                                : startRecording,
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
                            APIs.sendMessageToGroup(
                                groupId: widget.dataMessage!.groupId!,
                                dataMassageModel: DataMassageModel(
                                    text: controller.text,
                                    senderId: DIManager.findDep<SharedPrefs>().getUserID(),
                                    senderName:DIManager.findDep<SharedPrefs>().getAccountType() =='company'? DIManager.findDep<SharedPrefs>().getUserNameCompany(): DIManager.findDep<SharedPrefs>().getUserName(),
                                    senderImage:  DIManager.findDep<SharedPrefs>().getImageProfile(),
                                    type: 'text',
                             ));

                            APIs.lastMessage(groupId:  widget.dataMessage!.groupId!, lastMessage: controller.text,
                                type: 'text',
                            senderId:  DIManager.findDep<SharedPrefs>().getUserID().toString());
                            sendNotifications(
                                massage: controller.text.toString());
                            value = "";
                            controller.text = "";
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
        });
      },
    );
  }

  void sendNotifications({required String massage}) {
    List<String> userIds = [];

    // التحقق من أن userGroups ليست null وأنها تحتوي على 'members'
    if (widget.dataMessage!.userGroups != null &&
        widget.dataMessage!.userGroups!['members'] != null) {
      // الحصول على الخريطة من 'members'
      Map<String, dynamic> members = widget.dataMessage!.userGroups!['members'];

      // استخراج المفاتيح كقائمة
      userIds = members.keys.toList();

      // طباعة القائمة لاختبارها
      print(userIds);
    } else {
      print('userGroups or members is null');
    }

    // معرف المستخدم الحالي
    String currentUserId = DIManager.findDep<SharedPrefs>().getUserID().toString();

    // إرسال الإشعارات لجميع المستخدمين باستثناء currentUserId
    for (String userId in userIds) {
      if (userId != currentUserId) {
        print(userId);
        APIs.sendNotificationsToUser(
          user_id: currentUserId,
          user_id_2: userId,
          type: 'group',
          read: currentUserId,
          ad_id: widget.dataMessage!.groupId!,
        );
      }
    }

    // إرسال إشعارات إضافية باستخدام deviceTokenUser
    for (int i = 0; i < deviceTokenUser.length; i++) {
      // chatBlocFirebase.sendNotificationsToUser(
      //     deviceToken: deviceTokenUser[i],
      //     userNamSender: userId == widget.dataMessage!.user_id.toString()
      //         ? widget.dataMessage!.user_name_person_sender.toString()
      //         : widget.dataMessage!.nameOwnerAds.toString(),
      //     message: massage,
      //     dataMessage: widget.dataMessage!);
    }
  }

}

String formatDuration(double seconds) {
  int minutes = (seconds / 60).floor();
  int secs = (seconds % 60).floor();
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}
