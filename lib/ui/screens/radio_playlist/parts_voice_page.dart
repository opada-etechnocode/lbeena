import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/data/models/radio_model/details_playList_model.dart';
import 'package:syrians_in_uae/data/models/radio_model/playList_model.dart';
import 'package:syrians_in_uae/ui/screens/parts_voice/widget/control_button.dart';
import '../../../core/constants/app_font.dart';
import '../../../data/models/parts_voice/common.dart';
import '../../../widgets/components.dart';
import '../../../widgets/main_parts_shimmer.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../reminders/cubit/reminder_cubit.dart';
import 'cubit/playlist_cubit.dart';
import 'cubit/playlist_state.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';
class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>  with WidgetsBindingObserver ,LifecycleMixin{
  List<bool> isSelectAvailableList =
  List.generate(100, (index) => index == 0 ? true : false);
  List<PlayListModel> data = [];

  final AudioPlayer _audioPlayer = AudioPlayer();
  int? partsId;
  bool isLoadingVoices = true;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<DetailsPlayListModel> dataVoices =[];

  String formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  late AudioPlayer _player;

  _playlist(List<DetailsPlayListModel>  dataVoices){

    return  ConcatenatingAudioSource(children: [
      for(int i =0; i< dataVoices.length;i++)...{
        AudioSource.uri(
          Uri.parse(dataVoices[i].mediaId.toString()),
          headers: {
            "Authorization":'Bearer 4ab16008e0a3a062:5e0ddb92a78e14348ffe2d62d78083c2',
            "accept":'application/json',
          },
          tag: AudioMetadata(album: dataVoices[i].artist.toString(), title: dataVoices[i].title.toString(), artwork: dataVoices[i].spmId.toString(),)
          // tag: MediaItem(
          //   id: dataVoices[i].spmId.toString(),
          //   album: dataVoices[i].artist.toString(),
          //   title:  dataVoices[i].title.toString(),
          // ),
        ),
      }


    ]);
  }
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _audioPlayer.dispose();
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }
  @override
  void onAppLifecycleChange(AppLifecycleState state) {
    setState(() {
      if(ReminderCubit.get(context).statusBackgroundRadio){
        _player.stop();
        _audioPlayer.stop();
      }
    });
  }
  @override
  void initState() {
    super.initState();

    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _player = AudioPlayer();


  }


  Future<void> _init(List<DetailsPlayListModel>  dataVoices) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {
      // Preloading audio is not currently supported on Linux.
      await _player.setAudioSource(_playlist(dataVoices),
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } on PlayerException catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
    // Show a snackbar whenever reaching the end of an item in the playlist.
    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _showItemFinished(_player.currentIndex);
      }
    });
  }

  void _showItemFinished(int? index) {
    if (index == null) return;
    final sequence = _player.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as AudioMetadata;
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('Finished playing ${metadata.title}'),
      duration: const Duration(seconds: 1),
    ));
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
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text: 'المختارات', context: context,isShowBack: true),
        body: BlocProvider(
          create: (context) => PlayListCubit()..getPlayList(),
          child: BlocConsumer<PlayListCubit, PlayListState>(
            listener: (context, state) {
              if (state is SuccessPartsVoiceStatus) {
                data = state.playListModel;
                partsId = data.first.id;
                BlocProvider.of<PlayListCubit>(context)
                    .getDetailsPlayList( partsId: partsId!);
              }
              if(state is LoadingVoicesListStatus){
                dataVoices.clear();
                isLoadingVoices = true;
              }

              if(state is SuccessVoicesListStatus) {
                dataVoices = state.detailsPlayList.reversed.toList(); // <<< هنا
                isLoadingVoices = false;
                _init(dataVoices);
              }

              if(state is ErrorVoicesListStatus){
                isLoadingVoices = false;
              }
            },
            builder: (context, state) {
              return Column(
                children: [

                  state is LoadingPartsVoiceStatus
                      ? MainPartsShimmer(
                    isFromAddAds: true,
                  )
                      : Container(
                    height: 50.h,
                    child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                for (int i = 0;
                                i < isSelectAvailableList.length;
                                i++) {
                                  isSelectAvailableList[i] = i == index;
                                }
                                partsId =data[index].id;
                              });

                              BlocProvider.of<PlayListCubit>(context)
                                  .getDetailsPlayList(partsId: partsId!);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(
                                backgroundColor:
                                !isSelectAvailableList[index]
                                    ? Colors.grey
                                    : appTheme.deepPurpleA100,
                                // avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
                                label: textNormal(
                                  text: data[index].name ?? '',
                                  fontSize: AppFontSize.fontSize_12,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),

                  if(dataVoices.isNotEmpty)...{
                    ControlButtons(
                        _player
                    ),
                    StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SeekBar(
                          duration: positionData?.duration ?? Duration.zero,
                          position: positionData?.position ?? Duration.zero,
                          bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                          onChangeEnd: (newPosition) {
                            _player.seek(newPosition);
                          },
                        );
                      },
                    ),
                  },

                  sizeHeightNormal(),
                  Expanded(
                      child: isLoadingVoices? ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context,index){
                            return Shimmer.fromColors(
                              baseColor: appTheme.baseColorShimmer,
                              highlightColor: appTheme.highlightColorShimmer,

                              child: Container(
                                height: 60.h,
                                decoration: AppDecoration.dropdownButtonChoose,
                              ),
                            );
                          }): dataVoices.isEmpty ?Center(
                        child: Container(
                          child: textNormal(text: 'لا يتوفر مختارات صوتية في هذا القسم بعد ..',fontSize: 12.5),
                        ),
                      ):StreamBuilder<SequenceState?>(
                        stream: _player.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final sequence = state?.sequence ?? [];
                          final reversedSequence = sequence.reversed.toList(); // <<< هنا

                          return ReorderableListView(
                            onReorder: (int oldIndex, int newIndex) {
                              if (oldIndex < newIndex) newIndex--;
                              _playlist(dataVoices).move(oldIndex, newIndex); // هذا قد يحتاج تعديل لو تريد دعم الترتيب الجديد
                            },
                            // shrinkWrap: true,

                            children: [
                              for (var i = 0; i < reversedSequence.length; i++)
                                Container(
                                  key: ValueKey(reversedSequence[i],),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.h,horizontal:8.w),
                                    child: InkWell(
                                      onTap: (){
                                        _player.seek(Duration.zero, index: i);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: AppDecoration.pointChoose.copyWith(
                                              color: i == state!.currentIndex
                                                  ?  appTheme.greenColor
                                                  : appTheme.scaffoldBackgroundColor100,
                                            ),

                                          ),
                                          sizeWidthNormal(),
                                          Container(
                                            width: 300.w,
                                            height: 40.h,
                                            decoration: AppDecoration.pointChoose.copyWith(
                                              color: i == state!.currentIndex
                                                  ?  appTheme.greenColor
                                                  : appTheme.scaffoldBackgroundColor100,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                  width: 250.w,
                                                  child: Text(sequence[i].tag.title as String,style: TextStyle(color: appTheme.black900,overflow: TextOverflow.ellipsis),)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Material(
                                  //   color: i == state!.currentIndex
                                  //       ?  appTheme.deepPurple
                                  //       : appTheme.scaffoldBackgroundColor100,
                                  //   child: ListTile(
                                  //    style: ListTileStyle.list,
                                  //
                                  //     title: Text(sequence[i].tag.title as String,style: TextStyle(color: appTheme.black900),),
                                  //     onTap: () {
                                  //       _player.seek(Duration.zero, index: i);
                                  //     },
                                  //   ),
                                  // ),
                                ),
                            ],
                          );
                        },
                      )),
                  sizeHeightNormal(
                    height: 40.h
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
