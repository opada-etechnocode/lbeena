import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syrians_in_uae/data/models/parts_voice/common.dart';

import '../../theme/theme_helper.dart';

class TestVoice extends StatefulWidget {
  final String url;

  TestVoice({Key? key, required this.url}) : super(key: key);

  @override
  TestVoiceState createState() => TestVoiceState();
}

class TestVoiceState extends State<TestVoice> with WidgetsBindingObserver {
  // استخدم instance واحدة للمشغل
  static final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    // إعداد الصوت
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // الاستماع للأخطاء
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    // محاولة تحميل الصوت من المصدر
    try {
      // إيقاف الصوت الحالي إذا كان قيد التشغيل
      if (_player.playing) {
        await _player.stop();
      }

      // تعيين مصدر الصوت الجديد
      await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.url)));
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // لا تقم بتدمير المشغل لأنه سيتم إعادة استخدامه عبر التطبيق
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // أوقف الصوت عندما يصبح التطبيق في الخلفية
      _player.stop();
    }
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButtons(_player),
        Container(width: 100,
          child: StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: _player.seek,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
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
            child: CircularProgressIndicator(color: appTheme.greenColor,),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 20.0,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 20.0,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 20.0,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }
}
