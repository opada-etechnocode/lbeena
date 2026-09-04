import '../../../../data/models/aladhan_time_model/aladhan_time_model.dart';

abstract class AladhanTimeState {}
 class AladhanTimeInitial extends AladhanTimeState {}


class LoadingAladhanTimeState extends AladhanTimeState {

}
  class SuccessAladhanTimeState extends AladhanTimeState {
  final AladhanTimeModel aladhanTimeModel;
  SuccessAladhanTimeState(this.aladhanTimeModel);
}
class ErrorAladhanTimeState extends AladhanTimeState {

  ErrorAladhanTimeState();
}

