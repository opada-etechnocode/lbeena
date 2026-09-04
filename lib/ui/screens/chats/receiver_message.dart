// import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/screens/chats/test_code.dart';
import 'package:syrians_in_uae/ui/screens/chats/test_code2.dart';
import 'package:syrians_in_uae/ui/screens/chats/voice_widget.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_font.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../../../data/models/chats/data_massage_model.dart';
import '../../../data/models/parts_voice/common.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_image_view.dart';
import '../company/info_company.dart';
import '../parts_voice/widget/control_button.dart';
import 'chat_messages_ad.dart';
import 'dart:ui' as ui;
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';
class ReceivedMessageWidget extends StatefulWidget {

  final DataMassageModel? dataMessages;

  const ReceivedMessageWidget({Key? key,this.dataMessages}) : super(key: key);

  @override
  State<ReceivedMessageWidget> createState() => _ReceivedMessageWidgetState();
}

class _ReceivedMessageWidgetState extends State<ReceivedMessageWidget>  with WidgetsBindingObserver{
  final AudioPlayer _player = AudioPlayer();

  bool isPlaying = true;

  double _currentPosition = 0;

  double _totalDuration = 0;

  Future<void> _playRecording(String url) async {
    setState(() {
      isPlaying = false;
    });

    try {
      // await _player.setAudioSource(
        // AudioSource.uri(
        //   Uri.parse(url),
        //   tag: MediaItem(
        //     id: url,
        //     title: "Recording Title",
        //     artist: "Artist Name",
        //     album: "Album Name",
        //   ),
        // ),
      // );

      await Future.delayed(Duration(milliseconds: 200));

      _player.durationStream.listen((duration) {
        setState(() {
          _totalDuration = duration?.inSeconds.toDouble() ?? 0;
        });
      });

      _player.play();

      _player.positionStream.listen((position) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });

        if (_currentPosition >= _totalDuration && _totalDuration > 0) {
          setState(() {
            isPlaying = true;
          });
        }
      });

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = true;
            _stopPlay(url);
          });
        }
      });
    } catch (e) {
      print("Error while playing recording: $e");
    }
  }


  Future<void> _stopPlay(String url) async {
    setState(() {
      isPlaying = true;
    });

    try {
      // await _player.setUrl(url);
      // _totalDuration = _player.duration?.inSeconds.toDouble() ?? 0;

      await _player.stop();
    } catch (e) {
      print("Error while stopping playback: $e");
    }
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.parse(widget.dataMessages!.dateTime.toString());
    String _dateTimeNow = DateFormat("a h:mm",'ar').format(_dateTime);
    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          ChatBubble(
              clipper: ChatBubbleClipper9(type: BubbleType.receiverBubble),
              // alignment: Alignment.topRight,
              // margin: EdgeInsets.only(top: 20),

              backGroundColor: Colors.grey,
              child:
              // data?.type == "text"
              //     ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(widget.dataMessages!.senderName !=null)...{
                    Directionality(
                      textDirection: isArabic(widget.dataMessages!.senderName.toString())
                          ? ui.TextDirection.rtl
                          : ui.TextDirection.ltr,
                      child: Container(
                        width: 80.w,       height: 20.h,
                        child: textNormal(text: widget.dataMessages!.senderName.toString(),fontSize: 10)
                      ),
                    )


                  },
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [


                      widget.dataMessages!.type == 'image'?Container():     Text(
                        _dateTimeNow,
                        style: themeLite.textTheme.titleSmall!.copyWith(color: Colors.white,fontSize: 10.sp,),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      widget.dataMessages!.type == 'image'?Container():  SizedBox(width: 7.w,),

                      if(widget.dataMessages!.type == 'image')...[
                        InkWell(
                          onTap: (){
                            navigatorToPush(context: context, pageName: ShowCommercialLicense(commercialLicense: widget.dataMessages!.text!.toString(),
                              isPdf: false,isChats: true,));
                          },
                          child: CustomImageView(
                            imagePath: widget.dataMessages!.text!.toString(),
                            width: 240.w,
                            height: 250.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ]else if (widget.dataMessages!.type == 'record')... [
                        // Container(
                        //   width: 220,
                        //   height: 40,
                        //   child: AudioPlayerWidget(
                        //     audioUrl: widget.dataMessages!.text!,
                        //     totalDuration: double.parse(widget.dataMessages!.totalDurationRecord!),
                        //   ),
                        // ),
///
//                         Container(
//                           width: 220,
//                           height: 40,
//                           child: TestVoice(
//                             url: widget.dataMessages!.text!,
//                           ),
//                         ),
///
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width:MediaQuery.of(context).size.width * 0.5,
//                               child: Slider(
//                                 value: _currentPosition,
//                                 max: _totalDuration,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _currentPosition = value;
//                                   });
//                                   _player.seek(Duration(seconds: value.toInt()));
//                                 },
//                               ),
//                             ),
//                           isPlaying ?  Text(formatDuration(double.parse(widget.dataMessages!.totalDurationRecord ??_totalDuration.toString()))):    Text(formatDuration(_currentPosition)),
//                             sizeWidthNormal(),
//
//
//                             InkWell(
//                               onTap:  (){
//
//                                 isPlaying? _playRecording(widget.dataMessages!.text!):  _stopPlay(widget.dataMessages!.text!);
//
//                               },
//                               child: Icon(
//                                 isPlaying? Icons.play_arrow:Icons.stop,
//                                 color: appTheme.black900,
//                               ),
//                             ),
//
//                           ],
//                         ),
///
                        TestVoice2(
                          url: widget.dataMessages!.text!,
                          totalDurationRecord: widget.dataMessages!.totalDurationRecord!,
                        ),

                      ]else...[
                        Container(
                          width: widget.dataMessages!.text!.length >= 40? 200.w : null,
                          child: Center(
                            child: Text(
                              widget.dataMessages!.text.toString(),
                              style: themeLite.textTheme.titleSmall!.copyWith(color: Colors.white,overflow: TextOverflow.visible),

                            ),
                          ),
                        ),
                      ],

                    ],
                  ),
                ],
              )

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
          if(widget.dataMessages!.senderName !=null)...{
            widget.dataMessages!.senderImage=='' ||  widget.dataMessages!.senderImage=='null'|| widget.dataMessages!.senderImage=='default_image_url'?  CustomImageView(
              imagePath: ImageConstant.imgPerson,
              width: 30.r,
              height: 30.r, fit: BoxFit.fill,
              radius: BorderRadius.circular(333),
            ):  CustomImageView(
              imagePath: widget.dataMessages!.senderImage,
              width: 30.r,
              height: 30.r, fit: BoxFit.fill,
              radius: BorderRadius.circular(333),
            ),
          },
        ],
      ),
    );
  }
}
