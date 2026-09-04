
import 'package:syrians_in_uae/data/models/GeneralResult.dart';
import 'package:syrians_in_uae/data/models/coupon/coupon_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/coupon/coupon_outer_model.dart';
import '../../models/coupon/coupon_user_model.dart';
import '../../../core/utils/endpoints.dart';

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  const CouponRemoteDataSourceImpl();

  @override
  Future<Result<CouponUserModel>> getStatusUserCoupon({required int adsId})async {
    return await RemoteDataSource.request<CouponUserModel>(
      converter: (model) => CouponUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'ads_id':adsId,
      },
      url: "${AppEndpoints.baseUrl}mobile/coupon/get_status",
    );
  }



  @override
  Future<Result<CouponUserModel>> searchCoupon({required String code, required int page})async {
    return await RemoteDataSource.request<CouponUserModel>(
      converter: (model) => CouponUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'code':code,
      },
      url: "${AppEndpoints.baseUrl}mobile/coupon/search?page=$page",
    );
  }
  @override
  Future<Result<GeneralResult>> createCouponForUser({
    required int adsId,
    required int companyId,
    required String couponValue,
  })async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'user_id':DIManager.findDep<SharedPrefs>().getUserID(),
        'ads_id':adsId,
        'company_id':companyId,
        'coupon_value':couponValue,
        'start_date':DateTime.now().toString(),
      },
      url: "${AppEndpoints.baseUrl}mobile/coupon/store",
    );
  }

  @override
  Future<Result<CouponUserModel>> getAllCoupons({required int page})async {
    return await RemoteDataSource.request<CouponUserModel>(
      converter: (model) => CouponUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/coupon/get?page=$page",
    );
  }

  @override
  Future<Result<CouponOuterModel>> getAllCouponsOuter({required int page,bool isSearch =false,String? title})async {
    return await RemoteDataSource.request<CouponOuterModel>(
      converter: (model) => CouponOuterModel.fromJson(model),
      method: HttpMethod.POST,
      data:isSearch? {
        'search':title,
      }:null,
      url: "${AppEndpoints.baseUrl}mobile/outer/coupon/get?page=$page",
    );
  }

  @override
  Future<Result<CouponModel>> getAllAdsCoupons({required int page, int? categoryId,int? cityId})async {
    return await RemoteDataSource.request<CouponModel>(
      converter: (model) => CouponModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        'category_id':categoryId,
        'city_id':cityId,
      },
      url: "${AppEndpoints.baseUrl}ads_coupon/ar?page=$page",
    );
  }

  @override
    Future<Result<CouponModel>> searchAllAdsCoupons({required int page,
      int? categoryId,
      String? description,
      int? cityId})async {
    return await RemoteDataSource.request<CouponModel>(
      converter: (model) => CouponModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        'category_id':categoryId,
        'city_id':cityId,
        'description':description,
      },
      url: "${AppEndpoints.baseUrl}search_ads_coupon/ar?page=$page",
    );
  }

  @override
  Future<Result<CouponUserModel>> readCoupons({
    required String code,
  })async {
    return await RemoteDataSource.request<CouponUserModel>(
      converter: (model) => CouponUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'code':code,
      },
      url: "${AppEndpoints.baseUrl}mobile/coupon/read",
    );
  }
  @override
  Future<Result<CouponUserModel>> usedCoupons({
    required String code,
  })async {
    return await RemoteDataSource.request<CouponUserModel>(
      converter: (model) => CouponUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'code':code,
      },
      url: "${AppEndpoints.baseUrl}mobile/coupon/used",
    );
  }
}

abstract class CouponRemoteDataSource {
  const CouponRemoteDataSource();
  Future<Result<CouponUserModel>> getAllCoupons({required int page});
  Future<Result<CouponUserModel>> searchCoupon({required String code,required int page});
  Future<Result<CouponUserModel>> getStatusUserCoupon({required int adsId});
  Future<Result<GeneralResult>> createCouponForUser({
    required int adsId,
    required int companyId,
    required String couponValue,
});
  Future<Result<CouponUserModel>> readCoupons({
    required String code,
  });
  Future<Result<CouponUserModel>> usedCoupons({
    required String code,
  });
  Future<Result<CouponModel>> getAllAdsCoupons({required int page, int? categoryId,int? cityId});

  Future<Result<CouponModel>> searchAllAdsCoupons({required int page,
    int? categoryId,
    String? description,
    int? cityId});
  Future<Result<CouponOuterModel>> getAllCouponsOuter({required int page,bool isSearch =false,String? title});
}
