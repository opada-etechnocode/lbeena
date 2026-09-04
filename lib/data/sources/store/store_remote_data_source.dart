
import 'package:syrians_in_uae/data/models/store/ads_store.dart';
import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/utils/endpoints.dart';

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  const StoreRemoteDataSourceImpl();
  @override
  Future<Result<AdsStoreModel>> getStoreAds({
    required int page
})async {
    return await RemoteDataSource.request<AdsStoreModel>(
      converter: (model) => AdsStoreModel.fromJson(model),
      method: HttpMethod.GET,
      url: "${AppEndpoints.baseUrl}${AppEndpoints.adsStoreUrl}page=$page",
    );
  }
}

abstract class StoreRemoteDataSource {
  const StoreRemoteDataSource();
  Future<Result<AdsStoreModel>> getStoreAds({
    required int page
  });
}
