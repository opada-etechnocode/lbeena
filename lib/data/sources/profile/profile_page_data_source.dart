import 'dart:io';

import 'package:syrians_in_uae/data/models/auth/login/login_model.dart';
import 'package:syrians_in_uae/data/models/profile_company/edit_info_company.dart';
import 'package:syrians_in_uae/data/models/profile_company/information_company.dart';
import 'package:syrians_in_uae/data/models/profile_company/package_company_model.dart';
import 'package:syrians_in_uae/data/models/profile_company/profile_company_model.dart';
import 'package:syrians_in_uae/data/models/user/profile_user_model.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/auth/otp/check_monile_model.dart';

import '../../models/auth/otp/otp_model.dart';
import '../../models/profile_company/edit_profile_model.dart';
import '../../../core/utils/endpoints.dart';




abstract class ProfilePageDataSource {
  const ProfilePageDataSource();
  Future<Result<EditProfileModel>> getEditProfileData();
  Future<Result<CheckMobileExistsModel>> checkMobileExists();
  Future<Result<ProfileCompanyModel>> companyInformation();
  Future<Result<GeneralModel>> evaluateCompany({
    required int companyId,
    required double value,
  });
  Future<Result<ProfileInformationCompanyModel>> getProfileInformationCompany();
  Future<Result<ProfileUserModel>> getProfileUser();
  Future<Result<ProfileInformationCompanyModel>> getDescriptionCompany({
    required int? idCompany,
});
  Future<Result<PackageCompanyModel>> getPackageCompany();

  Future<Result<PackageCompanyModel>> getAllPackageCompany();
  Future<Result<EditInformationCompanyModel>> editInformationCompany({
  String? companyName,
  String? personName,
  String? licenseName,
  String? country,
    int? subcategory_id,
  int? companyActivity,
  String? companyDescription,
  String? expiryDate,
  File? commercialLicense,
}) ;
  Future<Result<EditInformationCompanyModel>> editImageProfile({
    required File? image,
  });
  Future<Result<ProfileCompanyModel>> getInfoMyCompany({
    required int idCompany,
});
  Future<Result<ProfileCompanyModel>> companyInformationForAdvertisersAdmin();
  Future<Result<GeneralModel>> changeAdsFromExpired();

  Future<Result<CheckMobileExistsModel>> socialMediaCompanyList( {
    required List<String> socialMediaCompanyList,
  });
}


class ProfilePageDataSourceImpl implements ProfilePageDataSource {
  const ProfilePageDataSourceImpl();



