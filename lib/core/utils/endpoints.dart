class AppEndpoints {
  AppEndpoints._();
  // static const String starBaseUrl = "syria5";
  // static const String baseUrlWithoutApi = "https://www.syria5.com";
  // static const String deepLinksUrl= "https://syria5.com";
  // static const String baseUrlImageFirebase = "https://www.syria5.com";
  //https://syriansinuae.com/
  static const String starBaseUrl = "dashboard.lbeena";
  static const String baseUrlWithoutApi = "https://www.dashboard.lbeena.com";
  static const String deepLinksUrl= "https://www.dashboard.lbeena.com";
  static const String baseUrlImageFirebase = "https://www.dashboard.lbeena.com";
  static const String baseUrl = "$baseUrlWithoutApi/api/";
  static const auth = "mobile/auth";
  static const homePage = "home_page";
  static const homePageNew = "home_page_new";
  //https://syriansinuae.com/api/home_page_new/ar?page=1
  // static const companyInformation = "mobile/user/profile_company/";
  static const companyInformation = "mobile/user/profile_company_new/";
  static const packageCompany = "mobile/user/package_company";
  static const editProfileImages = "mobile/user/upload_image_company/";
  // static const infoMyCompany = "company/";
  static const infoMyCompany = "company_new/";
  static const companyInformationForAdvertisersAdmin = "mobile/user/profile_company_new/";
  static const companyInformationAbout = "mobile/user/about_profile_company/";
  static const companyDescription = "description_company/";
  static const editProfile = "mobile/user/profile_edit/";
  static const editCompanyInformation = "mobile/user/profile_company_edit";
  static const category = "mobile/categorie";
  // static const categoryNew = "mobile/category";
  static const categoryNew = "mobile/category_new";
  // static const filterSubcategoryUrl = "mobile/filter/subcategory";
  static const filterSubcategoryUrl = "mobile/filter/subcategory_new";
  static const categoryMain = "mobile/categories";
  // static String adsRandomUrl = "ads_random/";
  static String adsRandomUrl = "ads_random_new/";
  static String adsEvaluationUrl = "ads_evalution/";
  static String getSettingApp = "get_setting/";

  // receiveTimeout
  static const int receiveTimeout = 15000;
  // connectTimeout
  static const int connectionTimeout = 30000;
// to do

  /// AUTH API
  static String signupUrl = "$auth/signup";
  static String signupCompanyUrl = "$auth/companyRegister";
  static String transferUserToCompanyUrl = "$auth/user_to_company";
  static String loginUrl = "$auth/login";
  static String logoutUrl = "$auth/logout";
  static String resetPassword = "$auth/resetPassword";
  static String sendVerificationCode = "$auth/sendVerificationCode";
  static String validateMobileNumber = "$auth/validateMobileNumber";
  static String verifyPassword = "$auth/generate-token";
  static String activityCompanyUrl = "activity_company";

  ///Home Page API
  static String homePageUrl = "$homePage/";
  static String homePageNewUrl = "$homePageNew/";
  static String showAdsUrl = "mobile/ads/click";
  static String addAdUrl = "mobile/ads/store/ar";
  static String evaluateAdsUrl = "mobile/evaluate";
  static String activeChatsInAdsUrl = "mobile/active/";
  static String editMobileWhatsappForAdsUrl = "mobile/user/edit_ads_number/";
  static String idAdsSpecialFeatureUrl = "mobile/ad-special-features/store/";
  static String evaluateCompanyUrl = "mobile/evaluate_company";
  static String isFavoriteAdsUrl = "mobile/my/favorite/";
  static String favoriteAdsUrl = "mobile/add/to/favorite/";
  static String getCustomerLuckUrl = "get_customer_luck";
  // static String searchUrl = "mobile/search/ads";
  static String searchUrl = "search_ads";
  static String removeDeviceToken = "remove_token";
  static String categoriesUrl = "$category/";
  static String categoryMainUrl = "$categoryMain/";
  static String categoryMainForAddAdsUrl = "mobile/main_categories/";
  static String adsSpecialFeaturesUrl = "mobile/ad-special-features/";
  static String addAdsUrl = "mobile/ads/store/";
  // static String detailsProductUrl = "product/";
  static String detailsProductUrl = "product_new/";
  static String governmentWithServicesUrl = "goverment_with_services";
  // static String detailsBannerUrl = "banner/";
  static String detailsBannerUrl = "banner_new/";
  static String getSectionUrl = "get_section/";
  static String serviceUrl = "all_services_team";
  /// Ugc
  static String subscribeToUgcUrl = "mobile/user/ugc/store";
  static String ugcCategoryUrl = "mobile/user/ugc_category/get";
  static String searchUgcUsersUrl = "mobile/user/ugc/filter";
  static String ugcUsersUrl = "mobile/user/ugc/get";
  /// Events
  static String socialMediaEffectivenessUrl = "social-media-effectiveness";
  static String calenderUrl = "get-holiday-by-country";
  static String effectivenessUrl = "effectiveness";

  ///Cart&Orders
  static String addToCartUrl = "cart/add";
  static String getMyCartUrl = "cart/get";
  static String getMyOrderUrl = "order/get";
  static String getSearchMyOrderUrl = "order/search";
  static String getMyOrderCompanyUrl = "order/get_orders_company";
  static String removeItemFromCartUrl = "cart/remove";
  static String deleteItemCartUrl = "cart/item/";
  static String changeStatusOrderUrl = "orders/";
  static String createOrderUrl = "order/create";

  ///Store

  // static String adsStoreUrl = "ads_store/ar?";
  static String adsStoreUrl = "ads_store_new/ar?";
  //
  // static String listCompanyUrl = "mobile/list_company/";
  static String listCompanyUrl = "mobile/list_company_new/";
  // static String searchListCompanyUrl = "mobile/search_list_company/";
  static String searchListCompanyUrl = "mobile/search_list_company_new/";

  static String allCategories = category;


}
