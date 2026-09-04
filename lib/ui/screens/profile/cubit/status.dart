

import 'package:syrians_in_uae/data/models/following/following_general_model.dart';
import 'package:syrians_in_uae/data/models/following/is_following_model.dart';
import 'package:syrians_in_uae/data/models/user/profile_user_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/auth/otp/check_monile_model.dart';
import '../../../../data/models/auth/otp/otp_model.dart';
import '../../../../data/models/community/community_post_model.dart';
import '../../../../data/models/community/community_user_model.dart';
import '../../../../data/models/profile_company/edit_info_company.dart';
import '../../../../data/models/profile_company/edit_profile_model.dart';
import '../../../../data/models/profile_company/information_company.dart';
import '../../../../data/models/profile_company/package_company_model.dart';
import '../../../../data/models/profile_company/profile_company_model.dart';
import '../../../../data/models/status_user.dart';

abstract class ProfileStates  {}

class InitialProfileState extends ProfileStates {
}

class LoadingEditProfileState extends ProfileStates {

}

class SuccessEditProfileState extends ProfileStates {
  final EditProfileModel? editProfileModel;
  SuccessEditProfileState(this.editProfileModel);
}

class ErrorEditProfileState extends ProfileStates {
  final String error;
  ErrorEditProfileState(this.error);
}


///Edit socialMediaCompanyList
class LoadingEditSocialMediaCompanyListState extends ProfileStates {

}

class SuccessEditSocialMediaCompanyListState extends ProfileStates {
  final CheckMobileExistsModel? data;
  SuccessEditSocialMediaCompanyListState(this.data);
}

class ErrorEditSocialMediaCompanyListState extends ProfileStates {
  final String error;
  ErrorEditSocialMediaCompanyListState(this.error);
}

///Get post user
class LoadingGetPostUserState extends ProfileStates {

}

 class SuccessGetPostUserState extends ProfileStates {
  final CommunityPostUserModel data;

  SuccessGetPostUserState(this.data);
}

 class ErrorGetPostUserState extends ProfileStates {
  final String message;

  ErrorGetPostUserState(this.message);
}

/// Get Status User
class LoadingGetStatusUserState extends ProfileStates {

}

class SuccessGetStatusUserState extends ProfileStates {
  final StatusUserResult statusUserResult;
  SuccessGetStatusUserState(this.statusUserResult);
}

class ErrorGetStatusUserState extends ProfileStates {
  final String error;
  ErrorGetStatusUserState(this.error);
}

///

class LoadingChangeAdsFromExpiredState extends ProfileStates {

}

class SuccessChangeAdsFromExpiredState extends ProfileStates {
  final GeneralModel? generalModel;
  SuccessChangeAdsFromExpiredState(this.generalModel);
}

class ErrorChangeAdsFromExpiredState extends ProfileStates {
  final String error;
  ErrorChangeAdsFromExpiredState(this.error);
}


class LoadingEditInformationCompanyState extends ProfileStates {

}

class SuccessEditInformationCompanyState extends ProfileStates {
  final EditInformationCompanyModel editInformationCompanyModel;
  SuccessEditInformationCompanyState(this.editInformationCompanyModel);
}

class ErrorEditInformationCompanyState extends ProfileStates {
  final String error;
  ErrorEditInformationCompanyState(this.error);
}




class LoadingCompanyInformationState extends ProfileStates {

}

class SuccessCompanyInformationState extends ProfileStates {
  final ProfileCompanyModel profileCompanyModel;
  SuccessCompanyInformationState(this.profileCompanyModel);
}

class ErrorCompanyInformationState extends ProfileStates {
  final String error;
  ErrorCompanyInformationState(this.error);
}

class LoadingCompanyDescriptionState extends ProfileStates {

}

class SuccessCompanyDescriptionState extends ProfileStates {
  final ProfileInformationCompanyModel profileInformationCompanyModel;
  SuccessCompanyDescriptionState(this.profileInformationCompanyModel);
}

class ErrorCompanyDescriptionState extends ProfileStates {
  final String error;
  ErrorCompanyDescriptionState(this.error);
}

class LoadingCompanyInformationAboutState extends ProfileStates {

}

class SuccessCompanyInformationAboutState extends ProfileStates {
  final ProfileInformationCompanyModel profileInformationCompanyModel;
  SuccessCompanyInformationAboutState(this.profileInformationCompanyModel);
}

class ErrorCompanyInformationAboutState extends ProfileStates {
  final String error;
  ErrorCompanyInformationAboutState(this.error);
}




