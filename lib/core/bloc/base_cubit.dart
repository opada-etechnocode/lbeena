import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/states/base_init_state.dart';
import '../../../../core/bloc/states/base_states.dart';

abstract class BaseCubit extends Cubit<GeneralState> {
  BaseCubit({BaseInitState? initialState})
      : super(initialState ?? BaseInitState());
}
