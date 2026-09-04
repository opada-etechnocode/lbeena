import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syrians_in_uae/ui/screens/chats/test_code2.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/utils/image_constant.dart';
import '../../../core/voice/src/voice_controller.dart';
import '../../../core/voice/src/voice_message_view.dart';
import '../../../data/models/chats/data_massage_model.dart';
import '../../../data/models/parts_voice/common.dart';
import '../../../widgets/components.dart';
import '../../theme/app_decoration.dart';
import '../company/info_company.dart';
import '../parts_voice/widget/control_button.dart';
import 'chat_messages_ad.dart';
import 'dart:ui' as ui;
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
class SenderMessageWidget extends StatefulWidget {
  int index;
  final DataMassageModel? dataMessages;

    SenderMessageWidget({Key? key, this.dataMessages,required this.index}) : super(key: key);

  @override
  State<SenderMessageWidget> createState() => _SenderMessageWidgetState();
}

class _SenderMessageWidgetState extends State<SenderMessageWidget>   with WidgetsBindingObserver{

  final AudioPlayer _player = AudioPlayer();

  final chatBlocFirebase = DIManager.findDep<ChatCubitFirebase>();

  bool isPlaying = true;

  double _currentPosition = 0;

  double _totalDuration = 0;


  // bool isPlaying = true;
  List<bool> isPlayingList = []; // قائمة لتتبع حالة التشغيل لكل عنصر

  // double _currentPosition = 0;
  List<double> currentPositionList = [];
  // double _totalDuration = 0;
  List<double> totalDurationList =
  [];

  Future<void> _playRecording(String url, int index) async {
    try {

      setState(() {
        isPlayingList[index] = false;
      });

      // await _player.setAudioSource(
      //   AudioSource.uri(
      //     Uri.parse(url),
      //     tag: MediaItem(
      //       id: url, // A unique identifier for the audio
      //       title: 'Audio $index', // Replace with actual title if available
      //       artist: 'Unknown', // Replace with actual artist if available
      //       duration: Duration(seconds: totalDurationList[index].toInt()),
      //     ),
      //   ),
      // );

      // Play the audio
      _player.play();

      // Listen to the position stream
      _player.positionStream.listen((position) {
        setState(() {
          currentPositionList[index] = position.inSeconds.toDouble();
        });
      });

      // Listen to the completion of audio playback
      _player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            isPlayingList[index] = true;
          });
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _stopPlay(String url, int index) async {
    try {
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
      await _player.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }
  final dio = Dio();

  Future<File> downloadAndSaveFile(String url, String fileName) async {
    try {
      // تحديد المسار المحلي
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // تحميل الملف مباشرة إلى الملف المحلي
      await dio.download(
        url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration(seconds: 0),
        ),
      );

      print("File saved at $filePath");
      return File(filePath);
    } catch (e) {
      print("Error downloading file: $e");
      rethrow;
    }
  }



  Future<bool> isFileDownloaded(String url) async {
    final directory = await getApplicationDocumentsDirectory();


    final fileName = md5.convert(utf8.encode(url)).toString();
    final filePath = '${directory.path}/$fileName';


    final file = File(filePath);
    return file.existsSync();
  }

  @override
  void dispose() {

    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    isPlayingList = List<bool>.filled(1000, true);
    currentPositionList =
    List<double>.filled(1000, 0.0);
    totalDurationList =
    List<double>.filled(1000, _totalDuration);
    super.initState();
  }  int? indexVideoStop ;
  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.parse(widget.dataMessages!.dateTime.toString());
    String _dateTimeNow = DateFormat("a h:mm", 'ar').format(_dateTime);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(widget.dataMessages!.senderName !=null)...{
            widget.dataMessages!.senderImage=='' ||  widget.dataMessages!.senderImage=='null'||widget.dataMessages!.senderImage=='default_image_url'?  CustomImageView(
              imagePath: ImageConstant.imgPerson,
              width: 30.r,
              height: 30.r, fit: BoxFit.fill,
              radius: BorderRadius.circular(333),
            ): CustomImageView(
              imagePath: widget.dataMessages!.senderImage,
              width: 30.r,
              height: 30.r, fit: BoxFit.fill,
              radius: BorderRadius.circular(333),
            ),
          },

