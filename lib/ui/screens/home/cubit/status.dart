

import 'package:syrians_in_uae/data/models/GeneralResult.dart';
import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:syrians_in_uae/data/models/company/company_model.dart';
import 'package:syrians_in_uae/data/models/home_page/app_terms_policy_model.dart';
import 'package:syrians_in_uae/data/models/home_page/categorie_part.dart';
import 'package:syrians_in_uae/data/models/home_page/categories_main.dart';
import 'package:syrians_in_uae/data/models/home_page/details_banner_model.dart';
import 'package:syrians_in_uae/data/models/home_page/edit_ads_model.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';
import 'package:syrians_in_uae/data/models/home_page/is_favorite_model.dart';

import '../../../../data/models/add_ad_new/add_ad_model.dart';
import '../../../../data/models/add_ad_new/category_details_model.dart';
import '../../../../data/models/add_ad_new/category_model.dart';
import '../../../../data/models/add_ad_new/cities_model.dart';
import '../../../../data/models/add_ads/ads_special_features_model.dart';
import '../../../../data/models/add_ads/price_ads_model.dart';
import '../../../../data/models/check_company_whatsapp.dart';
import '../../../../data/models/coupon/coupon_user_model.dart';
import '../../../../data/models/government_with_services/government_with_services.dart';
import '../../../../data/models/home_page/ads_evaluation_model.dart';
import '../../../../data/models/home_page/ads_random_model.dart';
import '../../../../data/models/home_page/banner_product_model.dart';
import '../../../../data/models/home_page/edit_mobile_number_model.dart';
import '../../../../data/models/home_page/packages_user_model.dart';
import '../../../../data/models/home_page/show_ads_model.dart';
import '../../../../data/models/home_page/statistics_model.dart';
import '../../../../data/models/home_page/status_recoder_model.dart';
import '../../../../data/models/news/news_model.dart';
import '../../../../data/models/notifications/all_notifications_model.dart';
import '../../../../data/models/payment/payment_price.dart';
import '../../../../data/models/radio_model/playNow_model.dart';
import '../../../../data/models/setting_model.dart';
import '../../../../data/models/status_user.dart';
import '../../../../data/models/support/team_service_model.dart';
import '../../../../data/models/theme/color_model.dart';
import '../../auth/login/model_home_page.dart';

abstract class HomeStates  {}

class InitialHomeState extends HomeStates {
}

/// get colors app
class LoadingColorsAppState extends HomeStates {

}
class SuccessColorsAppState extends HomeStates {
  final ColorAppModel colorAppModel;
  SuccessColorsAppState(this.colorAppModel);
}
class ErrorColorsAppState extends HomeStates {
  final String error;
  ErrorColorsAppState(this.error);
}


/// get setting app
class LoadingSettingAppState extends HomeStates {

}
class SuccessSettingAppState extends HomeStates {
  final SettingAppModel settingAppModel;
  SuccessSettingAppState(this.settingAppModel);
}
class ErrorSettingAppState extends HomeStates {
  final String error;
  ErrorSettingAppState(this.error);
}



/// get status Recorder
class LoadingStatusRecorderState extends HomeStates {

}
class SuccessStatusRecorderState extends HomeStates {
  final StatusRecorderModel statusRecorderModel;
  SuccessStatusRecorderState(this.statusRecorderModel);
}
class ErrorStatusRecorderState extends HomeStates {
  final String error;
  ErrorStatusRecorderState(this.error);
}


/// get service team
class LoadingServiceTeamState extends HomeStates {

}
class SuccessServiceTeamState extends HomeStates {
   AllServicesTeamModel  allServicesTeamModel;
  SuccessServiceTeamState(this.allServicesTeamModel);
}
  class ErrorServiceTeamState extends HomeStates {
  final String error;
  ErrorServiceTeamState(this.error);
}
/// Get All News Status
class LoadingGetAllNewsState extends HomeStates {}

class SuccessGetAllNewsState extends HomeStates {
  final NewsModel newsModel;

  SuccessGetAllNewsState(this.newsModel);
}

class ErrorGetAllNewsState extends HomeStates {
  final String error;

  ErrorGetAllNewsState(this.error);
}


///GEt Related News

class LoadingRelatedAdsState extends HomeStates {

}

