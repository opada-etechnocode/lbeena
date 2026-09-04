import 'package:syrians_in_uae/data/models/coupon/coupon_user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/coupon/coupon_model.dart';
import '../../../../data/models/coupon/coupon_outer_model.dart';
import '../../../../data/sources/coupon/coupon_remote_data_source.dart';

part 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit() : super(CouponInitial());

  static CouponCubit get(context) => BlocProvider.of(context);


  CouponUserModel? couponUserModel;
  Future<void> getAllCouponsUser(
  {required bool isRefresh , required int page,}
      ) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      if (!isRefresh){
        emit(LoadingCouponsUsersState());

      }else {
        emit(LoadingRefreshCouponsUsersState());
      }

      var getPolicyTermsAppLinksData = await couponUsersDataSourceImpl.getAllCoupons(page: page);

      if (getPolicyTermsAppLinksData.data != null) {
        couponUserModel = getPolicyTermsAppLinksData.data;
        emit(SuccessCouponsUsersState(getPolicyTermsAppLinksData.data!));
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorCouponsUsersState("Error is $e"));
    }
  }

  Future<void> getAllCouponsOuter(
      {required bool isRefresh , required int page,}
      ) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      if (!isRefresh){
        emit(LoadingCouponsOuterState());

      }else {
        emit(LoadingRefreshCouponsOuterState());
      }

      var dataCouponOuter = await couponUsersDataSourceImpl.getAllCouponsOuter(page: page);

      if (dataCouponOuter.data != null) {
        emit(SuccessCouponsOuterState(dataCouponOuter.data!));
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorCouponsOuterState(dataCouponOuter.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponOuter is : $e in $stack");
      emit(ErrorCouponsOuterState("Error is $e"));
    }
  }

  Future<void> searchAllCouponsOuter(
      {required bool isRefresh , required int page,
      required String title,}
      ) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      if (!isRefresh){
        emit(LoadingSearchCouponsOuterState());

      }else {
        emit(LoadingSearchRefreshCouponsOuterState());
      }

      var dataCouponOuter = await couponUsersDataSourceImpl.getAllCouponsOuter(page: page,
      isSearch: true,title: title);

      if (dataCouponOuter.data != null) {
        emit(SuccessSearchCouponsOuterState(dataCouponOuter.data!,page));
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorSearchCouponsOuterState(dataCouponOuter.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponOuter is : $e in $stack");
      emit(ErrorSearchCouponsOuterState("Error is $e"));
    }
  }
  Future<void> getAllAdsCoupons(
      {required bool isRefresh , required int page,
      int? categoryId,
      int? cityId,
      }
      ) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      if (!isRefresh){
        emit(LoadingCouponsAdsState());

      }else {
        emit(LoadingRefreshCouponsAdsState());
      }

      var getPolicyTermsAppLinksData = await couponUsersDataSourceImpl.getAllAdsCoupons(page: page,
      categoryId:categoryId ,
      cityId: cityId);

      if (getPolicyTermsAppLinksData.data != null) {
        emit(SuccessCouponsAdsState(getPolicyTermsAppLinksData.data!));
      } else {
        emit(ErrorCouponsAdsState(getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorCouponsAdsState("Error is $e"));
    }
  }
  Future<void> searchCouponsAds({required int page,
    int? categoryId,
    String? description,
    int? cityId,required bool isRefresh}) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      if (!isRefresh){
        emit(LoadingSearchCouponsAdsState());

      }else {
        emit(LoadingRefreshCouponsAdsState());
      }


      var getPolicyTermsAppLinksData = await couponUsersDataSourceImpl.searchAllAdsCoupons(page: page,
      cityId: cityId,
      categoryId: categoryId,description: description,);

      if (getPolicyTermsAppLinksData.data != null) {
        emit(SuccessSearchCouponsAdsState(getPolicyTermsAppLinksData.data!, page));
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorSearchCouponsAdsState(getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorSearchCouponsAdsState("Error is $e"));
    }

  }

  Future<void> readCoupons({
   required String code, required int indexCoupon,
}) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      emit(LoadingReadCouponsState());

      var getPolicyTermsAppLinksData = await couponUsersDataSourceImpl.readCoupons(code: code);

      if (getPolicyTermsAppLinksData.data != null) {
        // couponUserModel = getPolicyTermsAppLinksData.data;

        emit(SuccessReadCouponsState(getPolicyTermsAppLinksData.data!, indexCoupon,));

      } else {
        // emit(ErrorReadCouponsState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorReadCouponsState(getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorReadCouponsState("Error is $e"));
    }
  }

  Future<void> usedCoupons({
    required String code, required int indexCoupon,
  }) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      emit(LoadingUsedCouponsState());

      var getPolicyTermsAppLinksData = await couponUsersDataSourceImpl.usedCoupons(code: code);

      if (getPolicyTermsAppLinksData.data != null) {
        // couponUserModel = getPolicyTermsAppLinksData.data;
        emit(SuccessUsedCouponsState(getPolicyTermsAppLinksData.data!, indexCoupon));

      } else {
        // emit(ErrorUsedCouponsState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorUsedCouponsState(getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorUsedCouponsState("Error is $e"));
    }
  }
  Future<void> searchCouponsUser({required String code, required int page, required bool isRefresh}) async {
    CouponRemoteDataSourceImpl couponUsersDataSourceImpl =
    const CouponRemoteDataSourceImpl();
    try {
      if (!isRefresh){
        emit(LoadingSearchCouponsUsersState());

      }else {
        emit(LoadingRefreshCouponsUsersState());
      }


      var getPolicyTermsAppLinksData = await couponUsersDataSourceImpl.searchCoupon(code: code,page: page);

      if (getPolicyTermsAppLinksData.data != null) {
        emit(SuccessSearchCouponsUsersState(getPolicyTermsAppLinksData.data!, page));
      } else {
        // emit(ErrorCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
        emit(ErrorSearchCouponsUsersState(getPolicyTermsAppLinksData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In CouponUsers is : $e in $stack");
      emit(ErrorSearchCouponsUsersState("Error is $e"));
    }

}
}