          Column(
            children: [

              ChatBubble(
                clipper: ChatBubbleClipper9(type: BubbleType.sendBubble),
                // alignment: Alignment.topRight,
                // margin: EdgeInsets.only(top: 20),

                backGroundColor: appTheme.deepPurpleA10001,
                child:
                    // data?.type == "text"
                    //     ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.dataMessages!.senderName !=null)...{
                          Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Container(
                                width: 80 .w,
                                height: 20.h,
                                child: textNormal(text: widget.dataMessages!.senderName.toString(),fontSize: 10)
                            ),
                          )


                        },
                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [

                        if (widget.dataMessages!.type == 'image') ...[

                          InkWell(
                            onTap: () {
                              navigatorToPush(
                                  context: context,
                                  pageName: ShowCommercialLicense(
                                    commercialLicense: widget.dataMessages!.text!.toString(),
                                    isPdf: false,
                                    isChats: true,
                                  ));
                            },
                            child: CustomImageView(
                              imagePath: widget.dataMessages!.text!.toString(),
                              width: 240.w,
                              height: 250.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ] else if (widget.dataMessages!.type == 'record') ... [
                          TestVoice2(
                            url: widget.dataMessages!.text!,
                            totalDurationRecord: widget.dataMessages!.totalDurationRecord!,
                          ),

///
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: MediaQuery.of(context).size.width * 0.5,
//                                   child: _totalDuration > 0
//                                       ? Slider(
//                                     value: _currentPosition.clamp(0.0, _totalDuration),
//                                     max: _totalDuration,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _currentPosition = value;
//                                       });
//                                       _player.seek(Duration(seconds: value.toInt()));
//                                     },
//                                   )
//                                       : Slider(
//                                     value: 0.0,
//                                     max: 1.0, // Arbitrary non-zero value to avoid errors
//                                     onChanged: null, // Disable interaction
//                                   ),
//                                 ),
//
//                                 isPlaying && widget.dataMessages?.totalDurationRecord !=null ?   Text(formatDuration(double.parse(widget.dataMessages?.totalDurationRecord ??_totalDuration.toString()))):    Text(formatDuration(_currentPosition)),
//                                 sizeWidthNormal(),
//
//
//                                 InkWell(
//                                   onTap:  (){
//                                     // if(!chatBlocFirebase.isPlaying)
//                                     // {
//                                     //   _stopPlay(widget.dataMessages!.text!);
//                                     //   // return;
//                                     // }
//                                     ///
//                                     // if (isPlaying) {
//                                     //   await _playRecording(widget.dataMessages!.text!, widget.index);
//                                     // } else {
//                                     //   await _stopPlay(widget.dataMessages!.text!);
//                                     // }
//
//                                     ///
//                                     if(isPlayingList[widget.index]){
//                                       if(indexVideoStop !=null){
//                                         _stopPlay(widget.dataMessages!.text!,
//                                             indexVideoStop!);
//
//                                       }
//                                       indexVideoStop = widget.index;
//                                       _playRecording(
//                                           widget.dataMessages!.text!,
//                                           widget.index);
//                                     }else {
//
//                                       _stopPlay(widget.dataMessages!.text!,
//                                          widget.index);
//                                     }
//                                     setState(() {
//
//                                     });
//                                   },
//                                   child: Icon(
//                                     isPlayingList[widget.index]
//                                         ? Icons.play_arrow
//                                         : Icons.stop,
//                                     color: appTheme.black900,
//                                   )
//
//                                 ),
//
//                               ],
//                             ),

///
                          //
                          // StreamBuilder<PlayerState>(
                          //   stream: _player.playerStateStream,
                          //   builder: (context, snapshot) {
                          //     final playerState = snapshot.data;
                          //     final processingState = playerState?.processingState;
                          //     final playing = playerState?.playing;
                          //     if (processingState == ProcessingState.loading ||
                          //         processingState == ProcessingState.buffering) {
                          //       return Container(
                          //         margin: const EdgeInsets.all(8.0),
                          //         width: 20.0,
                          //         height: 20.0,
                          //         child: const CircularProgressIndicator(),
                          //       );
                          //     } else if (playing != true) {
                          //       return IconButton(
                          //         icon:  Icon(Icons.play_arrow,color: appTheme.deepPurple,),
                          //         iconSize: 30.0,
                          //         onPressed:(){
                          //           _init(widget.dataMessages!.text!).then((value) {
                          //             _player.play();
                          //           });
                          //
                          //         },
                          //       );
                          //     } else if (processingState != ProcessingState.completed) {
                          //       return IconButton(
                          //         icon:  Icon(Icons.pause,color: appTheme.deepPurple,),
                          //
                          //         iconSize: 30.0,
                          //         onPressed: _player.pause,
                          //       );
                          //     } else {
                          //       return IconButton(
                          //         icon:  Icon(Icons.replay,color: appTheme.deepPurple,),
                          //         iconSize: 30.0,
                          //         onPressed: () => _player.seek(Duration.zero,
                          //             index: _player.effectiveIndices!.first),
                          //       );
                          //     }
                          //   },
                          // ),
                          // StreamBuilder<PositionData>(
                          //   stream: _positionDataStream,
                          //   builder: (context, snapshot) {
                          //     final positionData = snapshot.data;
                          //     return SeekBar(
                          //       duration: positionData?.duration ?? Duration.zero,
                          //       position: positionData?.position ?? Duration.zero,
                          //       bufferedPosition:
                          //       positionData?.bufferedPosition ?? Duration.zero,
                          //       onChangeEnd: _player.seek,
                          //     );
                          //   },
                          // ),
                          //

                        ]else...[
                          Container(
                            width: widget.dataMessages!.text!.length >= 40 ? 200.w : null,
                            child: Center(
                              child: Text(
                                // "Ut enim nia laborisasdasasdsaaaasas nisi ut aliquip ex ea commodo consequat",
                                widget.dataMessages!.text.toString(),
                                style: themeLite.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                    overflow: TextOverflow.visible),
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        widget.dataMessages!.type == 'image'
                            ? Container()
                            : SizedBox(
                                width: 7.w,
                              ),
                        widget.dataMessages!.type == 'image'
                            ? Container()
                            : Text(
                                // "Ut enim nia laborisasdasasdsaaaasas nisi ut aliquip ex ea commodo consequat",
                                _dateTimeNow,
                                style: themeLite.textTheme.titleSmall!
                                    .copyWith(fontSize: 10.sp, color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                                          ],
                                        ),
                      ],
                    ),

                //     : data?.type == "image"
                //     ? Container(
                //   height: 60.sp,
                //   width: 120.sp,
                //   child: Image.network(
                //     AppConsts.IMAGE_URL + "/" +data!.filepath.toString(),
                //   ),
                // )
                //     : DownloadPdfWidget(
                //   url: data!.filepath!,
                //   name: data!.filename!,
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
