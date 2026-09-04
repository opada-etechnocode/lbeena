import '../../data/models/GeneralResult.dart';

abstract class AppGeneralState {}

final class AppGeneralInitial extends AppGeneralState {}


class LoadingDeletedDeviceTokenState extends AppGeneralState {

}
class SuccessDeletedDeviceTokenState extends AppGeneralState {
  final GeneralResult generalResult;
  SuccessDeletedDeviceTokenState(this.generalResult);
}
class ErrorDeletedDeviceTokenState extends AppGeneralState {

  ErrorDeletedDeviceTokenState();
}