class SuccessRelatedAdsState extends HomeStates {
  final HomePageModel homePageModel;
  SuccessRelatedAdsState(this.homePageModel);
}

class ErrorRelatedAdsState extends HomeStates {
  final String error;
  ErrorRelatedAdsState(this.error);
}



///

class LoadingGetPriceAdsState extends HomeStates {

}

class SuccessGetPriceAdsState extends HomeStates {
  final PriceAdsModel priceAdsModel;
  SuccessGetPriceAdsState(this.priceAdsModel);
}

class ErrorGetPriceAdsState extends HomeStates {
  final String error;
  ErrorGetPriceAdsState(this.error);
}



///

class SuccessOrderCompaniesState extends HomeStates {}


class LoadingCompaniesState extends HomeStates {}
class LoadingCompaniesPagState extends HomeStates {}
class SuccessCompaniesState extends HomeStates {
  final CompanyModel companyModel;
  SuccessCompaniesState(this.companyModel);
}

class ErrorCompaniesState extends HomeStates {
  final String error;
  ErrorCompaniesState(this.error);
}




///

class LoadingSearchCompaniesState extends HomeStates {

}

class SuccessSearchCompaniesState extends HomeStates {
  final CompanyModel companyModel;
  SuccessSearchCompaniesState(this.companyModel);
}

class ErrorSearchCompaniesState extends HomeStates {
  final String error;
  ErrorSearchCompaniesState(this.error);
}




///

class LoadingChangeStatusCounterForWhatsappShareChatState extends HomeStates {

}

class SuccessChangeStatusCounterForWhatsappShareChatState extends HomeStates {
  final ChangeStatusCounterForWhatsappShareChatModel generalModel;
  SuccessChangeStatusCounterForWhatsappShareChatState(this.generalModel);
}

class ErrorChangeStatusCounterForWhatsappShareChatState extends HomeStates {
  final String error;
  ErrorChangeStatusCounterForWhatsappShareChatState(this.error);
}



///

class LoadingClickStatisticsState extends HomeStates {

}

class SuccessClickStatisticsState extends HomeStates {
  final ClickStatisticsModel generalModel;
  SuccessClickStatisticsState(this.generalModel);
}

class ErrorClickStatisticsState extends HomeStates {
  final String error;
  ErrorClickStatisticsState(this.error);
}


class LoadingHomePageState extends HomeStates {

}

class SuccessHomePageState extends HomeStates {
  final HomePageModel homePageModel;
  SuccessHomePageState(this.homePageModel);
}

class ErrorHomePageState extends HomeStates {
  final String error;
  ErrorHomePageState(this.error);
}



///

class LoadingPackagesUserState extends HomeStates {

}

class SuccessPackagesUserState extends HomeStates {
  final PackagesUserModel packagesUserModel;
  SuccessPackagesUserState(this.packagesUserModel);
}

class ErrorPackagesUserState extends HomeStates {
  final String error;
  ErrorPackagesUserState(this.error);
}

///

class LoadingPayPackagesUserState extends HomeStates {

}

class SuccessPayPackagesUserState extends HomeStates {
  final PackagesUserModel packagesUserModel;
  SuccessPayPackagesUserState(this.packagesUserModel);
}

class ErrorPayPackagesUserState extends HomeStates {
  final String error;
  ErrorPayPackagesUserState(this.error);
}


class LoadingCategoriesPartsState extends HomeStates {

}
class LoadingFilterCategoriesState extends HomeStates {

}

class SuccessFilterCategoriesPartsState extends HomeStates {
  final CategoriesDetailsModel categoriesPartsModel;
  SuccessFilterCategoriesPartsState(this.categoriesPartsModel);
}
class SuccessCategoriesPartsNewState extends HomeStates {
  final CategoriesDetailsModel categoriesPartsModel;
  SuccessCategoriesPartsNewState(this.categoriesPartsModel);
}

class ErrorCategoriesPartsState extends HomeStates {
  final String error;
  ErrorCategoriesPartsState(this.error);
}

class ErrorFilterCategoriesPartsState extends HomeStates {
  final String error;
  ErrorFilterCategoriesPartsState(this.error);
}

class LoadingDetailsProductState extends HomeStates {

}


