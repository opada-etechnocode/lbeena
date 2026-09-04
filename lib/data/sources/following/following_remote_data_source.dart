import 'package:syrians_in_uae/data/models/following/following_general_model.dart';
import 'package:syrians_in_uae/data/models/following/is_following_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/coupon/coupon_user_model.dart';

class FollowingRemoteDataSourceImpl implements FollowingRemoteDataSource {
  const FollowingRemoteDataSourceImpl();

  @override
  Future<Result<IsFollowingModel>> isFollowUser({required int userId})async {
    return await RemoteDataSource.request<IsFollowingModel>(
      converter: (model) => IsFollowingModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'user_followed_id':userId,
      },
      url: "${AppEndpoints.baseUrl}mobile/user/is-following",
    );
  }

  @override
  Future<Result<FollowingGeneralModel>> followUser({required int userId})async {
    return await RemoteDataSource.request<FollowingGeneralModel>(
      converter: (model) => FollowingGeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'user_followed_id':userId,
      },
      url: "${AppEndpoints.baseUrl}mobile/user/follow",
    );
  }

  @override
  Future<Result<FollowingGeneralModel>> unFollowUser({required int userId})async {
    return await RemoteDataSource.request<FollowingGeneralModel>(
      converter: (model) => FollowingGeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'user_followed_id':userId,
      },
      url: "${AppEndpoints.baseUrl}mobile/user/unFollow",
    );
  }

  /// المتابعون من قبل هذا المستخدم : الإشخاص الذين يتابعهم
  @override
  Future<Result<FollowingGeneralModel>> followingsForUser({required int userId, required int page})async {
    return await RemoteDataSource.request<FollowingGeneralModel>(
      converter: (model) => FollowingGeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'user_id':userId,
        'page':page,
      },
      url: "${AppEndpoints.baseUrl}mobile/user/followings_for_user",
    );
  }
  /// الأشخاص الذين يتابعون هذا المستخدم
  @override
  Future<Result<FollowingGeneralModel>> followersForUser({required int userId, required int page})async {
    return await RemoteDataSource.request<FollowingGeneralModel>(
      converter: (model) => FollowingGeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data:  {
        'user_id':userId,
        'page':page,
      },
      url: "${AppEndpoints.baseUrl}mobile/user/all_Followers_for_user",
    );
  }
}

abstract class FollowingRemoteDataSource {
  const FollowingRemoteDataSource();
  Future<Result<IsFollowingModel>> isFollowUser({required int userId});
  Future<Result<FollowingGeneralModel>> followUser({required int userId});
  Future<Result<FollowingGeneralModel>> unFollowUser({required int userId});
  Future<Result<FollowingGeneralModel>> followingsForUser({required int userId, required int page});
  Future<Result<FollowingGeneralModel>> followersForUser({required int userId, required int page});
}
