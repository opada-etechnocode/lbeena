import '../../../../data/models/calender/calender_model.dart';

abstract class CalenderState {}

final class CalenderInitial extends CalenderState {}

final class GetCalenderInfoStateLoading extends CalenderState {}
final class GetCalenderInfoStateSuccess extends CalenderState {
  CalenderModel calenderModel;
  GetCalenderInfoStateSuccess(this.calenderModel);
}
final class GetCalenderInfoStateError extends CalenderState {
  String error;
  GetCalenderInfoStateError(this.error);
}
