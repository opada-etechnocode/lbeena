
import '../../../../data/models/fortune_wheel/fortune_wheel_cutomer.dart';

abstract class FortuneWheelState {}

final class FortuneWheelInitial extends FortuneWheelState {}
final class FortuneWheelStateLoading extends FortuneWheelState {}
final class FortuneWheelStateSuccess extends FortuneWheelState {}
final class SpinWheelStateSuccess extends FortuneWheelState {}
final class FortuneWheelStateError extends FortuneWheelState {
  String error;
  FortuneWheelStateError(this.error);
}



final class FortuneWheelCustomerStateLoading extends FortuneWheelState {}
final class FortuneWheelCustomerStateSuccess extends FortuneWheelState {
  FortuneWheelCustomerModel fortuneWheelCustomerModel;
  FortuneWheelCustomerStateSuccess(this.fortuneWheelCustomerModel);
}
final class FortuneWheelCustomerStateError extends FortuneWheelState {
  String error;
  FortuneWheelCustomerStateError(this.error);
}
