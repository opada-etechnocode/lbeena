import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/auth/otp/otp_model.dart';
import '../../models/payment/payment_package_model.dart';
import '../../../core/utils/endpoints.dart';

abstract class PaymentPageDataSource {
  const PaymentPageDataSource();

  Future<Result<PaymentPackageModel>> paymentPackage(
  {required int packageId}
      );

  Future<Result<GeneralModel>> payForAdsSpecialFeatures({
    required String paymentMethod,
    required int idAdSpecialFeature,
    required int idAds,
    required String priceSpecialFeature,

  });

  Future<Result<GeneralModel>> changeStatusAdsFromUnPaid({
    required int idAds,
  });

  Future<Result<PaymentPackageModel>> paymentAdsByPackage({
    required int packageId,
    required String priceAds,
    required int idAds,
    required String paymentMethod,
  });
}

class PaymentPageDataSourceImpl implements PaymentPageDataSource {
  const PaymentPageDataSourceImpl();


  @override
  Future<Result<GeneralModel>> changeStatusAdsFromUnPaid({
    required int idAds,
  }) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      data:  {
        'user_id':DIManager.findDep<SharedPrefs>().getUserID(),
        'ads_id':idAds,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}ads/change-ads-expired-status' ,
    );
  }
  @override
  Future<Result<PaymentPackageModel>> paymentPackage({required int packageId}) async {
    return await RemoteDataSource.request<PaymentPackageModel>(
      converter: (model) => PaymentPackageModel.fromJson(model),
      method: HttpMethod.POST,
      data:  {
        'user_id':DIManager.findDep<SharedPrefs>().getUserID(),
        'package_id':packageId,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}mobile/user/add_package_company' ,
    );
  }

  @override
  Future<Result<GeneralModel>> payForAdsSpecialFeatures({
    required String paymentMethod,
    required int idAdSpecialFeature,
    required int idAds,
    required String priceSpecialFeature,

  })async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "user_id":DIManager.findDep<SharedPrefs>().getUserID(),
        "payment_method":paymentMethod,
        "id_ad_special_feature":idAdSpecialFeature,
        "price":priceSpecialFeature,
        "ads_id":idAds,
      },
      url: '${AppEndpoints.baseUrl}mobile/payment/store_special',
    );
  }
  @override
  Future<Result<PaymentPackageModel>> paymentAdsByPackage({
    required int packageId,
    required String priceAds,
    required int idAds,
    required String paymentMethod,
}) async {
    return await RemoteDataSource.request<PaymentPackageModel>(
      converter: (model) => PaymentPackageModel.fromJson(model),
      method: HttpMethod.POST,
      data:  {
        'user_id':DIManager.findDep<SharedPrefs>().getUserID(),
        'package_id':packageId,
        'payment_method':paymentMethod,
        'price':priceAds,
        'ads_id':idAds,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: '${AppEndpoints.baseUrl}mobile/payment/store' ,
    );
  }

}
