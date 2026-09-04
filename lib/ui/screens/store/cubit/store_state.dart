import 'package:syrians_in_uae/data/models/store/ads_store.dart';

abstract class StoreState {}

final class StoreInitial extends StoreState {}
final class GatAdsStoreStateLoading extends StoreState {}
final class GatAdsStoreStateSuccess extends StoreState {
  AdsStoreModel adsStoreModel;
  GatAdsStoreStateSuccess(this.adsStoreModel);
}
final class GatAdsStoreStateError extends StoreState {
  String error;
  GatAdsStoreStateError(this.error);
}
