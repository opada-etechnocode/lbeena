import '../../../../core/bloc/states/base_states.dart';

class BaseLoadingState extends GeneralState {
  final String? message;

  const BaseLoadingState({this.message});
}