class LoadingWithoutRefreshDetailsProductState extends HomeStates {

}

class SuccessDetailsProductState extends HomeStates {
  final DetailsProductModel detailsProductModel;
  SuccessDetailsProductState(this.detailsProductModel);
}



class SuccessDetailsBannerState extends HomeStates {
  final DetailsBannerModel detailsProductModel;
  SuccessDetailsBannerState(this.detailsProductModel);
}

class ErrorDetailsProductState extends HomeStates {
  final String error;
  ErrorDetailsProductState(this.error);
}



class LoadingGovernmentWithServicesState extends HomeStates {

}

class SuccessGovernmentWithServicesState extends HomeStates {
  final GovernmentWithServicesModel detailsProductModel;
  SuccessGovernmentWithServicesState(this.detailsProductModel);
}
class ErrorGovernmentWithServicesState extends HomeStates {
  final String error;
  ErrorGovernmentWithServicesState(this.error);
}
///PolicyTermsAppLinks
class LoadingPolicyTermsAppLinksState extends HomeStates {

}

class SuccessPolicyTermsAppLinksState extends HomeStates {
  final AppTermsPolicyLinksModel appTermsPolicyLinksModel;
  SuccessPolicyTermsAppLinksState(this.appTermsPolicyLinksModel);
}

class ErrorPolicyTermsAppLinksState extends HomeStates {
  final String error;
  ErrorPolicyTermsAppLinksState(this.error);
}


/// Delete Account
class LoadingDeleteAccountState extends HomeStates {

}

class SuccessDeleteAccountState extends HomeStates {
  final GeneralModel? generalModel;
  SuccessDeleteAccountState(this.generalModel);
}

class ErrorDeleteAccountState extends HomeStates {
  final String error;
  ErrorDeleteAccountState(this.error);
}

///CreateCouponsUsers
class LoadingCreateCouponsUsersState extends HomeStates {

}

class SuccessCreateCouponsUsersState extends HomeStates {
  final GeneralResult generalResult;
  SuccessCreateCouponsUsersState(this.generalResult);
}

class ErrorCreateCouponsUsersState extends HomeStates {
  final String error;
  ErrorCreateCouponsUsersState(this.error);
}


///LogOut
class LoadingLogoutState extends HomeStates {

}

class SuccessLogoutState extends HomeStates {
  final GeneralResult? generalResult;
  SuccessLogoutState(this.generalResult);
}

class ErrorLogoutState extends HomeStates {
  final String error;
  ErrorLogoutState(this.error);
}

class LoadingPayForAdsSpecialFeaturesState extends HomeStates {

}

class SuccessPayForAdsSpecialFeaturesState extends HomeStates {
  final GeneralModel? packageModel;
  SuccessPayForAdsSpecialFeaturesState(this.packageModel);
}
class ErrorPayForAdsSpecialFeaturesState extends HomeStates {
  final String? error;
  ErrorPayForAdsSpecialFeaturesState(this.error);
}






class LoadingStatusWhatsappStatusCompanyState extends HomeStates {

}

class SuccessStatusWhatsappStatusCompanyState extends HomeStates {
  final WhatsappCompanyStatusModel whatsappCompanyStatusModel;
  SuccessStatusWhatsappStatusCompanyState(this.whatsappCompanyStatusModel);
}

class ErrorStatusWhatsappStatusCompanyState extends HomeStates {
  final String error;
  ErrorStatusWhatsappStatusCompanyState(this.error);
}


///CreateCouponsUsers
class LoadingGetStatusCouponsUsersState extends HomeStates {

}

class SuccessGetStatusCouponsUsersState extends HomeStates {
  final CouponUserModel couponUserModel;
  SuccessGetStatusCouponsUsersState(this.couponUserModel);
}

class ErrorGetStatusCouponsUsersState extends HomeStates {
  final String error;
  ErrorGetStatusCouponsUsersState(this.error);
}



/// playNowRadio
class LoadingPlayNowRadioState extends HomeStates {

}

class SuccessPlayNowRadioState extends HomeStates {
  final PlayNowModel playNowModel;
  SuccessPlayNowRadioState(this.playNowModel);
}

class ErrorPlayNowRadioState extends HomeStates {
  final String error;
  ErrorPlayNowRadioState(this.error);
}

