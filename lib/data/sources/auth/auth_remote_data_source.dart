import 'package:syrians_in_uae/data/models/auth/login/login_model.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/GeneralResult.dart';
import '../../models/auth/otp/otp_model.dart';
import '../../models/auth/register/register_company_from_data.dartregister_from_data.dart';
import '../../models/auth/register/register_company_model.dart';
import '../../models/auth/register/register_from_data.dart';
import '../../models/auth/register/register_model.dart';
import '../../models/auth/transfer_user_to_company_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/company/activity_company_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<Result<GeneralResult>> logout()async {
    String? deviceToken = DIManager.findDep<SharedPrefs>().getDeviceToken() ;
    String? deviceType = DIManager.findDep<SharedPrefs>().getDeviceType();
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "device_token": deviceToken,
        "device_type": deviceType
      },
      url: AppEndpoints.baseUrl + AppEndpoints.logoutUrl + "/ar",
    );
  }
  @override
  Future<Result<LoginModel>> login(
    String phone,
    String password,
  ) async {
    String? deviceToken = DIManager.findDep<SharedPrefs>().getDeviceToken() ;
    String? deviceType = DIManager.findDep<SharedPrefs>().getDeviceType();

    return await RemoteDataSource.request<LoginModel>(
      converter: (model) => LoginModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {
        "mobile": phone,
        "password": password,
        "device_token": deviceToken,
        "device_type": deviceType
      },
      url: AppEndpoints.baseUrl + AppEndpoints.loginUrl + "/ar",
    );
  }

  //activityCompanyUrl

  @override
  Future<Result<ActivityCompanyModel>> getActivityCompany(
      ) async {

    return await RemoteDataSource.request<ActivityCompanyModel>(
      converter: (model) => ActivityCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.activityCompanyUrl}/ar',

    );
  }
  @override
  Future<Result<RegisterModel>> registerUser(
      {required RegisterFromData registerFromData,
      }) async {
    FormData formData;
    String? deviceToken = DIManager.findDep<SharedPrefs>().getDeviceToken();
    String? deviceType = DIManager.findDep<SharedPrefs>().getDeviceType();

    // var profilePic;
    // if (image != null) {
    //   profilePic = await MultipartFile.fromFile(
    //     image.path ?? "",
    //     filename: basename(image.path ?? ""),
    //   );
    // }
    formData = FormData.fromMap({
      "user_name": registerFromData.userName,
      "password": registerFromData.password,
      "confirm_password": registerFromData.passwordConfirm,
      "mobile": '971${registerFromData.mobile}',
      "account_type": 'individual',
      "device_token": deviceToken,
      "device_type": deviceType,

    });
    return await RemoteDataSource.request<RegisterModel>(
      converter: (model) => RegisterModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      formData: formData,
      url: '${AppEndpoints.baseUrl}${AppEndpoints.signupUrl}/ar',
    );
  }



  @override
  Future<Result<RegisterCompanyModel>> registerCompany(
      {required RegisterFromDataCompany registerFromDataCompany,
      }) async {
    FormData formData;

    var profilePic;
    if (registerFromDataCompany.commercialLicense != null) {
      profilePic = await MultipartFile.fromFile(
        registerFromDataCompany.commercialLicense!.path ?? "",
        filename: basename(registerFromDataCompany.commercialLicense!.path ??''),
      );

    }

    print(    "business_activity_id ${registerFromDataCompany.business_activity_id}");
    print(    "subcategory_id ${registerFromDataCompany.subActivityCompanyId}");
    formData = FormData.fromMap({
      "company_name": registerFromDataCompany.companyName,
      "person_name": registerFromDataCompany.personName,
      "commercial_license": profilePic,
      "license_number": registerFromDataCompany.licenseNumber,
      "country": registerFromDataCompany.country,
      // "company_activity": registerFromDataCompany.companyActivity,
      "expiry_date": registerFromDataCompany.expiryDate,
      "password": registerFromDataCompany.password,
      "mobile": '${registerFromDataCompany.mobile}',
      "description": '${registerFromDataCompany.companyDescription}',
      "business_activity_id": '${registerFromDataCompany.business_activity_id}',
      "subcategory_id": '${registerFromDataCompany.subActivityCompanyId}',
      "account_type": 'company',

    });
    return await RemoteDataSource.request<RegisterCompanyModel>(
      converter: (model) => RegisterCompanyModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      formData: formData,
      url: '${AppEndpoints.baseUrl}${AppEndpoints.signupCompanyUrl}/ar',
    );
  }

  @override
  Future<Result<TransferUserToCompanyModel>> transferUserToCompany(
      {required RegisterFromDataCompany registerFromDataCompany,
      }) async {
    FormData formData;

    var profilePic;
    if (registerFromDataCompany.commercialLicense != null) {
      profilePic = await MultipartFile.fromFile(
        registerFromDataCompany.commercialLicense!.path ?? "",
        filename: basename(registerFromDataCompany.commercialLicense!.path ??''),
      );

    }
    formData = FormData.fromMap({
      "company_name": registerFromDataCompany.companyName,
      "person_name": registerFromDataCompany.personName,
      "commercial_license": profilePic,
      "license_number": registerFromDataCompany.licenseNumber,
      "country": registerFromDataCompany.country,
      // "company_activity": registerFromDataCompany.companyActivity,
      "expiry_date": registerFromDataCompany.expiryDate,
      "password": registerFromDataCompany.password,
      "mobile": '${registerFromDataCompany.mobile}',
      "description": '${registerFromDataCompany.companyDescription}',
      "account_type": 'company',

    });
    return await RemoteDataSource.request<TransferUserToCompanyModel>(
      converter: (model) => TransferUserToCompanyModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      formData: formData,
      url: '${AppEndpoints.baseUrl}${AppEndpoints.transferUserToCompanyUrl}/ar',
    );
  }


