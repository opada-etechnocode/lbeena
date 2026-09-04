import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../data/models/parts_voice/common.dart';
import '../../../theme/theme_helper.dart';
import '../../reminders/cubit/reminder_cubit.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  bool isFromPost =false;

   ControlButtons(this.player, {Key? key,this.isFromPost =false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon:  Icon(Icons.volume_up,color: appTheme.greenColor,),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        if(!isFromPost)...{
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon:  Icon(Icons.skip_next,color: appTheme.greenColor,),
              onPressed: player.hasPrevious ? player.seekToPrevious : null,
            ),
          ),
        },

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child:  CircularProgressIndicator(color: appTheme.greenColor,),
              );
            } else if (playing != true) {
              return IconButton(
                icon:  Icon(Icons.play_arrow,color: appTheme.greenColor,),
                iconSize: 64.0,
                onPressed: (){
                  ReminderCubit.get(context).stopRadioIfPlay();
                  player.play();
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon:  Icon(Icons.pause,color: appTheme.greenColor,),

                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon:  Icon(Icons.replay,color: appTheme.greenColor,),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        if(!isFromPost)...{
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(

              icon:  Icon(Icons.skip_previous,color: appTheme.greenColor,),
              onPressed: player.hasNext ? player.seekToNext : null,
            ),
          ),
        },

        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style:  TextStyle(fontWeight: FontWeight.bold,color: appTheme.greenColor,)),
            onPressed: () {
              if(snapshot.data ==1.0)
              {
                player.speed;
                player.speedStream;
                player.setSpeed(1.5);
              }
              if(snapshot.data ==1.5)
              {
                player.speed;
                player.speedStream;
                player.setSpeed(2.0);
              }
              if(snapshot.data ==2.0)
              {
                player.speed;
                player.speedStream;
                player.setSpeed(0.5);
              }
              if(snapshot.data ==0.5)
              {
                player.speed;
                player.speedStream;
                player.setSpeed(1.0);
              }
              // showSliderDialog(
              //   context: context,
              //   title: "Adjust speed",
              //   divisions: 10,
              //   min: 0.5,
              //   max: 1.5,
              //   value: player.speed,
              //   stream: player.speedStream,
              //   onChanged: player.setSpeed,
              // );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}