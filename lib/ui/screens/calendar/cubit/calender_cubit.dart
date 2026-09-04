import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/sources/calender/calnder_remote_data_source.dart';
import 'calender_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  CalenderCubit() : super(CalenderInitial());

  static CalenderCubit get(context) => BlocProvider.of(context);


  Future<void> getCalenderInfo() async {
    CalenderRemoteDataSourceImpl calenderRemoteDataSourceImpl = const CalenderRemoteDataSourceImpl();
    try {
      emit(GetCalenderInfoStateLoading());
      var data = await calenderRemoteDataSourceImpl.getCalenderInfo();
      if (data.data != null) {
        emit(GetCalenderInfoStateSuccess(data.data!));
      } else {
        emit(GetCalenderInfoStateError(data.data!.message??''));
      }
    } catch (e, stack) {
      print("Error In GetCalenderInfo is : $e in $stack");
      emit(GetCalenderInfoStateError(e.toString()));
    }
  }
}
