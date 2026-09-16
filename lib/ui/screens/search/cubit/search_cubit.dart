import 'package:syrians_in_uae/data/models/search/seach_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/home_page/banner_product_model.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import '../../../../data/sources/search/search_page_data_source.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  static SearchCubit get(context) => BlocProvider.of(context);

  TextEditingController searchController = TextEditingController();
  int? categoryId;

  List<DataProductBannerModel> data =[];
  List<DataProductBannerModel> categoryBanners = [];
  bool isLoadingSearch = false;

  Future<void> loadCategoryBanners(int? categoryId) async {
    categoryBanners.clear();
    if (categoryId == null || categoryId == -1) {
      emit(SuccessCategoryBannerState());
      return;
    }
    try {
      const dataSource = HomePageDataSourceImpl();
      final result =
          await dataSource.getCategoriesPartNew(id: categoryId, page: 1);
      final banners = result.data?.adsBanner?.data?.data;
      if (banners != null && banners.isNotEmpty) {
        categoryBanners = List<DataProductBannerModel>.from(banners);
      }
      emit(SuccessCategoryBannerState());
    } catch (_) {
      emit(SuccessCategoryBannerState());
    }
  }

  Future<void> getSearchItem({
     String? title,
     int? categoryId,
  required   int page,
  required   bool clearDate,
  }) async {
    SearchDataSourceImpl searchDataSourceImpl =
    const SearchDataSourceImpl();
    try {
      if(clearDate){
        isLoadingSearch = true;
        data.clear();
      }

      emit(LoadingSearchItemState());

      var searchPageData = await searchDataSourceImpl.getItemSearch(title: title,
      page: page,
      categoryId:categoryId );

      if (searchPageData.data != null) {
        isLoadingSearch = false;
        emit(SuccessSearchItemState(searchPageData.data));
      } else {
        isLoadingSearch = false;
        emit(ErrorSearchItemState(searchPageData.error!.message!));
      }
    } catch (e, stack) {
      isLoadingSearch = false;
      print("Error In HomePage is : $e in $stack");
      emit(ErrorSearchItemState("Error is $e"));
    }
  }
}
