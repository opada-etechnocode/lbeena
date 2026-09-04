import 'dart:io';

import 'package:path/path.dart';
import 'package:syrians_in_uae/core/data_source/base_remote_data_source.dart';
import 'package:syrians_in_uae/core/net/http_method.dart';
import 'package:syrians_in_uae/data/models/add_ad_new/add_ad_model.dart';
import 'package:syrians_in_uae/data/models/check_company_whatsapp.dart';
import 'package:syrians_in_uae/data/models/device_token_user_model.dart';
import 'package:syrians_in_uae/data/models/government_with_services/government_with_services.dart';
import 'package:syrians_in_uae/data/models/home_page/categorie_part.dart';
import 'package:syrians_in_uae/data/models/home_page/details_banner_model.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:dio/dio.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/GeneralResult.dart';
import '../../models/add_ad_new/category_details_model.dart';
import '../../models/add_ad_new/category_model.dart';
import '../../models/add_ad_new/cities_model.dart';
import '../../models/aladhan_time_model/aladhan_time_model.dart';
import '../../models/auth/otp/otp_model.dart';
import '../../models/company/company_model.dart';
import '../../models/currency_rates/currency_rates_model.dart';
import '../../models/fortune_wheel/fortune_wheel_cutomer.dart';
import '../../models/home_page/app_terms_policy_model.dart';
import '../../models/home_page/categories_main.dart';
import '../../models/home_page/banner_product_model.dart';
import '../../models/home_page/edit_ads_model.dart';
import '../../models/home_page/edit_mobile_number_model.dart';
import '../../models/home_page/is_favorite_model.dart';
import '../../models/home_page/show_ads_model.dart';
import '../../models/home_page/statistics_model.dart';
import '../../models/home_page/status_recoder_model.dart';
import '../../models/payment/payment_price.dart';
import '../../models/radio_model/playNow_model.dart';
import '../../models/setting_model.dart';
import '../../models/status_user.dart';
import '../../models/support/team_service_model.dart';
import '../../models/theme/color_model.dart';

abstract class HomePageDataSource {
  const HomePageDataSource();

  Future<Result<HomePageModel>> getAllApiHomePage();
  Future<Result<GetSectionModel>> getSectionSetting();
  Future<Result<AladhanTimeModel>> getAladhanTime({
    required String latitude,
    required String longitude,
  });
  Future<Result<HomePageModel>> getRelatedAds({
    required int adsId,
    required int companyId,
    required int categoryId,
  });
  Future<Result<CurrencyRatesModel>> getCurrencyRates();
  Future<Result<DeviceTokenUserModel>> getDeviceTokenUser({
    required String userId,
  });

  Future<Result<PlayNowModel>> playNowRadio();

  Future<Result<StatusUserResult>> getStatusUser();

  Future<Result<WhatsappCompanyStatusModel>> getStatusWhatsappStatusCompanyUser(
      {required int userIdCompany});

  Future<Result<ShowAdsModel>> activeChatsForAds({required int adsId});

  Future<Result<CategoriesPartModel>> getCategoriesPart({
    required int id,
    required int page,
  });

  Future<Result<StatusRecorderModel>> getStatusRecorder();

  Future<Result<CategoriesDetailsModel>> getCategoriesPartNew({
    required int id,
    required int page,
  });

  Future<Result<SettingAppModel>> getSettingApp();

  Future<Result<CategoriesMainModel>> getCategoriesMain();

  Future<Result<GeneralModel>> deleteAccount();

  Future<Result<PricePaymentModel>> getPricePayment();

  Future<Result<GeneralResult>> deleteAds({
    required int adsId,
    required String type,
  });

  Future<Result<EditAdsModel>> editAdsInformation({
    required int adsId,
    // required String adsName,
    required String adsDescription,
    required String couponDateController,
    required String price,
    required String coupon,
    required String type,
    required String urlBannerInOut,
    required bool isBannerInOut,
  });

  Future<Result<EditMobileNumberModel>> editMobileWhatsappForAds({
    required int adsId,
    required String mobileWhatsapp,
  });

