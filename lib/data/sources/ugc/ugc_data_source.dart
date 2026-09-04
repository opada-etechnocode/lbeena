import 'package:dio/dio.dart';
import 'package:syrians_in_uae/core/results/result.dart';
import 'package:syrians_in_uae/data/models/ugc/ugc_users_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/ugc/subscribe_ugc_model.dart';
import '../../models/ugc/ugc_category_model.dart';

abstract class UGCDataSource {
  const UGCDataSource();

  Future<Result<SubscribeToUgcModel?>> subscribeToUgc({
    required int cityId,
    required int categoryUgcId,
    required bool isMore3000,
    required String gender,
    required List<String> ugcLinks,
  });

  Future<Result<UgcCategoryModel?>> getUgcCategory();
  Future<Result<UgcUsersModel?>> getUgcUsers(
      {
        required int page
      }
      );

  Future<Result<UgcUsersModel?>> searchUgcUsers(
      {
        required int page,
        int? cityId,
        int? categoryUgcId,
        String? gender,
        String? search,
        required int isMore3000,
      }
      );
}

class UGCDataSourceImpl implements UGCDataSource {
  const UGCDataSourceImpl();

  @override
  Future<Result<SubscribeToUgcModel?>> subscribeToUgc({
    required int cityId,
    required int categoryUgcId,
    required String gender,
    required bool isMore3000,
    required List<String> ugcLinks,
  }) async {
    final Map<String, dynamic> data = {
      'is_ugc_enabled': true,
      'city_id': cityId,
      'category_ugc_id': categoryUgcId,
      'has_more_than_3000': isMore3000 ?1:0,
      'gender': gender,
      'ugc_links': ugcLinks,
    };
    return await RemoteDataSource.request<SubscribeToUgcModel>(
      converter: (model) => SubscribeToUgcModel.fromJson(model),
      method: HttpMethod.POST,
      data: data,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: AppEndpoints.baseUrl + AppEndpoints.subscribeToUgcUrl,
    );
  }

  @override
  Future<Result<UgcCategoryModel?>> getUgcCategory() async {
    return await RemoteDataSource.request<UgcCategoryModel>(
      converter: (model) => UgcCategoryModel.fromJson(model),
      method: HttpMethod.GET,
      url: AppEndpoints.baseUrl + AppEndpoints.ugcCategoryUrl,
    );
  }

  @override
  Future<Result<UgcUsersModel?>> searchUgcUsers(
  {
    required int page,
    int? cityId,
    int? categoryUgcId,
    String? gender,
    String? search,
    required int isMore3000,
}
      ) async {
    Map<String, dynamic> data =(isMore3000==-1? {
      'city_id': cityId,
      'category_ugc_id': categoryUgcId,
      'gender': gender,
      'search': search,
    }: {
      'city_id': cityId,
      'category_ugc_id': categoryUgcId,
      'gender': gender,
      'search': search,
      'has_more_than_3000': isMore3000 ,
    })..removeWhere((key, value) => value == null);

    return await RemoteDataSource.request<UgcUsersModel>(
      converter: (model) => UgcUsersModel.fromJson(model),
      method: HttpMethod.POST,
      data:  data,
      url: '${AppEndpoints.baseUrl}${AppEndpoints.searchUgcUsersUrl}?page=$page',
    );
  }


  @override
  Future<Result<UgcUsersModel?>> getUgcUsers(
  {
    required int page
}
      ) async {
    return await RemoteDataSource.request<UgcUsersModel>(
      converter: (model) => UgcUsersModel.fromJson(model),
      method: HttpMethod.GET,
      url: '${AppEndpoints.baseUrl}${AppEndpoints.ugcUsersUrl}?page=$page',
    );
  }
}
