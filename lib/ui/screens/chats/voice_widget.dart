import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  double totalDuration;

  AudioPlayerWidget({Key? key, required this.audioUrl, required this.totalDuration}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  double _currentPosition = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // إعداد just_audio_background
    _initializeAudioBackground();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position.inSeconds.toDouble();
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _initializeAudioBackground() async {
    // إعداد just_audio_background
    // await JustAudioBackground.init(
    //   androidNotificationChannelId: 'com.example.audio',
    //   androidNotificationChannelName: 'Audio playback',
    //   androidNotificationOngoing: true,
    // );
  }

  Future<void> _play(String url) async {
    setState(() {
      _isPlaying = true;
    });

    try {
      // await _audioPlayer.setAudioSource(
      //   AudioSource.uri(
      //     Uri.parse(url),
      //     tag: MediaItem(
      //       id: url,
      //       title: "Recording Title",
      //       artist: "Artist Name",
      //       album: "Album Name",
      //     ),
      //   ),
      // );

      await Future.delayed(Duration(milliseconds: 200));

      // تحديث طول المدة
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          widget.totalDuration = duration?.inSeconds.toDouble() ?? 0;
        });
      });

      _audioPlayer.play();

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _pause();
          });
        }
      });
    } catch (e) {
      print("Error while playing recording: $e");
    }
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Slider
        Expanded(
          child: Slider(
            value: _currentPosition,
            max: widget.totalDuration,
            onChanged: (value) {
              setState(() {
                _currentPosition = value;
              });
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
        ),
        // Time Display
        Text(
          _formatDuration(_currentPosition),
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: 10),
        // Play/Pause Button
        IconButton(
          onPressed: (){
            if (_isPlaying) {
              _pause();
            } else {
              _play(widget.audioUrl);
            }
          },
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        ),
      ],
    );
  }
}
