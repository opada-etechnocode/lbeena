

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syrians_in_uae/ui/screens/radio_playlist/cubit/playlist_state.dart';

import '../../../../data/sources/parts_voice/parts_voice_page_data_source.dart';

class PlayListCubit extends Cubit<PlayListState> {
  PlayListCubit() : super(PartsVoiceInitial());

  static PlayListCubit get(context) => BlocProvider.of(context);


  /// get parts voice
  Future<void> getPlayList() async {
    PartsVoiceDataSourceImpl partsVoiceDataSourceImpl =
    const PartsVoiceDataSourceImpl();
    try {
      emit(LoadingPartsVoiceStatus());

      var serviceTeam = await partsVoiceDataSourceImpl.getPlayList();

      if (serviceTeam.data != null) {
        emit(SuccessPartsVoiceStatus(serviceTeam.data!));
      } else {
        emit(ErrorPartsVoiceStatus(serviceTeam.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorPartsVoiceStatus is : $e in $stack");
      emit(ErrorPartsVoiceStatus("Error is $e"));
    }
  }


  /// get parts voice
  Future<void> getDetailsPlayList({
    required int partsId,

}) async {
    PartsVoiceDataSourceImpl partsVoiceDataSourceImpl =
    const PartsVoiceDataSourceImpl();
    try {

        emit(LoadingVoicesListStatus());


      var serviceTeam = await partsVoiceDataSourceImpl.getDetailsPlayList(id: partsId);

      if (serviceTeam.data != null) {
        emit(SuccessVoicesListStatus(serviceTeam.data!));
      } else {
        emit(ErrorVoicesListStatus(serviceTeam.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorPartsVoiceStatus is : $e in $stack");
      emit(ErrorVoicesListStatus("Error is $e"));
    }
  }
}
