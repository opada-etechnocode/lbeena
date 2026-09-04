import 'package:syrians_in_uae/core/data_source/base_remote_data_source.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/net/http_method.dart';
import 'package:syrians_in_uae/data/models/add_ads/add_ads_model.dart';
import 'package:syrians_in_uae/data/models/add_ads/ads_special_features_model.dart';
import 'package:syrians_in_uae/data/models/add_ads/upload_product_form_data_model.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/add_ads/categories_ads.dart';
import '../../models/add_ads/price_ads_model.dart';
import '../../models/add_ads/upload_banner_form_data_model.dart';
import '../../models/check_company_whatsapp.dart';

abstract class AddAdsDataSource {
  const AddAdsDataSource();


  Future<Result<CategoriesAddAdsModel>> getCategoriesMain();
  Future<Result<WhatsappCompanyStatusModel>> getStatusWhatsappStatusCompanyUser();

  Future<Result<AdsSpecialFeaturesModel>> getAdsSpecialFeatures();
  Future<Result<AddAdsModel>> addAds();
  Future<Result<PriceAdsModel>> getPriceAdsAndBanner({required int categoryId});

}

class AddAdsDataSourceImpl implements AddAdsDataSource {
  const AddAdsDataSourceImpl();


  @override
  Future<Result<PriceAdsModel>> getPriceAdsAndBanner({required int categoryId})async {
    return await RemoteDataSource.request<PriceAdsModel>(
      converter: (model) => PriceAdsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
      // 'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
    },
      data: {
        "category_id": categoryId,
      },
      url: "${AppEndpoints.baseUrl}ads/price-ads-by-category",
    );
  }
  @override
  Future<Result<WhatsappCompanyStatusModel>> getStatusWhatsappStatusCompanyUser()async {
    return await RemoteDataSource.request<WhatsappCompanyStatusModel>(
      converter: (model) => WhatsappCompanyStatusModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {RemoteDataSource.requiresToken: false},
      data: {
        "user_id":DIManager.findDep<SharedPrefs>().getUserID()
      },
      url: "${AppEndpoints.baseUrl}mobile/whatsapp_company_status",
    );
  }

  @override
  Future<Result<CategoriesAddAdsModel>> getCategoriesMain() async {
    return await RemoteDataSource.request<CategoriesAddAdsModel>(
      converter: (model) => CategoriesAddAdsModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.categoryMainForAddAdsUrl}ar',
    );
  }



  @override
  Future<Result<AdsSpecialFeaturesModel>> getAdsSpecialFeatures() async {
    // print('${AppEndpoints.baseUrl}${AppEndpoints.adsSpecialFeaturesUrl}ar');
    return await RemoteDataSource.request<AdsSpecialFeaturesModel>(
      converter: (model) => AdsSpecialFeaturesModel.fromJson(model),
      method: HttpMethod.GET,
      // formData: data,
      headers: {RemoteDataSource.requiresToken: false},
      url: '${AppEndpoints.baseUrl}${AppEndpoints.adsSpecialFeaturesUrl}ar',
    );
  }




  @override
  Future<Result<AddAdsModel>> addAds({
    AddBannerFromDataCompany? addBannerFromDataCompany,
    AddProductFromDataCompany? addProductFromDataCompany,
}) async {
    FormData formData;

    var profilePicBanner;
    var profilePicProduct;
    if (addBannerFromDataCompany?.image != null) {
      profilePicBanner = await MultipartFile.fromFile(
        addBannerFromDataCompany?.image!.path ?? "",
        filename: basename(addBannerFromDataCompany?.image!.path ??''),
      );

    }

    var imageProduct =[];
    if (addProductFromDataCompany?.image != null && addProductFromDataCompany!.image!.isNotEmpty) {
      for(int i = 0;i<addProductFromDataCompany!.image!.length;i++){
         profilePicProduct = await MultipartFile.fromFile(
           addProductFromDataCompany.image![i].path ?? "",
          filename: basename(addProductFromDataCompany.image![i].path ??''),
        );
         imageProduct.add(profilePicProduct);
      }

    }
// print(addProductFromDataCompany?.image);
// print(addProductFromDataCompany?.image);
// print(profilePicProduct);
// print(profilePicProduct);
// print(profilePicProduct);
// print(profilePicProduct);
// print('DIManager.findDep<SharedPrefs>().getUserID() ${DIManager.findDep<SharedPrefs>().getUserID()}');
    print('addBannerFromDataCompany.couponDateNumber ${addBannerFromDataCompany?.couponDateNumber}');
    Map<String, dynamic>? data = addBannerFromDataCompany != null ? {
      "active_chat":addBannerFromDataCompany.activeChat.toString(),
      "image":profilePicBanner,
      // "category_id":addBannerFromDataCompany.categoryId,
      "category_id":addBannerFromDataCompany.categoryId.toString(),
      "coupon_percent":addBannerFromDataCompany.couponPercent.toString(),
      "type":"A",
      "in_out":addBannerFromDataCompany.inOut.toString(),
      "is_have":addBannerFromDataCompany.isHave.toString(),
      "id_ad_special_feature":addBannerFromDataCompany.idAdSpecialFeature.toString(),
      "mobile":addBannerFromDataCompany.mobile.toString(),
      "is_add_coupon":addBannerFromDataCompany.isAddCoupon.toString(),
      "name":addBannerFromDataCompany.nameBanner.toString(),
      "description":addBannerFromDataCompany.description.toString(),
      "user_id":DIManager.findDep<SharedPrefs>().getUserID(),
      // "user_id":'812',
      "account_type":"company",
      "days_add_coupon":addBannerFromDataCompany.couponDateNumber,
      "language_id":"1",
      "url":addBannerFromDataCompany.url.toString(),
      "price":addBannerFromDataCompany.price.toString(),

    } :{
      "active_chat":addProductFromDataCompany!.activeChat,
      "fa_image_one[]":imageProduct,
      "days_add_coupon":addProductFromDataCompany.couponDateNumber,
      "category_id":addProductFromDataCompany.categoryId,
      "coupon_percent":addProductFromDataCompany.couponPercent,
      "type":"B",
      "in_out":addProductFromDataCompany.inOut,
      "is_have":addProductFromDataCompany.isHave,
      "id_ad_special_feature":addProductFromDataCompany.idAdSpecialFeature,
      "mobile":addProductFromDataCompany.mobile,
      "is_add_coupon":addProductFromDataCompany.isAddCoupon,
      "ads_name":addProductFromDataCompany.adsName,
      "ads_description":addProductFromDataCompany.adsDescription,
      "user_id":DIManager.findDep<SharedPrefs>().getUserID(),
      "account_type":"company",
      "language_id":"1",
      "price":addProductFromDataCompany.price,

    } ;
    formData = FormData.fromMap(data);
    return await RemoteDataSource.request<AddAdsModel>(
      converter: (model) => AddAdsModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      formData: formData,

      url: '${AppEndpoints.baseUrl}${AppEndpoints.addAdsUrl}ar',
    );
  }

}
