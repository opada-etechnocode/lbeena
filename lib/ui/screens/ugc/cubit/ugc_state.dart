import '../../../../data/models/ugc/subscribe_ugc_model.dart';
import '../../../../data/models/ugc/ugc_category_model.dart';
import '../../../../data/models/ugc/ugc_users_model.dart';

class UgcState {}

class UgcInitial extends UgcState {}

///SubscribeToUgcModel
class LoadingSubscribeToUgcState extends UgcState {}

class SuccessSubscribeToUgcState extends UgcState {
  SubscribeToUgcModel? subscribeToUgcModel;

  SuccessSubscribeToUgcState(this.subscribeToUgcModel);
}

class ErrorSubscribeToUgcState extends UgcState {
  String error;

  ErrorSubscribeToUgcState(this.error);
}

///UgcCategoryModel
class LoadingUgcCategoryState extends UgcState {}

class SuccessUgcCategoryState extends UgcState {
  UgcCategoryModel ugcCategoryModel;

  SuccessUgcCategoryState(this.ugcCategoryModel);
}

class ErrorUgcCategoryState extends UgcState {
  String error;

  ErrorUgcCategoryState(this.error);
}


///UgcUsersModel
class LoadingUgcUsersState extends UgcState {}

class SuccessUgcUsersState extends UgcState {
  UgcUsersModel? ugcUsersModel;

  SuccessUgcUsersState(this.ugcUsersModel);
}

class ErrorUgcUsersState extends UgcState {
  String error;

  ErrorUgcUsersState(this.error);
}


///Search UgcUsersModel
class LoadingSearchUgcUsersState extends UgcState {}

class SuccessSearchUgcUsersState extends UgcState {
  UgcUsersModel? ugcUsersModel;

  SuccessSearchUgcUsersState(this.ugcUsersModel);
}

class ErrorSearchUgcUsersState extends UgcState {
  String error;

  ErrorSearchUgcUsersState(this.error);
}

