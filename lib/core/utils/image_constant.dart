import '../di/di_manager.dart';
import '../shared_prefs/shared_prefs.dart';

class ImageConstant {
  // Image folder path
  static String imagePath = 'assets/images';
  static String iconsPath = 'assets/images/icons';

  // Login images
  static String imgGroup12 = '$imagePath/background_auth.svg';
  static String imgFrame = '$imagePath/background_auth_image.svg';
  static String imgCompanyD = '$imagePath/person_company.jpg';
  static String imgInternetNotHave = '$imagePath/not_have_internet_in_app.jpg';
  static String imgAppBar = '$imagePath/app_bar_app.svg';
  static String imgAppBarMain = '$imagePath/app_bar_main_app.svg';
  static String imgBackCoupons = '$imagePath/background_coupons.png';
  static String imgHomePage = '$imagePath/home_page_icons.svg';
  static String imgBackCouponsGray = '$imagePath/background_coupons_gray.png';
  // static String imgLogoApp = '$imagePath/logo_app.png';
  static String imgLogoApp = '$imagePath/logo_lbeena_light.png';
  static String imgLogoAppSplashScreen = '$imagePath/logo_lbeena_dark.png';
  // static String imgLogoAppSplashScreen = '$imagePath/logo_app.png';
  static String imgEdit = '$imagePath/pin_edit.svg';
  static String iconInformation = '$imagePath/information_icons.svg';
  static String mainIcons = '$imagePath/main_icons.svg';
  static String imgPackage = '$imagePath/package_icon.svg';
  static String imgPackageAccount = '$imagePath/background_account.png';
  static String imgShare = '$imagePath/share_icons.svg';
  static String videoICon = '$imagePath/video_icons.svg';
  static String iconVisa= '$imagePath/visa_icons.png';
  static String imgSettings = '$imagePath/person_user.svg';
  static String imgNotification = '$imagePath/notification_icons.svg';
  static String notificationSettingIcon = '$iconsPath/notification_setting_icon.svg';
  static String imgSearchDeepPurpleA10001 = '$imagePath/search_icons.svg';
  static String imgLinkedin = '$imagePath/locations_icons.svg';
  static String imgTelevision = '$imagePath/uae_icons.svg';
  static String imgMinimize = '$imagePath/phone_icons.svg';
  static String imgTrue = '$imagePath/true_icons.svg';
  static String imgPerson = '$imagePath/person_user.svg';
  static String imgAgain = '$imagePath/again_icons.svg';
  static String imgLocation = '$imagePath/lock_icons.svg';
  static String imgChats = '$imagePath/chats_icons.svg';
  static String imgCoupons = '$imagePath/coupons_icons.svg';
  static String imgSetting = '$imagePath/setting_icon_app.svg';
  static String imgEnglishLang = '$imagePath/english_icons.png';
  static String imgPDF = '$imagePath/pdf_icons.png';
  static String imageNotFound = 'assets/images/image_not_found_app.png';
  static String photoNotification2 = '$imagePath/photo_notification_app.svg';
  // static String aladhanTimeIcon = '$imagePath/aladhan.jpeg';
  static String aladhanTimeIcon = '$imagePath/aladhan_icon.jpg';
  static String aladhanTimeIcon2 = '$imagePath/aladhan_icon2.jpg';
  static String community = '$imagePath/community.svg';
  static String pinIcon = '$imagePath/pin.png';
  static String groupImage = '$imagePath/group_image.png';
  static String ugcImage = '$imagePath/ugc.png';
  static String logoApp = DIManager.findDep<SharedPrefs>().getThemeApp() == 'd'?'$imagePath/logo_lbeena_dark.png':'$imagePath/logo_lbeena_light.png';
  static String logoAppWhite = '$imagePath/logo_lbeena_dark.png';
  static String logoAppbar = '$imagePath/logo_lbeena_light.png';
  static String logoAppbarWhite = '$imagePath/logo_lbeena_dark.png';
  static String splashScreen = '$imagePath/logo_lbeena_light.png';
  static String splashScreenWhite = '$imagePath/logo_lbeena_dark.png';
  static String backgroundUser = '$imagePath/background_user.png';
  static String companiesIcon = '$imagePath/companies_icon.svg';
  ///Icons
  static String iconArrow = '$iconsPath/icon_arrow_app.svg';
  static String iconArrowEnglish = '$iconsPath/icon_arrow_english_app.svg';
  static String iconChangeStateDark = '$iconsPath/icon_change_state_app.svg';
  static String iconConnection = '$iconsPath/icon_connection_app.svg';
  static String iconDelete = '$iconsPath/icon_delete_app.svg';
  static String iconLogout = '$iconsPath/icon_logout_app.svg';
  static String iconPolicy = '$iconsPath/icon_policy_app.svg';
  static String priceIcon = '$iconsPath/price_icon.svg';
  static String termsIcon = '$iconsPath/terms_icon.svg';
  static String privacyIcon = '$iconsPath/privacy_icon.svg';
  static String iconReplace = '$iconsPath/icon_replace_app.svg';
  static String currencies = '$iconsPath/currencies.png';
  static String iconWorld = '$iconsPath/icon_world_app.svg';
  static String linkIcon = '$iconsPath/link_icon.png';
  static String iconWhatsapp = '$iconsPath/icon_whatsapp_app.svg';
  static String iconEyes = '$iconsPath/icon_eyes_app.svg';
  static String iconQuestion = '$iconsPath/icon_question_app.svg';
  static String iconCondition = '$iconsPath/icon_condition_app.svg';
  static String iconAdvice = '$iconsPath/icon_advice_app.svg';
  static String iconTrue = '$iconsPath/icon_true_app.svg';
  static String iconList = '$iconsPath/icons_list_app.svg';
  // static String likeIcon = "$iconsPath/like.svg";
  static String unlikeIcon = "$iconsPath/unlike.png";
  static String likeIcon = "$iconsPath/like.png";
  static String headphone = "$iconsPath/radio_icon.svg";
  static String chatPost = "$iconsPath/chat_post.svg";
  static String editIcon = "$iconsPath/edit_icon.png";
  static String deleteIcon = "$iconsPath/delete_icon.png";
  static String reminderIcon2 = "$iconsPath/reminder_icon.svg";
  static String archiveIcon = "$iconsPath/archive.svg";
  static String bellIcon = "$iconsPath/bell.gif";
  static String radioIcon = "$iconsPath/radio_icon.svg";
  static String pinIconNew1= "$iconsPath/pin_icon1.png";
  static String ugcIcon= "$iconsPath/ugc_icon.svg";

