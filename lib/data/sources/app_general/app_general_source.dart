import 'dart:io';

import 'package:syrians_in_uae/core/data_source/base_remote_data_source.dart';
import 'package:syrians_in_uae/core/net/http_method.dart';
import 'package:syrians_in_uae/data/models/GeneralResult.dart';
import 'package:syrians_in_uae/data/models/search/seach_model.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';

abstract class AppGeneralDataSource {
  const AppGeneralDataSource();
  Future<Result<GeneralResult>> deletedDeviceToken();
}

class AppGeneralDataSourceImpl implements AppGeneralDataSource {
  const AppGeneralDataSourceImpl();


  @override
  Future<Result<GeneralResult>> deletedDeviceToken() async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.POST,
      data: Platform.isAndroid
          ? {
              'user_id': DIManager.findDep<SharedPrefs>().getUserID(),
              'android_token':
                  DIManager.findDep<SharedPrefs>().getDeviceToken(),
            }
          : {
              'user_id': DIManager.findDep<SharedPrefs>().getUserID(),
              'ios_token': DIManager.findDep<SharedPrefs>().getDeviceToken(),
            },
      headers: {RemoteDataSource.requiresToken: false},
      url: AppEndpoints.baseUrl + AppEndpoints.removeDeviceToken,
    );
  }
}