/// Get Status User
class LoadingGetStatusUserState extends HomeStates {

}

class SuccessGetStatusUserState extends HomeStates {
  final StatusUserResult statusUserResult;
  SuccessGetStatusUserState(this.statusUserResult);
}

class ErrorGetStatusUserState extends HomeStates {
  final String error;
  ErrorGetStatusUserState(this.error);
}

/// Get Status User
class LoadingCategoryMainAndSubCategoryState extends HomeStates {

}

class SuccessCategoryMainAndSubCategoryState extends HomeStates {
  final CategoriesAddPostModel categoriesAddPostModel;
  final CitiesModel citiesModel;
  SuccessCategoryMainAndSubCategoryState(this.categoriesAddPostModel,this.citiesModel);
}

class ErrorCategoryMainAndSubCategoryState extends HomeStates {
  final String error;
  ErrorCategoryMainAndSubCategoryState(this.error);
}




/// Get City app
class LoadingGetCityState extends HomeStates {

}

class SuccessGetCityState extends HomeStates {
  final CitiesModel citiesModel;
  SuccessGetCityState(this.citiesModel);
}

class ErrorGetCityState extends HomeStates {
  final String error;
  ErrorGetCityState(this.error);
}


/// get Section Setting
class LoadingGetSectionSettingState extends HomeStates {

}

class SuccessGetSectionSettingState extends HomeStates {
  final GetSectionModel getSectionModel;
  SuccessGetSectionSettingState(this.getSectionModel);
}

class ErrorGetSectionSettingState extends HomeStates {
  final String error;
  ErrorGetSectionSettingState(this.error);
}

class ChangeShowEditAdsState extends HomeStates {}

/// Add ad
class LoadingAddAdState extends HomeStates {}

class SuccessAddAdState extends HomeStates {
  final AddAdModel adModel;
  SuccessAddAdState(this.adModel);
}

class ErrorAddAdState extends HomeStates {
  final String error;
  ErrorAddAdState(this.error);
}
/// Send Message Support
class LoadingSendMessageSupportState extends HomeStates {

}

class SuccessSendMessageSupportState extends HomeStates {
  final GeneralResult generalResult;
  SuccessSendMessageSupportState(this.generalResult);
}

class ErrorSendMessageSupportState extends HomeStates {
  final String error;
  ErrorSendMessageSupportState(this.error);
}


class LoadingAdsEvaluationState extends HomeStates {

}

class SuccessAdsEvaluationState extends HomeStates {
  final HomePageModel adsEvaluationModel;
  SuccessAdsEvaluationState(this.adsEvaluationModel);
}

class ErrorAdsEvaluationState extends HomeStates {
  final String error;
  ErrorAdsEvaluationState(this.error);
}


class LoadingAdsRandomState extends HomeStates {

}

class SuccessAdsRandomState extends HomeStates {
  final HomePageModel adsRandomModel;
  SuccessAdsRandomState(this.adsRandomModel);
}

class ErrorAdsRandomState extends HomeStates {
  final String error;
  ErrorAdsRandomState(this.error);
}


class LoadingAllDataHomePageState extends HomeStates {

}


class LoadingWithoutRefreshAllDataHomePageState extends HomeStates {

}


class SuccessWeatherAppState extends HomeStates {

}

class SuccessAllDataHomePageState extends HomeStates {
  // final HomePageModel? adsRandomModel;
  final CategoriesAddPostModel? categoriesMainModel;
  final HomePageModel? homePageModel;
  SuccessAllDataHomePageState(
      {
        // this.adsRandomModel,
      this.homePageModel,
      this.categoriesMainModel,
      });
}


class SaveDataHomePageState extends HomeStates {
  HomePageLoginModel? dataHomePage;
  SaveDataHomePageState(this.dataHomePage);
}

class ErrorSaveDataHomePageState extends HomeStates {

  ErrorSaveDataHomePageState();
}
class ErrorAllDataHomePageState extends HomeStates {
  final String error;
  ErrorAllDataHomePageState(this.error);
}

class DarkModeStart extends HomeStates {

}
class DarkModeStop extends HomeStates {

}

/// Show Ads
class LoadingShowAdsState extends HomeStates {

}