  static String cart = "$iconsPath/cart_icon.svg";
  static String favoriteIcon = "$iconsPath/favorite_icon.svg";
  static String wheelFortune = "$iconsPath/wheel_fortune.png";
  static String adIcon = "$iconsPath/ad_icon.png";
  static String relationsIcon = "$iconsPath/relations_icon.png";
  static String couponIcon = "$iconsPath/coupon_icon.png";
  static String enterpriseIcon = "$iconsPath/enterprise_icon.png";
  static String eventsIcon = "$iconsPath/events_icon.png";
  static String pngwingIcon = "$iconsPath/pngwing_icon.svg";

  static String checkOut = "$iconsPath/check_out.svg";
  static String storeIcon = "$iconsPath/store_icon.svg";
  ///Main Category
  static String communityIcon = "$iconsPath/community_icon.svg";
  static String eventsNewIcon = "$iconsPath/events_icon.svg";
  static String offerIcon = "$iconsPath/offer_icon.svg";
  static String syrianIcon = "$iconsPath/syrian_icon.svg";
  static String calendarIcon = "$iconsPath/calendar.svg";
  static String jobsIcons = "$iconsPath/jobs_icons.svg";
  static String adsIcons = "$iconsPath/ads_icons.svg";
  ///Social Media
  static String facebookIcon = "$iconsPath/facebook_icon.png";
  static String gpsIcon = "$iconsPath/gps.png";
  static String instagramIcon = "$iconsPath/instagram_icon.png";
  static String tiktokIcon = "$iconsPath/tiktok_icon.png";
  static String webIcon = "$iconsPath/web_icon.png";
  static String starIcon = "$iconsPath/star.svg";
  static String shareIcon = "$iconsPath/share_icon.svg";
  static String femaleIcon = "$iconsPath/famel_icon.svg";
  static String locationIcon = "$iconsPath/location_icon.svg";
  static String maleIcon = "$iconsPath/male_icon.svg";

  // famel_icon.svg
  // location_icon.svg
  // male_icon.svg

}
