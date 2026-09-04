import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syrians_in_uae/ui/screens/ugc/cubit/ugc_state.dart';

import '../../../../data/sources/ugc/ugc_data_source.dart';

class UgcCubit extends Cubit<UgcState> {
  UgcCubit() : super(UgcInitial());

  static UgcCubit get(context) => BlocProvider.of(context);

  Future<void> subscribeToUgc({
    required int cityId,
    required int categoryUgcId,
    required String gender,
    required bool isMore3000,
    required List<String> ugcLinks,
  }) async {
    UGCDataSourceImpl ugcDataSourceImpl = const UGCDataSourceImpl();
    try {
      emit(LoadingSubscribeToUgcState());

      var searchPageData = await ugcDataSourceImpl.subscribeToUgc(
          cityId: cityId,
          categoryUgcId: categoryUgcId,
          isMore3000: isMore3000,
          gender: gender,
          ugcLinks: ugcLinks);

      if (searchPageData.data != null) {
        emit(SuccessSubscribeToUgcState(searchPageData.data));
      } else {
        emit(ErrorSubscribeToUgcState(searchPageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In SubscribeToUgc is : $e in $stack");
      emit(ErrorSubscribeToUgcState("Error is $e"));
    }
  }

  ///getUgcCategory
  Future<void> getUgcCategory() async {
    UGCDataSourceImpl ugcDataSourceImpl = const UGCDataSourceImpl();
    try {
      emit(LoadingUgcCategoryState());

      var searchPageData = await ugcDataSourceImpl.getUgcCategory();

      if (searchPageData.data != null) {
        emit(SuccessUgcCategoryState(searchPageData.data!));
      } else {
        emit(ErrorUgcCategoryState(searchPageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In UgcCategory is : $e in $stack");
      emit(ErrorUgcCategoryState("Error is $e"));
    }
  }

  ///getUgcUsers
  Future<void> getUgcUsers(
  {
 required   int page,
    bool isLoading =true
}
      ) async {
    UGCDataSourceImpl ugcDataSourceImpl = const UGCDataSourceImpl();
    try {
      if(isLoading){
        emit(LoadingUgcUsersState());

      }

      var searchPageData = await ugcDataSourceImpl.getUgcUsers(page: page);

      if (searchPageData.data != null) {
        emit(SuccessUgcUsersState(searchPageData.data!));
      } else {
        emit(ErrorUgcUsersState(searchPageData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In UgcUsers is : $e in $stack");
      emit(ErrorUgcUsersState("Error is $e"));
    }
  }

  Future<void> searchUgcUsers({
    required int page,
     int? cityId,
     int? categoryUgcId,
     String? gender,
     String? search,
    required int isMore3000,
     bool isLoading =true,
  }) async  {
    UGCDataSourceImpl ugcDataSourceImpl = const UGCDataSourceImpl();
    try {
      if (isLoading){
        emit(LoadingSearchUgcUsersState());
      }

      var dataUserUgc = await ugcDataSourceImpl.searchUgcUsers(page: page, cityId: cityId, categoryUgcId: categoryUgcId, gender: gender, search: search,isMore3000:isMore3000);
      if (dataUserUgc.data != null) {
        emit(SuccessSearchUgcUsersState(dataUserUgc.data!));
      } else {
        emit(ErrorSearchUgcUsersState(dataUserUgc.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorSearchUgcUsersState is : $e in $stack");
      emit(ErrorSearchUgcUsersState("Error is $e"));
    }

  }
    }
