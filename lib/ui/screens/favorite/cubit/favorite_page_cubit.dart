import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/sources/home_page/home_page_data_source.dart';

part 'favorite_page_state.dart';

class FavoritePageCubit extends Cubit<FavoritePageState> {
  FavoritePageCubit() : super(FavoritePageInitial());

  static FavoritePageCubit getDate(context) {
    return BlocProvider.of(context);
  }

  Future<void> getFavoriteAds() async {
    HomePageDataSourceImpl favoriteAdsDataSourceImpl =
        const HomePageDataSourceImpl();
    try {
      emit(LoadingGetFavoriteAdsState());

      var favoriteAdsData = await favoriteAdsDataSourceImpl.getFavoriteAds();

      if (favoriteAdsData.data != null) {
        emit(SuccessGetFavoriteAdsState(favoriteAdsData.data!));
      } else {
        emit(ErrorGetFavoriteAdsState(favoriteAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In  GetFavoriteAdsData is : $e in $stack");
      emit(ErrorGetFavoriteAdsState("Error is $e`"));
    }
  }
}
