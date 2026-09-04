import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../../core/net/api_provider.dart';
import '../../../../core/net/http_method.dart';

import '../../../../core/results/result.dart';


abstract class RemoteDataSource {
  static const String requiresToken = 'requiresToken';
  static const String deviceId = "device-id";
  static const String deviceType = "ui-version";
  static const String osType = "os-type";

  static Future<Result<MODEL>>  request<MODEL>({
    MODEL Function(dynamic)? converter,
    MODEL Function(List<dynamic>?)? converterList,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool listRequest = false,
    CancelToken? cancelToken,
    FormData? formData,
  }) async {
    // log('${method.name} url: $url');
    // log('body: $data');
    // headers ??= {
    // };
print('${method.name} url: $url');
    /// هاااام

    ///  headers["Lang"] =       DIManager.findDep<ApplicationCubit>().appLanguage.languageCode;

    // if (headers[RemoteDataSource.requiresToken] == null) {
    //   headers[RemoteDataSource.requiresToken] = true;
    //   if(DIManager.findDep<SharedPrefs>().fcmToken.val != null){
    //     headers[deviceId] = DIManager.findDep<SharedPrefs>().fcmToken.val;
    //     headers[deviceType] = GlobalNotification.instance.currentVersion;
    //     headers[osType] = GlobalNotification.instance.osType;
    //   }
    // }
    return await ApiProvider.sendObjectRequest<MODEL>(
      converter: converter,
      converterList: converterList,
      method: method,
      url: url,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      formData: formData,
    );
  }
}
