
import 'package:syrians_in_uae/data/models/GeneralResult.dart';
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

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  const EventsRemoteDataSourceImpl();

  @override
  Future<Result<SocialMediaEffectivenessModel>> getSocialMediaEffectiveness()async {
    return await RemoteDataSource.request<SocialMediaEffectivenessModel>(
      converter: (model) => SocialMediaEffectivenessModel.fromJson(model),
      method: HttpMethod.GET,
      url: "${AppEndpoints.baseUrl}${AppEndpoints.socialMediaEffectivenessUrl}",
    );
  }


  @override
  Future<Result<EffectivenessModel>> getEffectiveness({
    required int page
})async {
    return await RemoteDataSource.request<EffectivenessModel>(
      converter: (model) => EffectivenessModel.fromJson(model),
      method: HttpMethod.GET,
      queryParameters: {
        "page":page
      },
      url: "${AppEndpoints.baseUrl}${AppEndpoints.effectivenessUrl}",
    );
  }

}

abstract class EventsRemoteDataSource {
  const EventsRemoteDataSource();
  Future<Result<SocialMediaEffectivenessModel>> getSocialMediaEffectiveness();
  Future<Result<EffectivenessModel>> getEffectiveness({
    required int page
  });
}