  Future<Result<GeneralResult>> addSpecialFeaturesForAds({
    required int adsId,
    required int idAdsSpecialFeature,
    required int isHave,
  });

  Future<Result<HomePageModel>> getAdsEvaluation();

  Future<Result<AppTermsPolicyLinksModel>> getPolicyTermsAppLinks();

  Future<Result<HomePageModel>> getAdsRandom();

  Future<Result<HasFavoritesModel>> adsIsFavorite({required int adsId});

  Future<Result<CompanyModel>> getCompaniesList(
      {required int page, required int order});

  Future<Result<ShowAdsModel>> showAds({
    required int adsId,
    required int userId,
  });

  Future<Result<ShowAdsModel>> favoriteAds({
    required int adsId,
  });

  Future<Result<GeneralModel>> evaluateAds({
    required int adsId,
    required double value,
  });

  Future<Result<DetailsProductModel>> getDetailsProduct({
    required int id,
  });

  Future<Result<DetailsBannerModel>> getDetailsBanner({
    required int id,
  });

  Future<Result<GovernmentWithServicesModel>> getGovernmentWithServices();

  Future<Result<GeneralResult>> sendCustomerServes({
    required String type,
    required String userName,
    required String mobileNumber,
    required String messageServes,
  });
  Future<Result<FortuneWheelCustomerModel>> getFortuneWheelCustomer();
  Future<Result<ChangeStatusCounterForWhatsappShareChatModel>>
      changeStatusCounterForWhatsappShareChat({
    required int idAds,
    required int type,
  });

  Future<Result<CategoriesDetailsModel>> filterCategoriesPartNew({
    required int idCategory,
    required int idSubCategory,
    required int idCity,
    required int page,
  });

  Future<Result<AllServicesTeamModel>> serviceModel();

  Future<Result<ClickStatisticsModel>> getClickStatistics({
    required int idAds,
  });

  Future<Result<HomePageModel>> getFavoriteAds();

  Future<Result<ColorAppModel>> getColorsApp();

  Future<Result<CompanyModel>> searchCompaniesList({
    required int page,
    required int order,
    int? businessActivitiesId,
    int? subcategory_id,
    String? search,
    String? city_name,
  });

  Future<Result<CategoriesAddPostModel>> getCategoryMainAndSubCategory();

  Future<Result<CitiesModel>> getCitiesApp();

  Future<Result<AddAdModel>> addAd({
    required String description,
    String? background_color,
    required List<String> categories,
    required String price,
    required int isAddCoupon,
    required String cityId,
    required String couponPercent,
    required String daysAddCoupon,
    required List<File>? image,
  });
}

class HomePageDataSourceImpl implements HomePageDataSource {
  const HomePageDataSourceImpl();

  @override
  Future<Result<ColorAppModel>> getColorsApp() async {
    return await RemoteDataSource.request<ColorAppModel>(
      converter: (model) => ColorAppModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/app_colors",
    );
  }

