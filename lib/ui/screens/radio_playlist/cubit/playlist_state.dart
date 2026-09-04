import 'package:syrians_in_uae/data/models/parts_voice/voices_model.dart';

import '../../../../data/models/parts_voice/parts_voice_model.dart';
import '../../../../data/models/radio_model/details_playList_model.dart';
import '../../../../data/models/radio_model/playList_model.dart';

abstract class PlayListState {}

class PartsVoiceInitial extends PlayListState {}

class LoadingPartsVoiceStatus extends PlayListState {}
class SuccessPartsVoiceStatus extends PlayListState {

  List<PlayListModel> playListModel =[];
  SuccessPartsVoiceStatus(this.playListModel);
}


class ErrorPartsVoiceStatus extends PlayListState {
  String error;
  ErrorPartsVoiceStatus(this.error);
}



class LoadingVoicesListStatus extends PlayListState {}
class SuccessVoicesListStatus extends PlayListState {

  List<DetailsPlayListModel> detailsPlayList =[];
  SuccessVoicesListStatus(this.detailsPlayList);
}


class ErrorVoicesListStatus extends PlayListState {
  String error;
  ErrorVoicesListStatus(this.error);
}