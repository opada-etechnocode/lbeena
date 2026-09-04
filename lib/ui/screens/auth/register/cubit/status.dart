
import 'package:syrians_in_uae/data/models/company/activity_company_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../data/models/auth/login/login_model.dart';
import '../../../../../data/models/auth/otp/check_monile_model.dart';
import '../../../../../data/models/auth/otp/otp_model.dart';
import '../../../../../data/models/auth/register/register_company_model.dart';
import '../../../../../data/models/auth/register/register_model.dart';
import '../../../../../data/models/auth/transfer_user_to_company_model.dart';


abstract class RegisterStates  {}

class InitialOTPState extends RegisterStates {
}
class LoadingLoginState extends RegisterStates {

}

class SuccessLoginState extends RegisterStates {
  final LoginModel loginModel;
  SuccessLoginState(this.loginModel);
}

class ErrorLoginState extends RegisterStates {
  final String error;
  ErrorLoginState(this.error);
}



class LoadingCheckMobileExistsState extends RegisterStates {

}

class SuccessCheckMobileExistsState extends RegisterStates {
  final CheckMobileExistsModel checkMobileExistsModel;
  SuccessCheckMobileExistsState(this.checkMobileExistsModel);
}

class ErrorCheckMobileExistsState extends RegisterStates {
  final String error;
  ErrorCheckMobileExistsState(this.error);
}
class LoadingSendOTPState extends RegisterStates {

}

class SuccessSendOTPState extends RegisterStates {
  final GeneralModel otpModel;
  SuccessSendOTPState(this.otpModel);
}

class ErrorSendOTPState extends RegisterStates {
  final String error;
  ErrorSendOTPState(this.error);
}


///Activity Company

class LoadingActivityCompanyState extends RegisterStates {

}

class SuccessActivityCompanyState extends RegisterStates {
  final ActivityCompanyModel activityCompanyModel;
  SuccessActivityCompanyState(this.activityCompanyModel);
}

class ErrorActivityCompanyState extends RegisterStates {
  final String error;
  ErrorActivityCompanyState(this.error);
}


class LoadingValidateMobileNumberState extends RegisterStates {

}

class SuccessValidateMobileNumberState extends RegisterStates {
final GeneralModel otpModel;
  SuccessValidateMobileNumberState(this.otpModel);
}

class ErrorValidateMobileNumberState extends RegisterStates {
  final String error;
  ErrorValidateMobileNumberState(this.error);
}



class LoadingResetPasswordState extends RegisterStates {

}

class SuccessResetPasswordState extends RegisterStates {
  final GeneralModel otpModel;
  SuccessResetPasswordState(this.otpModel);
}

class ErrorResetPasswordState extends RegisterStates {
  final String error;
  ErrorResetPasswordState(this.error);
}



class LoadingRegisterUserState extends RegisterStates {

}

class SuccessRegisterUserState extends RegisterStates {
  final RegisterModel registerModel;
  SuccessRegisterUserState(this.registerModel);
}

class ErrorRegisterUserState extends RegisterStates {
  final String error;
  ErrorRegisterUserState(this.error);
}


class LoadingRegisterCompanyState extends RegisterStates {

}

class SuccessRegisterCompanyState extends RegisterStates {
  final RegisterCompanyModel registerCompanyModel;
  SuccessRegisterCompanyState(this.registerCompanyModel);
}

class SuccessTransferUserToCompanyState extends RegisterStates {
  final TransferUserToCompanyModel registerCompanyModel;
  SuccessTransferUserToCompanyState(this.registerCompanyModel);
}

class ErrorRegisterCompanyState extends RegisterStates {
  final String error;
  ErrorRegisterCompanyState(this.error);
}



class LoadingLoadFileState extends RegisterStates {

}

class SuccessLoadFileState extends RegisterStates {
  final XFile? fileLicense;
  SuccessLoadFileState(this.fileLicense);
}

class ErrorLoadFileState extends RegisterStates {

}

class UpToOneMegaLoadFileState extends RegisterStates {

}