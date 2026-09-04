

import 'package:syrians_in_uae/data/models/device_token_user_model.dart';
import 'package:syrians_in_uae/data/models/notifications/send_notifications_to_user.dart';

import '../../../../data/models/chats/ads_chats_model.dart';

abstract class ChatStateFirebase{}


class ChatFirebaseInitialState extends ChatStateFirebase{}

class ChatFirebaseLoadingState extends ChatStateFirebase{}
class GetAdsInfoErrorState extends ChatStateFirebase{}

class SendMessageSuccessState extends ChatStateFirebase {
  SendMessageSuccessState();
}


class ChatFirebaseLoadingUploadImageState extends ChatStateFirebase{}

class SendMessageSuccessUploadImageState extends ChatStateFirebase {
  String? imageUrl;
  SendMessageSuccessUploadImageState({this.imageUrl});
}


class SendMessageErrorUploadImageState extends ChatStateFirebase {
  String? error;
  SendMessageErrorUploadImageState({this.error});
}
class SendMessageErrorState extends ChatStateFirebase {
  SendMessageErrorState();
}


class LoadingDeviceTokenUserState extends ChatStateFirebase {


  LoadingDeviceTokenUserState();
}

class SuccessDeviceTokenUserState extends ChatStateFirebase {
  final DeviceTokenUserModel deviceTokenUserModel;
  SuccessDeviceTokenUserState(this.deviceTokenUserModel);
}
class ErrorDeviceTokenUserState extends ChatStateFirebase {

String error;
  ErrorDeviceTokenUserState(this.error);
}



class LoadingSendNotificationsState extends ChatStateFirebase {


  LoadingSendNotificationsState();
}


class ResultPlayingState extends ChatStateFirebase {


  ResultPlayingState();
}
class PlayingStateUpdated extends ChatStateFirebase {


  PlayingStateUpdated();
}

class SuccessSendNotificationsState extends ChatStateFirebase {
  final SendNotificationsForUserModel deviceTokenUserModel;
  SuccessSendNotificationsState(this.deviceTokenUserModel);
}
class ErrorSendNotificationsState extends ChatStateFirebase {

  ErrorSendNotificationsState();
}


class GetAllAdsChatsLoadingState extends ChatStateFirebase{}
class GetMessagesLoadingState extends ChatStateFirebase{}
class GetNotificationsLoadingState extends ChatStateFirebase{}
class GetNotificationsSuccessState extends ChatStateFirebase{}
class GetNotificationsHomePageSuccessState extends ChatStateFirebase{}

class GetAllAdsChatsSuccessState extends ChatStateFirebase {
  List<AdsChatsModel> adsChatsModel = [];
  GetAllAdsChatsSuccessState(this.adsChatsModel);
}
class GetAllAdsErrorState extends ChatStateFirebase {


  GetAllAdsErrorState();
}

class GetMessagesSuccessState extends ChatStateFirebase {
  GetMessagesSuccessState();
}

class GetMessagesErrorState extends ChatStateFirebase {
  GetMessagesErrorState();
}

class GetAdsInfoSuccessState extends ChatStateFirebase {
  GetAdsInfoSuccessState();
}


class GetAdsInfoReceiverSuccessState extends ChatStateFirebase {
  GetAdsInfoReceiverSuccessState();
}

class ChatStateFirebaseSuccess extends ChatStateFirebase {
  final String? messages;
  final int? conversations;
  ChatStateFirebaseSuccess(this.messages,this.conversations);
}
class DeleteMessagesLoadingState extends ChatStateFirebase {
  DeleteMessagesLoadingState();
}
class DeleteMessagesSuccessState extends ChatStateFirebase {
  DeleteMessagesSuccessState();
}
class DeleteMessagesErrorState extends ChatStateFirebase {
  final String? error;
  DeleteMessagesErrorState(this.error);
}

// Record
class ChatFirebaseLoadingUploadRecordState extends ChatStateFirebase {
  ChatFirebaseLoadingUploadRecordState();
}


class SendMessageSuccessUploadRecordState extends ChatStateFirebase {
  String? recorderUrl;
  SendMessageSuccessUploadRecordState({this.recorderUrl});
}


class SendMessageErrorUploadRecordState extends ChatStateFirebase {
  String? error;
  SendMessageErrorUploadRecordState({this.error});
}


// Notifications
class DeleteAllNotificationsSuccessState extends ChatStateFirebase {}
class DeleteOneNotificationSuccessState extends ChatStateFirebase {}
class ReadNotificationSuccessState extends ChatStateFirebase {}

class DeleteOneNotificationErrorState extends ChatStateFirebase {
  String? error;
  DeleteOneNotificationErrorState({this.error});
}


class ReadNotificationErrorState extends ChatStateFirebase {
  String? error;
  ReadNotificationErrorState({this.error});
}

class DeleteAllNotificationsErrorState extends ChatStateFirebase {
  String? error;
  DeleteAllNotificationsErrorState({this.error});
}