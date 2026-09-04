part of 'favorite_page_cubit.dart';

class FavoritePageState {}

class FavoritePageInitial extends FavoritePageState {}

/// Get Favorite Ads

class LoadingGetFavoriteAdsState extends FavoritePageState {

}

class SuccessGetFavoriteAdsState extends FavoritePageState {
  final HomePageModel homePageModel;
  SuccessGetFavoriteAdsState(this.homePageModel);
}

class ErrorGetFavoriteAdsState extends FavoritePageState {
  final String error;
  ErrorGetFavoriteAdsState(this.error);
}
