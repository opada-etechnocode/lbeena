import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/sources/events/events_remote_data_source.dart';
import 'events_state.dart';


class EventsCubit extends Cubit<EventsState> {
  EventsCubit() : super(EventsInitial());

  static EventsCubit get(context) => BlocProvider.of(context);

  Future<void> getSocialMediaEffectiveness() async {
    EventsRemoteDataSourceImpl eventsRemoteDataSourceImpl = const EventsRemoteDataSourceImpl();
    try {
      emit(SocialMediaEffectivenessStateLoading());
      var data = await eventsRemoteDataSourceImpl.getSocialMediaEffectiveness();
      if (data.data != null) {

        emit(SocialMediaEffectivenessStateSuccess(data.data!));
      } else {
        emit(SocialMediaEffectivenessStateError(data.data!.message??''));
      }
    } catch (e, stack) {
      print("Error In SocialMediaEffectiveness is : $e in $stack");
      emit(SocialMediaEffectivenessStateError(e.toString()));
    }
  }

  Future<void> getEffectiveness({
    required int page,
    bool isLoading =true
}) async {
    EventsRemoteDataSourceImpl eventsRemoteDataSourceImpl = const EventsRemoteDataSourceImpl();
    try {
      if(isLoading){
        emit(EffectivenessStateLoading());
      }
      var data = await eventsRemoteDataSourceImpl.getEffectiveness(page: page);
      if (data.data != null) {

        emit(EffectivenessStateSuccess(data.data!));
      } else {
        emit(EffectivenessStateError(data.data!.message??''));
      }
    } catch (e, stack) {
      print("Error In Effectiveness is : $e in $stack");
      emit(EffectivenessStateError(e.toString()));
    }
  }
}
