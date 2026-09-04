
import 'package:syrians_in_uae/data/models/GeneralResult.dart';
import 'package:syrians_in_uae/data/models/calender/calender_model.dart';
import 'package:syrians_in_uae/data/models/coupon/coupon_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/coupon/coupon_user_model.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/events/effectiveness.dart';
import '../../models/events/social_media_effectiveness.dart';

class CalenderRemoteDataSourceImpl implements CalenderRemoteDataSource {
  const CalenderRemoteDataSourceImpl();
  @override
  Future<Result<CalenderModel>> getCalenderInfo()async {
    return await RemoteDataSource.request<CalenderModel>(
      converter: (model) => CalenderModel.fromJson(model),
      method: HttpMethod.GET,
      url: "${AppEndpoints.baseUrl}${AppEndpoints.calenderUrl}",
    );
  }
}

abstract class CalenderRemoteDataSource {
  const CalenderRemoteDataSource();
  Future<Result<CalenderModel>> getCalenderInfo();
}
