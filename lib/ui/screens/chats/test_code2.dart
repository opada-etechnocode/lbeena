import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syrians_in_uae/data/models/parts_voice/common.dart';

import '../../../widgets/components.dart';
import '../../theme/theme_helper.dart';
import 'chat_messages_ad.dart';

class TestVoice2 extends StatefulWidget {
  final String url;
  final String totalDurationRecord;

  TestVoice2({Key? key, 
    required this.url,
    required this.totalDurationRecord,
  
  }) : super(key: key);

  @override
  TestVoice2State createState() => TestVoice2State();
}

class TestVoice2State extends State<TestVoice2> with WidgetsBindingObserver {
  final AudioPlayer _player = AudioPlayer();

  bool isPlaying = true;

  double _currentPosition = 0;

  double _totalDuration = 0;

  Future<void> _playRecording(String url) async {
    setState(() {
      isPlaying = false;
    });

    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          // tag: MediaItem(
          //   id: url,
          //   title: "Recording Title",
          //   artist: "Artist Name",
          //   album: "Album Name",playable: true,isLive: false,
          // ),
        ),
      );

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
    return        Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width:MediaQuery.of(context).size.width * 0.5,
          child: Slider(
            value: _currentPosition,
            max: _totalDuration,
            onChanged: (value) {
              setState(() {
                _currentPosition = value;
              });
              _player.seek(Duration(seconds: value.toInt()));
            },
          ),
        ),
        isPlaying ?  Text(formatDuration(double.parse(widget.totalDurationRecord ??_totalDuration.toString()))):    Text(formatDuration(_currentPosition)),
        sizeWidthNormal(),


        InkWell(
          onTap:  (){

            isPlaying? _playRecording(widget.url):  _stopPlay(widget.url);

          },
          child: Icon(
            isPlaying? Icons.play_arrow:Icons.stop,
            color: appTheme.black900,
          ),
        ),

      ],
    );
  }
}