  @override
  Future<Result<FortuneWheelCustomerModel>> getFortuneWheelCustomer() async {
    return await RemoteDataSource.request<FortuneWheelCustomerModel>(
      converter: (model) => FortuneWheelCustomerModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}${AppEndpoints.getCustomerLuckUrl}',
    );
  }

  @override
  Future<Result<CurrencyRatesModel>> getCurrencyRates() async {
    return await RemoteDataSource.request<CurrencyRatesModel>(
      converter: (model) => CurrencyRatesModel.fromJson(model),
      method: HttpMethod.GET,
      url: 'https://v6.exchangerate-api.com/v6/f7401407d30f08dee4a9c958/latest/USD',
    );
  }
  @override
  Future<Result<AladhanTimeModel>> getAladhanTime({
    required String latitude,
    required String longitude,
  }) async {
    return await RemoteDataSource.request<AladhanTimeModel>(
      converter: (model) => AladhanTimeModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url:
          "https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=5",
    );
  }

  @override
  Future<Result<StatusRecorderModel>> getStatusRecorder() async {
    return await RemoteDataSource.request<StatusRecorderModel>(
      converter: (model) => StatusRecorderModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/user/get_video_status",
    );
  }

  @override
  Future<Result<PlayNowModel>> playNowRadio() async {
    return await RemoteDataSource.request<PlayNowModel>(
      converter: (model) => PlayNowModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        "Authorization":
            'Bearer 4ab16008e0a3a062:5e0ddb92a78e14348ffe2d62d78083c2',
        "accept": 'application/json',
      },
      url: "https://a8.asurahosting.com/api/nowplaying/420",
    );
  }

  @override
  Future<Result<CompanyModel>> getCompaniesList({
    required int page,
    required int order,
  }) async {
    return await RemoteDataSource.request<CompanyModel>(
        converter: (model) => CompanyModel.fromJson(model),
        method: HttpMethod.POST,
        data: {'order': order},
        queryParameters: {
          "page": page,
        },
        url: "${AppEndpoints.baseUrl}${AppEndpoints.listCompanyUrl}ar");
  }

  @override
  Future<Result<CompanyModel>> searchCompaniesList({
    required int page,
    required int order,
    int? businessActivitiesId,
    int? subcategory_id,
    String? search,
    String? city_name,
  }) async {
    return await RemoteDataSource.request<CompanyModel>(
      converter: (model) => CompanyModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        'order': order,
        'search': search,
        'business_activity_id': businessActivitiesId,
        'subcategory_id': subcategory_id,
        'city_name': city_name,
      },
      queryParameters: {
        "page": page,
      },
        url: "${AppEndpoints.baseUrl}${AppEndpoints.searchListCompanyUrl}ar"
    );
  }

  @override
  Future<Result<AllServicesTeamModel>> serviceModel() async {
    return await RemoteDataSource.request<AllServicesTeamModel>(
      converter: (model) => AllServicesTeamModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}${AppEndpoints.serviceUrl}",
    );
  }

  @override
  Future<Result<HomePageModel>> getRelatedAds({
    required int adsId,
    required int companyId,
    required int categoryId,
  }) async {
    return await RemoteDataSource.request<HomePageModel>(
      converter: (model) => HomePageModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {
        "ads_id": adsId,
        "company_id": companyId,
        "category_id": categoryId,
      },
      url: "${AppEndpoints.baseUrl}related_ads",
    );
  }

  @override
  Future<Result<ClickStatisticsModel>> getClickStatistics({
    required int idAds,
  }) async {
    return await RemoteDataSource.request<ClickStatisticsModel>(
      converter: (model) => ClickStatisticsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {
        "ads_id": idAds,
      },
      url: "${AppEndpoints.baseUrl}mobile/ads/click_counting_get",
    );
  }

  @override
  Future<Result<ChangeStatusCounterForWhatsappShareChatModel>>
      changeStatusCounterForWhatsappShareChat({
    required int idAds,
    required int type,
  }) async {
    return await RemoteDataSource.request<
        ChangeStatusCounterForWhatsappShareChatModel>(
      converter: (model) =>
          ChangeStatusCounterForWhatsappShareChatModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {
        "user_id": DIManager.findDep<SharedPrefs>().getUserID(),
        "ads_id": idAds,
        "type": type,
      },
      url: "${AppEndpoints.baseUrl}mobile/ads/click_counting",
    );
  }

  @override
  Future<Result<DeviceTokenUserModel>> getDeviceTokenUser({
    required String userId,
  }) async {
    return await RemoteDataSource.request<DeviceTokenUserModel>(
      converter: (model) => DeviceTokenUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {"user_id": userId},
      url: "${AppEndpoints.baseUrl}mobile/chat_user",
    );
  }

  @override
  Future<Result<WhatsappCompanyStatusModel>> getStatusWhatsappStatusCompanyUser(
      {required int userIdCompany}) async {
    return await RemoteDataSource.request<WhatsappCompanyStatusModel>(
      converter: (model) => WhatsappCompanyStatusModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {"user_id": userIdCompany},
      url: "${AppEndpoints.baseUrl}mobile/whatsapp_company_status",
    );
  }

  @override
  Future<Result<GeneralModel>> deleteAccount() async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/user/delete/ar",
    );
  }

  @override
  Future<Result<GeneralResult>> sendCustomerServes({
    required String type,
    required String userName,
    required String mobileNumber,
    required String messageServes,
  }) async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "type": type,
        "user_name": userName,
        "mobile": mobileNumber,
        "message": messageServes,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/user/support",
    );
  }

  @override
  Future<Result<HomePageModel>> getFavoriteAds() async {
    return await RemoteDataSource.request<HomePageModel>(
      converter: (model) => HomePageModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}get_favorites_by_id",
    );
  }

  @override
  Future<Result<PricePaymentModel>> getPricePayment() async {
    return await RemoteDataSource.request<PricePaymentModel>(
      converter: (model) => PricePaymentModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}ads/get_price",
    );
  }

  @override
  Future<Result<StatusUserResult>> getStatusUser() async {
    return await RemoteDataSource.request<StatusUserResult>(
      converter: (model) => StatusUserResult.fromJson(model),
      method: HttpMethod.POST,
      data: {
        'user_id': DIManager.findDep<SharedPrefs>().getUserID(),
      },
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/delete_company_status",
    );
  }

  @override
  Future<Result<CategoriesAddPostModel>> getCategoryMainAndSubCategory() async {
    return await RemoteDataSource.request<CategoriesAddPostModel>(
      converter: (model) => CategoriesAddPostModel.fromJson(model),
      method: HttpMethod.GET,
      // data: {
      //   'user_id': DIManager.findDep<SharedPrefs>().getUserID(),
      // },
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/category/ar",
    );
  }

  @override
  Future<Result<CitiesModel>> getCitiesApp() async {
    return await RemoteDataSource.request<CitiesModel>(
      converter: (model) => CitiesModel.fromJson(model),
      method: HttpMethod.GET,
      // data: {
      //   'user_id': DIManager.findDep<SharedPrefs>().getUserID(),
      // },
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/cities",
    );
  }

  @override
  Future<Result<AppTermsPolicyLinksModel>> getPolicyTermsAppLinks() async {
    return await RemoteDataSource.request<AppTermsPolicyLinksModel>(
      converter: (model) => AppTermsPolicyLinksModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/get_link",
    );
  }

  @override
  Future<Result<EditAdsModel>> editAdsInformation({
    required int adsId,
    // required String adsName,
    required String adsDescription,
    required String price,
    required String urlBannerInOut,
    required String couponDateController,
    required bool isBannerInOut,
    required String type,
    required String coupon,
  }) async {
    // String urlAds = 'edit_product';
    String urlAds = type == 'B' ? 'edit_product' : 'edit_banner';
    print(coupon);
    print((couponDateController == '' && coupon == ''));
    Map<String, dynamic>? data = type == 'B'
        ? {
            "ads_description": adsDescription,
            // "ads_name": adsName,
            "price": price,
            "coupon_percent": coupon,
            "days_add_coupon": couponDateController,
            "is_add_coupon":
                (couponDateController == '' && coupon == '') ? 0 : 1,
          }
        : {
            "name": adsDescription,
            // "description": adsName,
            "price": price,
            "coupon_percent": coupon,
            "days_add_coupon": couponDateController,
          };
    return await RemoteDataSource.request<EditAdsModel>(
      converter: (model) => EditAdsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: isBannerInOut ? {"url": urlBannerInOut} : data,
      url: "${AppEndpoints.baseUrl}mobile/user/$urlAds/ar/$adsId",
    );
  }

  @override
  Future<Result<GeneralResult>> deleteAds({
    required int adsId,
    required String type,
  }) async {
    String urlAds = type == 'B' ? 'delete_product' : 'delete_banner';
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.DELETE,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/user/$urlAds/ar/$adsId",
    );
  }

  @override
  Future<Result<EditMobileNumberModel>> editMobileWhatsappForAds({
    required int adsId,
    required String mobileWhatsapp,
  }) async {
    return await RemoteDataSource.request<EditMobileNumberModel>(
      converter: (model) => EditMobileNumberModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "mobile": mobileWhatsapp,
      },
      url:
          "${AppEndpoints.baseUrl}${AppEndpoints.editMobileWhatsappForAdsUrl}ar/$adsId",
    );
  }

  @override
  Future<Result<GeneralResult>> addSpecialFeaturesForAds({
    required int adsId,
    required int idAdsSpecialFeature,
    required int isHave,
  }) async {
    Map<String, dynamic>? data = isHave == 1
        ? {
            "ad_id": adsId,
            "id_ad_special_feature": idAdsSpecialFeature,
            "is_have": 1,
          }
        : {
            "ad_id": adsId,
            "is_have": 0,
          };
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: data,
      url: AppEndpoints.baseUrl + AppEndpoints.idAdsSpecialFeatureUrl + "ar",
    );
  }

  @override
  Future<Result<ShowAdsModel>> activeChatsForAds({required int adsId}) async {
    return await RemoteDataSource.request<ShowAdsModel>(
      converter: (model) => ShowAdsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "ad_id": adsId,
      },
      url: AppEndpoints.baseUrl + AppEndpoints.activeChatsInAdsUrl + "ar",
    );
  }

  @override
  Future<Result<HasFavoritesModel>> adsIsFavorite({required int adsId}) async {
    return await RemoteDataSource.request<HasFavoritesModel>(
      converter: (model) => HasFavoritesModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "ad_id": adsId,
      },
      url: AppEndpoints.baseUrl + AppEndpoints.isFavoriteAdsUrl + 'ar',
    );
  }

  @override
  Future<Result<GeneralModel>> evaluateAds({
    required int adsId,
    required double value,
  }) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "ad_id": adsId,
        "value": value,
      },
      url: AppEndpoints.baseUrl + AppEndpoints.evaluateAdsUrl,
    );
  }

  @override
  Future<Result<ShowAdsModel>> showAds({
    required int adsId,
    required int userId,
  }) async {
    return await RemoteDataSource.request<ShowAdsModel>(
      converter: (model) => ShowAdsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "ads_id": adsId,
        "user_id": userId,
      },
      url: AppEndpoints.baseUrl + AppEndpoints.showAdsUrl,
    );
  }

  @override
  Future<Result<ShowAdsModel>> favoriteAds({
    required int adsId,
  }) async {
    return await RemoteDataSource.request<ShowAdsModel>(
      converter: (model) => ShowAdsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "ad_id": adsId,
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.favoriteAdsUrl}ar",
    );
  }

  @override
  Future<Result<HomePageModel>> getAllApiHomePage() async {
    // FormData data = FormData.fromMap({
    //   "properties":formData,
    //   "category_id":categoryId
    // });
    // print('formdata: ${data.fields}');
    return await RemoteDataSource.request<HomePageModel>(
      converter: (model) => HomePageModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: AppEndpoints.baseUrl + AppEndpoints.homePageNewUrl + 'ar' + "?page=1",
    );
  }

  @override
  Future<Result<CategoriesPartModel>> getCategoriesPart({
    required int id,
    required int page,
  }) async {
    return await RemoteDataSource.request<CategoriesPartModel>(
      converter: (model) => CategoriesPartModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.category}/$id/ar?page=$page',
      // url: 'http://wadeema.com/api/mobile/categorie/2106/ar',
    );
  }

  @override
  Future<Result<CategoriesDetailsModel>> getCategoriesPartNew({
    required int id,
    required int page,
  }) async {
    return await RemoteDataSource.request<CategoriesDetailsModel>(
      converter: (model) => CategoriesDetailsModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url:
          '${AppEndpoints.baseUrl}${AppEndpoints.categoryNew}/ar/$id?page=$page',
    );
  }

  @override
  Future<Result<CategoriesDetailsModel>> filterCategoriesPartNew({
    required int idCategory,
    int? idSubCategory,
    int? idCity,
    required int page,
  }) async {
    return await RemoteDataSource.request<CategoriesDetailsModel>(
      converter: (model) => CategoriesDetailsModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "city_id": idCity,
        "category_id": idCategory,
        "subcategory_id": idSubCategory,
      },
      headers: {RemoteDataSource.requiresToken: false},
      url:
          '${AppEndpoints.baseUrl}${AppEndpoints.filterSubcategoryUrl}?page=$page',
    );
  }

  @override
  Future<Result<CategoriesMainModel>> getCategoriesMain() async {
    return await RemoteDataSource.request<CategoriesMainModel>(
      converter: (model) => CategoriesMainModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.categoryMainUrl}ar',
    );
  }

  @override
  Future<Result<HomePageModel>> getAdsEvaluation() async {
    return await RemoteDataSource.request<HomePageModel>(
      converter: (model) => HomePageModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.adsEvaluationUrl}ar?page=1',
    );
  }

  @override
  Future<Result<SettingAppModel>> getSettingApp() async {
    return await RemoteDataSource.request<SettingAppModel>(
      converter: (model) => SettingAppModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.getSettingApp}ar',
    );
  }

  @override
  Future<Result<HomePageModel>> getAdsRandom({int pageIndex = 1}) async {
    return await RemoteDataSource.request<HomePageModel>(
      converter: (model) => HomePageModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url:
          '${AppEndpoints.baseUrl}${AppEndpoints.adsRandomUrl}ar?page=$pageIndex',
    );
  }

  @override
  Future<Result<DetailsProductModel>> getDetailsProduct({
    required int id,
  }) async {
    return await RemoteDataSource.request<DetailsProductModel>(
      converter: (model) => DetailsProductModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.detailsProductUrl}ar/$id',
    );
  }

  @override
  Future<Result<GovernmentWithServicesModel>>
      getGovernmentWithServices() async {
    return await RemoteDataSource.request<GovernmentWithServicesModel>(
      converter: (model) => GovernmentWithServicesModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.governmentWithServicesUrl}',
    );
  }

  @override
  Future<Result<DetailsBannerModel>> getDetailsBanner({
    required int id,
  }) async {
    return await RemoteDataSource.request<DetailsBannerModel>(
      converter: (model) => DetailsBannerModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.detailsBannerUrl}ar/$id',
    );
  }

  @override
  Future<Result<GetSectionModel>> getSectionSetting() async {
    return await RemoteDataSource.request<GetSectionModel>(
      converter: (model) => GetSectionModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.getSectionUrl}ar',
    );
  }
  String getCategories({List<String>? category}) {
    String hash = '';
    for (int i = 0; i < category!.length; i++) {
      if (hash == '') {
        hash = category[i];
      } else {
        hash = hash + ',' + category[i];
      }
    }
    return hash;
  }

  /// Add ad
  @override
  Future<Result<AddAdModel>> addAd({
    required String description,
    String? background_color,
    required List<String> categories,
    required String price,
    required int isAddCoupon,
    required String cityId,
    required String couponPercent,
    required String daysAddCoupon,
    required List<File>? image,
  }) async {
    FormData formData;

    var imageProduct = [];

    var profilePicProduct;
    if (image != null && image.isNotEmpty) {
      for (int i = 0; i < image.length; i++) {
        profilePicProduct = await MultipartFile.fromFile(
          image[i].path,
          filename: basename(image[i].path),
        );
        imageProduct.add(profilePicProduct);
      }
    }

    print('is_add_coupon $isAddCoupon');
    print('coupon_percent $couponPercent');
    print('days_add_coupon $daysAddCoupon');
    Map<String, dynamic>? data = {
      "description": description,
      "background_color": background_color,
      "fa_image_one[]": imageProduct,
      "categories": getCategories(category: categories),
      "price": price,
      "city_id": cityId,
      "is_add_coupon": isAddCoupon,
      "coupon_percent": couponPercent,
      "days_add_coupon": daysAddCoupon,
    };
    formData = FormData.fromMap(data);
    return await RemoteDataSource.request<AddAdModel>(
      converter: (model) => AddAdModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      formData: formData,
      url: AppEndpoints.baseUrl + AppEndpoints.addAdUrl,
    );
  }
}