class SuccessShowAdsState extends HomeStates {
  final ShowAdsModel showAdsModel;
  SuccessShowAdsState(this.showAdsModel);
}

class ErrorShowAdsState extends HomeStates {
  final String error;
  ErrorShowAdsState(this.error);
}



/// Favorites Ads
class LoadingEvaluateAdsState extends HomeStates {

}

class SuccessEvaluateAdsState extends HomeStates {
  final GeneralModel generalModel;
  SuccessEvaluateAdsState (this.generalModel);
}

class ErrorEvaluateAdsState extends HomeStates {
  final String error;
  ErrorEvaluateAdsState(this.error);
}


/// is Favorites Ads
class LoadingAdsIsFavoritesState extends HomeStates {

}

class SuccessAdsIsFavoritesState extends HomeStates {
  final HasFavoritesModel hasFavoritesModel;
  SuccessAdsIsFavoritesState (this.hasFavoritesModel);
}

class ErrorAdsIsFavoritesState extends HomeStates {
  final String error;
  ErrorAdsIsFavoritesState(this.error);
}

/// Favorites Ads
class LoadingAddAndRemoveAdsFromFavoritesState extends HomeStates {

}

class SuccessAddAndRemoveAdsFromFavoritesState extends HomeStates {
  final ShowAdsModel showAdsModel;
  SuccessAddAndRemoveAdsFromFavoritesState (this.showAdsModel);
}

class ErrorAddAndRemoveAdsFromFavoritesState extends HomeStates {
  final String error;
  ErrorAddAndRemoveAdsFromFavoritesState(this.error);
}


/// Ads Special Features

class LoadingAdsSpecialFeaturesState extends HomeStates {

}

class SuccessAdsSpecialFeaturesState extends HomeStates {
  final AdsSpecialFeaturesModel adsSpecialFeaturesModel;
  SuccessAdsSpecialFeaturesState(this.adsSpecialFeaturesModel);
}

class ErrorAdsSpecialFeaturesState extends HomeStates {
  final String error;
  ErrorAdsSpecialFeaturesState(this.error);
}


/// Add Ads Special Features

class LoadingAddAdsSpecialFeaturesState extends HomeStates {

}

class SuccessAddAdsSpecialFeaturesState extends HomeStates {
  final GeneralResult generalResult;
  SuccessAddAdsSpecialFeaturesState(this.generalResult);
}

class ErrorAddAdsSpecialFeaturesState extends HomeStates {
  final String error;
  ErrorAddAdsSpecialFeaturesState(this.error);
}


/// Edit Whatsapp Mobile

class LoadingEditWhatsappMobileState extends HomeStates {

}

class SuccessEditWhatsappMobileState extends HomeStates {
  final EditMobileNumberModel generalResult;
  SuccessEditWhatsappMobileState(this.generalResult);
}

class ErrorEditWhatsappMobileState extends HomeStates {
  final String error;
  ErrorEditWhatsappMobileState(this.error);
}


/// Edit Ads Info

class LoadingEditAdsInformationState extends HomeStates {

}

class SuccessEditAdsInformationState extends HomeStates {
  final EditAdsModel editAdsModel;
  SuccessEditAdsInformationState(this.editAdsModel);
}

class ErrorEditAdsInformationState extends HomeStates {
  final String error;
  ErrorEditAdsInformationState(this.error);
}


/// Delete Ads

class LoadingDeleteAdsState extends HomeStates {

}

class SuccessDeleteAdsState extends HomeStates {
  final GeneralResult generalResult;
  SuccessDeleteAdsState(this.generalResult);
}

class ErrorDeleteAdsState extends HomeStates {
  final String error;
  ErrorDeleteAdsState(this.error);
}

/// Active Chats For Ads

class LoadingActiveChatsForAdsState extends HomeStates {

}

class SuccessActiveChatsForAdsState extends HomeStates {
  final ShowAdsModel showAdsModel;
  SuccessActiveChatsForAdsState(this.showAdsModel);
}

class ErrorActiveChatsForAdsState extends HomeStates {
  final String error;
  ErrorActiveChatsForAdsState(this.error);
}


class ChangeVariableState extends HomeStates {}
class ChangeMobileNumberState extends HomeStates {}
class ChangeChatState extends HomeStates {}
class ChangeCouponState extends HomeStates {}