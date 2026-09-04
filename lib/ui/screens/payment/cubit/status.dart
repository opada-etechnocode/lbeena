
import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:syrians_in_uae/data/models/payment/payment_package_model.dart';

import '../../../../data/models/profile_company/package_company_model.dart';

abstract class PaymentStates  {}

class InitialPaymentState extends PaymentStates {
}



class LoadingPaymentPackageState extends PaymentStates {

}

class SuccessPaymentPackageState extends PaymentStates {
  final PaymentPackageModel? packageModel;
  SuccessPaymentPackageState(this.packageModel);
}
class ErrorPaymentPackageState extends PaymentStates {
final String? error;
ErrorPaymentPackageState(this.error);
}




class LoadingChangeStatusAdsFromUnPaidState extends PaymentStates {

}

class SuccessChangeStatusAdsFromUnPaidState extends PaymentStates {
  final GeneralModel? generalModel;
  SuccessChangeStatusAdsFromUnPaidState(this.generalModel);
}
class ErrorChangeStatusAdsFromUnPaidState extends PaymentStates {
  final String? error;
  ErrorChangeStatusAdsFromUnPaidState(this.error);
}

// class LoadingPayForAdsSpecialFeaturesState extends PaymentStates {
//
// }
//
// class SuccessPayForAdsSpecialFeaturesState extends PaymentStates {
//   final GeneralModel? packageModel;
//   SuccessPayForAdsSpecialFeaturesState(this.packageModel);
// }
// class ErrorPayForAdsSpecialFeaturesState extends PaymentStates {
//   final String? error;
//   ErrorPayForAdsSpecialFeaturesState(this.error);
// }



class LoadingPaymentAdsState extends PaymentStates {

}

class SuccessPaymentAdsState extends PaymentStates {
  final PaymentPackageModel? adsModel;
  SuccessPaymentAdsState(this.adsModel);
}class ErrorPaymentAdsState extends PaymentStates {
  final String? error;
  ErrorPaymentAdsState(this.error);
}


class LoadingPackageCompanyState extends PaymentStates {

}

class SuccessPackageCompanyState extends PaymentStates {
  final PackageCompanyModel? packageCompanyModel;
  SuccessPackageCompanyState(this.packageCompanyModel);
}

class ErrorPackageCompanyState extends PaymentStates {
  final String error;
  ErrorPackageCompanyState(this.error);
}