class LoadingSendOTPState extends ProfileStates {

}

class SuccessSendOTPState extends ProfileStates {
  final GeneralModel otpModel;
  SuccessSendOTPState(this.otpModel);
}

class ErrorSendOTPState extends ProfileStates {
  final String error;
  ErrorSendOTPState(this.error);
}

class LoadingProfileUserState extends ProfileStates {

}

class SuccessProfileUserState extends ProfileStates {
  final ProfileUserModel profileUserModel;
  SuccessProfileUserState(this.profileUserModel);
}

class ErrorProfileUserState extends ProfileStates {
  final String error;
  ErrorProfileUserState(this.error);
}


class LoadingValidateMobileNumberState extends ProfileStates {

}

class SuccessValidateMobileNumberState extends ProfileStates {
  final GeneralModel otpModel;
  SuccessValidateMobileNumberState(this.otpModel);
}

class ErrorValidateMobileNumberState extends ProfileStates {
  final String error;
  ErrorValidateMobileNumberState(this.error);
}




class LoadingCheckMobileExistsState extends ProfileStates {

}

class SuccessCheckMobileExistsState extends ProfileStates {
  final CheckMobileExistsModel checkMobileExistsModel;
  SuccessCheckMobileExistsState(this.checkMobileExistsModel);
}

class ErrorCheckMobileExistsState extends ProfileStates {
  final String error;
  ErrorCheckMobileExistsState(this.error);
}


class LoadingDataFormatState extends ProfileStates {

}

class SuccessDataFormatState extends ProfileStates {
  final String createAt;
  final String joinAt;
  SuccessDataFormatState({required this.createAt,required this.joinAt});
}

class ErrorDataFormatState extends ProfileStates {
  final String error;
  ErrorDataFormatState(this.error);
}


class LoadingLoadFileState extends ProfileStates {

}

class SuccessLoadFileProfileState extends ProfileStates {
  final XFile? fileLicense;
  SuccessLoadFileProfileState(this.fileLicense);
}

class ErrorLoadFileState extends ProfileStates {

}

class UpToOneMegaLoadFileProfileState extends ProfileStates {

}


class LoadingPackageCompanyState extends ProfileStates {

}

class SuccessPackageCompanyState extends ProfileStates {
  final PackageCompanyModel? packageCompanyModel;
  SuccessPackageCompanyState(this.packageCompanyModel);
}

class ErrorPackageCompanyState extends ProfileStates {
final String error;
ErrorPackageCompanyState(this.error);
}

class LoadingEditImageProfileState extends ProfileStates {

}

class SuccessEditImageProfileState extends ProfileStates {
  final EditInformationCompanyModel? editInformationCompanyModel;
  SuccessEditImageProfileState(this.editInformationCompanyModel);
}

class ErrorEditImageProfileState extends ProfileStates {
  final String error;
  ErrorEditImageProfileState(this.error);
}



class LoadingEvaluateCompanyState extends ProfileStates {

}

class SuccessEvaluateCompanyState extends ProfileStates {
  final GeneralModel? generalModel;
  SuccessEvaluateCompanyState(this.generalModel);
}

class ErrorEvaluateCompanyState extends ProfileStates {
  final String error;
  ErrorEvaluateCompanyState(this.error);
}

/// Following
// i follow this user ?
class LoadingIsFollowingUserState extends ProfileStates {

}

class SuccessIsFollowingUserState extends ProfileStates {
  final IsFollowingModel? isFollowingModel;
  SuccessIsFollowingUserState(this.isFollowingModel);
}

class ErrorIsFollowingUserState extends ProfileStates {
  final String error;
  ErrorIsFollowingUserState(this.error);
}


// follow user
class LoadingFollowingUserState extends ProfileStates {

}

class SuccessFollowingUserState extends ProfileStates {
  final FollowingGeneralModel? followingGeneralModel;
  SuccessFollowingUserState(this.followingGeneralModel);
}

class ErrorFollowingUserState extends ProfileStates {
  final String error;
  ErrorFollowingUserState(this.error);
}

// un follow user
class LoadingUnFollowingUserState extends ProfileStates {

}

class SuccessUnFollowingUserState extends ProfileStates {
  final FollowingGeneralModel? isFollowingModel;
  SuccessUnFollowingUserState(this.isFollowingModel);
}

class ErrorUnFollowingUserState extends ProfileStates {
  final String error;
  ErrorUnFollowingUserState(this.error);
}
