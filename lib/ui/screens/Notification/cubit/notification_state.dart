part of 'notification_cubit.dart';

class NotificationState {}

 class NotificationInitial extends NotificationState {}


/// Get All Notification State
class LoadingGetAllNotificationsState extends NotificationState {

}

class SuccessGetAllNotificationsState extends NotificationState {
  final NotificationsModel? notificationsModel;
  SuccessGetAllNotificationsState(this.notificationsModel);
}

class ErrorGetAllNotificationsState extends NotificationState {
  final String error;
  ErrorGetAllNotificationsState(this.error);
}

/// Delete All Notification State
class LoadingDeleteAllNotificationsState extends NotificationState {

}

class SuccessDeleteAllNotificationsState extends NotificationState {
  final GeneralResult? notificationsModel;
  SuccessDeleteAllNotificationsState(this.notificationsModel);
}

class ErrorDeleteAllNotificationsState extends NotificationState {
  final String error;
  ErrorDeleteAllNotificationsState(this.error);
}



/// Delete All Notification State
class LoadingDeleteOneNotificationsState extends NotificationState {

}

class SuccessDeleteOneNotificationsState extends NotificationState {
  final GeneralResult? notificationsModel;
  SuccessDeleteOneNotificationsState(this.notificationsModel);
}

class ErrorDeleteOneNotificationsState extends NotificationState {
  final String error;
  ErrorDeleteOneNotificationsState(this.error);
}


/// Read ads Notification State
class LoadingReadAdsNotificationsState extends NotificationState {

}

class SuccessReadAdsNotificationsState extends NotificationState {
  final GeneralResult? notificationsModel;
  SuccessReadAdsNotificationsState(this.notificationsModel);
}

class ErrorReadAdsNotificationsState extends NotificationState {
  final String error;
  ErrorReadAdsNotificationsState(this.error);
}