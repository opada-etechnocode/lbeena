part of 'coupon_cubit.dart';

class CouponState {}

 class CouponInitial extends CouponState {}


class LoadingCouponsUsersState extends CouponState{}

class SuccessCouponsUsersState extends CouponState{
  final CouponUserModel? couponUserModel;
  SuccessCouponsUsersState(this.couponUserModel);
}


class ErrorCouponsUsersState extends CouponState{
 final String? error;
 ErrorCouponsUsersState(this.error);
}
class LoadingCouponsOuterState extends CouponState{}
class LoadingRefreshCouponsOuterState extends CouponState{}

class SuccessCouponsOuterState extends CouponState{
  final CouponOuterModel? couponOuterModel;
  SuccessCouponsOuterState(this.couponOuterModel);
}


class ErrorCouponsOuterState extends CouponState{
  final String? error;
  ErrorCouponsOuterState(this.error);
}


class LoadingSearchCouponsOuterState extends CouponState{}
class LoadingSearchRefreshCouponsOuterState extends CouponState{}

class SuccessSearchCouponsOuterState extends CouponState{
  final CouponOuterModel? couponOuterModel;
  final int pageSearch;
  SuccessSearchCouponsOuterState(this.couponOuterModel,this.pageSearch);
}


class ErrorSearchCouponsOuterState extends CouponState{
  final String? error;
  ErrorSearchCouponsOuterState(this.error);
}

class LoadingCouponsAdsState extends CouponState{}

class SuccessCouponsAdsState extends CouponState{
  final CouponModel? couponUserModel;
  SuccessCouponsAdsState(this.couponUserModel);
}


class ErrorCouponsAdsState extends CouponState{
  final String? error;
  ErrorCouponsAdsState(this.error);
}

class LoadingUsedCouponsState extends CouponState{}

class SuccessUsedCouponsState extends CouponState{
  final CouponUserModel? couponUserModel;
  int indexCoupon;
  SuccessUsedCouponsState(this.couponUserModel,this.indexCoupon);
}


class ErrorUsedCouponsState extends CouponState{
  final String? error;
  ErrorUsedCouponsState(this.error);
}





class LoadingReadCouponsState extends CouponState{}
  class LoadingRefreshCouponsUsersState extends CouponState{}
  class LoadingRefreshCouponsAdsState extends CouponState{}

class SuccessReadCouponsState extends CouponState{
  final CouponUserModel? couponUserModel;
  int indexCoupon;
  SuccessReadCouponsState(this.couponUserModel,this.indexCoupon);
}


class ErrorReadCouponsState extends CouponState{
  final String? error;
  ErrorReadCouponsState(this.error);
}
class LoadingSearchCouponsUsersState extends CouponState{}

class SuccessSearchCouponsUsersState extends CouponState{
  final CouponUserModel? couponUserModel;
  final int pageSearch;
  SuccessSearchCouponsUsersState(this.couponUserModel,this.pageSearch);
}
class ErrorSearchCouponsUsersState extends CouponState{
  final String? error;
  ErrorSearchCouponsUsersState(this.error);
}


class LoadingSearchCouponsAdsState extends CouponState{}

class SuccessSearchCouponsAdsState extends CouponState{
  final CouponModel? couponUserModel;
  final int pageSearch;
  SuccessSearchCouponsAdsState(this.couponUserModel,this.pageSearch);
}
class ErrorSearchCouponsAdsState extends CouponState{
  final String? error;
  ErrorSearchCouponsAdsState(this.error);
}