// Future<Result<EmptyModel>> refreshToken(params) async {
//   return await RemoteDataSource.request<EmptyModel>(
//     converter: (model) => EmptyModel(model),
//     method: HttpMethod.POST,
//     headers: {RemoteDataSource.requiresToken: false},
//     url: AppEndpoints.REFRESH_TOKEN,
//     data: params,
//   );
// }
//
//   Future<Result<EmptyModel>> logout() async {
//     return await RemoteDataSource.request<EmptyModel>(
//       converter: (model) => EmptyModel(model),
//       method: HttpMethod.POST,
//       url: AppEndpoints.baseUrl + AppEndpoints.logoutUrl,
//       headers: {RemoteDataSource.requiresToken: true},
//     );
//   }
//
  @override
  Future<Result> resetPassword(String mobile, String password,String confirmPassword) async {

    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      // headers: {
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      // },
      data: {
        "mobile": '971$mobile',
        "password": password,
        "confirm_password": DIManager.findDep<SharedPrefs>().getPasswordToken()
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.resetPassword}/ar',
    );
  }
//
//   @override
//   Future<Result> otpForgetPassword(String mobile) async {
//     return await RemoteDataSource.request<OtpModel>(
//       converter: (model) => OtpModel.fromJson(model),
//       method: HttpMethod.POST,
//       data: {"mobile": mobile},
//       url: AppEndpoints.baseUrl + AppEndpoints.verifyPassword,
//       headers: {RemoteDataSource.requiresToken: false},
//     );
//   }
//
  @override
  Future<Result> sendVerificationCode(String mobile) async {
    return await RemoteDataSource.request<GeneralModel>(
      method: HttpMethod.POST,
      converter: (model) => GeneralModel.fromJson(model),
      data: {"mobile": mobile,
        "country_code" : "971",},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.sendVerificationCode}/ar',
      headers: {RemoteDataSource.requiresToken: false},
    );
  }

  @override
  Future<Result> validateMobileNumber(String otpCode, String mobile) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "mobile": "971$mobile",
        // "mobile": mobile,
        "otp_code": otpCode,
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.validateMobileNumber}/ar',
      // url: 'http://wadeema.com/api/mobile/auth/validateMobileNumber/ar',
      headers: {RemoteDataSource.requiresToken: false},
    );
  }

}

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<Result<LoginModel>>  login(
    String phone,
    String password,
  );
//
  Future<Result<RegisterModel>> registerUser(
      {required RegisterFromData registerFromData,
      // File? image,
   });

  Future<Result<RegisterCompanyModel>> registerCompany(
      {required RegisterFromDataCompany registerFromDataCompany,
        // File? image,
      });

  Future<Result<GeneralResult>> logout();

  Future<Result<TransferUserToCompanyModel>> transferUserToCompany(
      {required RegisterFromDataCompany registerFromDataCompany,
        // File? image,
      });
  Future<Result> resetPassword(String mobile, String password,String confirm_password);
  Future<Result> sendVerificationCode(String mobile);

  Future<Result<dynamic>> validateMobileNumber(String otpCode, String mobile);
  Future<Result<ActivityCompanyModel>> getActivityCompany();
}