  @override
  Future<Result<GeneralModel>> changeAdsFromExpired() async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}ads/change-ads-expired-payment' ,);
  }
  @override
  Future<Result<ProfileUserModel>> getProfileUser() async {
    return await RemoteDataSource.request<ProfileUserModel>(
      converter: (model) => ProfileUserModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}mobile/user/profile/ar' ,
    );
  }

  @override
  Future<Result<GeneralModel>> evaluateCompany({
    required int companyId,
    required double value,
  }) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "user_id":companyId,
        "value":value,
      },
      url: AppEndpoints.baseUrl + AppEndpoints.evaluateCompanyUrl,
    );
  }


  @override
  Future<Result<ProfileInformationCompanyModel>> getDescriptionCompany({
    required int? idCompany,
  }) async {
    return await RemoteDataSource.request<ProfileInformationCompanyModel>(
      converter: (model) => ProfileInformationCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      // url: '${AppEndpoints.baseUrl}${AppEndpoints.companyDescription}ar/$idCompany' ,
      url: '${AppEndpoints.baseUrl}description_company/ar/$idCompany' ,
    );
  }


  @override
  Future<Result<PackageCompanyModel>> getPackageCompany() async {
    return await RemoteDataSource.request<PackageCompanyModel>(
      converter: (model) => PackageCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.packageCompany}' ,
    );
  }
  @override
  Future<Result<PackageCompanyModel>> getAllPackageCompany() async {
    return await RemoteDataSource.request<PackageCompanyModel>(
      converter: (model) => PackageCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}all_package' ,
    );
  }

  @override
  Future<Result<EditInformationCompanyModel>> editImageProfile({
    required File? image,
}) async {
    FormData formData;
    var profilePic;
    if (image != null) {
      profilePic = await MultipartFile.fromFile(
        image.path ?? "",
        filename: basename(image.path ??''),
      );}
    Map<String, dynamic>? data =  {
      "profile_pic":profilePic,

    };

    formData = FormData.fromMap(data);
    return await RemoteDataSource.request<EditInformationCompanyModel>(
      converter: (model) => EditInformationCompanyModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      formData:formData ,
      url: '${AppEndpoints.baseUrl}${AppEndpoints.editProfileImages}ar' ,
    );
  }
  @override
  Future<Result<EditInformationCompanyModel>> editInformationCompany({
    String? companyName,
    String? personName,
    String? licenseName,
    String? country,
    int? subcategory_id,
    int? companyActivity,
    String? companyDescription,
    String? expiryDate,
    File? commercialLicense,
}) async {
    FormData formData;

    var profilePic;
    if (commercialLicense != null) {
      profilePic = await MultipartFile.fromFile(
        commercialLicense.path ?? "",
        filename: basename(commercialLicense.path ??''),
      );

    }
    print('subcategory_id: $subcategory_id');
    Map<String, dynamic>? data = profilePic ==null?  {
      "company_name":companyName,
      "person_name":personName,
      "license_number":licenseName,
      "country":country,
      "expiry_date":expiryDate,
      "description":companyDescription,
      "business_activity_id":companyActivity,
      "subcategory_id":subcategory_id,

    }:  {
      "company_name":companyName,
      "person_name":personName,
      "license_number":licenseName,
      "country":country, "description":companyDescription,
      "expiry_date":expiryDate,
      "commercial_license":profilePic,
      "business_activity_id":companyActivity,
      "subcategory_id":subcategory_id,
    };

    formData = FormData.fromMap(data);
    return await RemoteDataSource.request<EditInformationCompanyModel>(
      converter: (model) => EditInformationCompanyModel.fromJson(model),
      method: HttpMethod.POST,

      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      formData: formData,

      url: '${AppEndpoints.baseUrl}${AppEndpoints.editCompanyInformation}' ,
    );
  }

  @override
  Future<Result<EditProfileModel>> getEditProfileData( {
    String? userName,
    String? mobileNumber,
    String? desc_user,
    File? imageProfile,

}) async {
    // FormData data = FormData.fromMap({
    //   "properties":formData,
    //   "category_id":categoryId
    // });
    // print('formdata: ${data.fields}');
    return await RemoteDataSource.request<EditProfileModel>(
      converter: (model) => EditProfileModel.fromJson(model),
      method: HttpMethod.POST,
      // formData: data,
      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: userName ==null? {
        "desc_user": desc_user,
        "mobile": '971$mobileNumber',
      }: mobileNumber ==null?{
        "user_name": userName,
        "desc_user": desc_user,
      }: desc_user ==null?{
        "user_name": userName,
        "mobile": '971$mobileNumber',
      }:{
        "user_name": userName,
        "desc_user": desc_user,
        "mobile": '971$mobileNumber',
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.editProfile}ar' ,
    );
  }

  @override
  Future<Result<CheckMobileExistsModel>> checkMobileExists( {
    String? mobileNumber,
  }) async {
    return await RemoteDataSource.request<CheckMobileExistsModel>(
      converter: (model) => CheckMobileExistsModel.fromJson(model),
      method: HttpMethod.POST,

      data: {
        "mobile": '971$mobileNumber',
      },
      url: '${AppEndpoints.baseUrl}check_mobile_exists' ,
    );
  }



  @override
  Future<Result<CheckMobileExistsModel>> socialMediaCompanyList({
    required List<String> socialMediaCompanyList,
  }) async {
    final formattedLinks = socialMediaCompanyList
        .map((url) => {"url": url})
        .toList();

    return await RemoteDataSource.request<CheckMobileExistsModel>(
      converter: (model) => CheckMobileExistsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}',
      },
      data: {
        "links": formattedLinks,
      },
      url: '${AppEndpoints.baseUrl}mobile/user/store_social_user',
    );
  }


  @override
  Future<Result<ProfileCompanyModel>> companyInformation() async {
    return await RemoteDataSource.request<ProfileCompanyModel>(
      converter: (model) => ProfileCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        // 'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.companyInformation}ar' ,
    );
  }



  @override
  Future<Result<ProfileCompanyModel>> getInfoMyCompany({
    required int idCompany,
  }) async {
    return await RemoteDataSource.request<ProfileCompanyModel>(
      converter: (model) => ProfileCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        // 'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.infoMyCompany}ar/$idCompany' ,
    );
  }

  @override
  Future<Result<ProfileCompanyModel>> companyInformationForAdvertisersAdmin() async {
    return await RemoteDataSource.request<ProfileCompanyModel>(
      converter: (model) => ProfileCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        // 'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.companyInformationForAdvertisersAdmin}ar' ,
    );
  }

  @override
  Future<Result<ProfileInformationCompanyModel>> getProfileInformationCompany() async {
    return await RemoteDataSource.request<ProfileInformationCompanyModel>(
      converter: (model) => ProfileInformationCompanyModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        // 'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.companyInformationAbout}ar' ,
    );
  }


}