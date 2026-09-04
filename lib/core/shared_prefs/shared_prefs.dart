import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syrians_in_uae/ui/screens/auth/login/model_home_page.dart';
import 'package:syrians_in_uae/ui/screens/community/community.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/components.dart';
import '../constants/app_consts.dart';


class SharedPrefs {
  // Create storage
  final storage = new FlutterSecureStorage();

//  final isGuest = ReadWriteValue('isGuest${AppConst.appName}', false);
  final isFirstLaunch =
      ReadWriteValue('isFirstLaunch${AppConsts.appName}', true);
  final appLanguageCode =
      ReadWriteValue('appLanguageCode${AppConsts.appName}', AppConsts.LANG_AR);
  final firstLaunch = ReadWriteValue('firstLaunch${AppConsts.appName}', true);

  final appMode = ReadWriteValue('appMode${AppConsts.appName}', "light");

  ReadWriteValue appAuth =
      ReadWriteValue('appAuth${AppConsts.appName}', null);
  ReadWriteValue<String?> yourLocation =
  ReadWriteValue('yourLocation${AppConsts.appName}', null);
  ReadWriteValue<String?> appToken =
      ReadWriteValue('appToken${AppConsts.appName}', null);
//isUgc
  ReadWriteValue<bool> isUgc =
  ReadWriteValue('isUgc${AppConsts.appName}', false);
  ReadWriteValue<String> yourCountry =
  ReadWriteValue('yourCountry${AppConsts.appName}', 'دمشق');
  ReadWriteValue<String?> statusUser =
  ReadWriteValue('statusUser${AppConsts.appName}', null);
  ReadWriteValue<String?> passwordToken =
      ReadWriteValue('passwordToken${AppConsts.appName}', null);
  ReadWriteValue<bool?> isFirst =
      ReadWriteValue('isFirst${AppConsts.appName}', true);
  ReadWriteValue<String?> fcmToken =
      ReadWriteValue('fcmToken${AppConsts.appName}', null);
  ReadWriteValue<String?> readMessage =
  ReadWriteValue('readMessage${AppConsts.appName}', null);
  ReadWriteValue<String?> deviceToken =
      ReadWriteValue('deviceToken${AppConsts.appName}', null);
  ReadWriteValue<String?> deviceType =
      ReadWriteValue('deviceType${AppConsts.appName}', null);



  ReadWriteValue<bool> subscribeToNotification =
  ReadWriteValue('subscribeToNotification${AppConsts.appName}', true);
  ReadWriteValue<String?> appRefreshToken =
      ReadWriteValue('appRefreshToken${AppConsts.appName}', null);
  ReadWriteValue<String?> userID =
      ReadWriteValue('userID${AppConsts.appName}', null);
  //
  // ReadWriteValue<HomePageLoginModel?> dataHomePage =
  // ReadWriteValue('HomePageLoginModel${AppConsts.appName}', null);

  ReadWriteValue<String?> profilePic =
  ReadWriteValue('profile_pic${AppConsts.appName}', null);

  ReadWriteValue<String?> createdAd =
  ReadWriteValue('createdAd${AppConsts.appName}', null);

  ReadWriteValue<String?> joinedAd =
  ReadWriteValue('joinedAd${AppConsts.appName}', null);

  ReadWriteValue<String?> ratingUser =
  ReadWriteValue('ratingUser${AppConsts.appName}', null);

  ReadWriteValue<String?> userNamePerson =
      ReadWriteValue('user_name${AppConsts.appName}', null);
  ReadWriteValue<String?> yourEmail =
  ReadWriteValue('yourEmail${AppConsts.appName}', null);
  ReadWriteValue<String?> accountType =
  ReadWriteValue('accountType${AppConsts.appName}', null);

  ReadWriteValue<String?> mobileNumber =
  ReadWriteValue('mobileNumber${AppConsts.appName}', null);

  ReadWriteValue<String?> appLink =
  ReadWriteValue('appLink${AppConsts.appName}', null);

  ReadWriteValue<String?> policyLink =
  ReadWriteValue('policyLink${AppConsts.appName}', null);

  ReadWriteValue<String?> termsLink =
  ReadWriteValue('termsLink${AppConsts.appName}', null);


  ReadWriteValue<String?> faqLink =
  ReadWriteValue('faqLink${AppConsts.appName}', null);

  ReadWriteValue<String?> safetyLink =
  ReadWriteValue('safetyLink${AppConsts.appName}', null);

  ReadWriteValue<int?> counterNotifications =
  ReadWriteValue('counterNotifications${AppConsts.appName}', null);


  ReadWriteValue<String?> membershipNumber =
  ReadWriteValue('membershipNumber${AppConsts.appName}', null);


  ReadWriteValue<int?> createUserAd =
  ReadWriteValue('createUserAd${AppConsts.appName}', null);


  ReadWriteValue<int?> allowChats =
  ReadWriteValue('allowChats${AppConsts.appName}', null);


  ReadWriteValue<String> fontType =
  ReadWriteValue('fontType${AppConsts.appName}', 'Janna');


  ReadWriteValue<int?> isBlocked =
  ReadWriteValue('isBlock${AppConsts.appName}', null);



  ReadWriteValue<int?> isPermissionChat =
  ReadWriteValue('isPermissionChat${AppConsts.appName}', null);


  ReadWriteValue<String?> userNameCompany =
  ReadWriteValue('userNameCompany${AppConsts.appName}', null);


  ReadWriteValue<int?> isAllowVoice =
  ReadWriteValue('isAllowVoice${AppConsts.appName}', null);


  ReadWriteValue<int?> timeVoice =
  ReadWriteValue('timeVoice${AppConsts.appName}', null);
  ReadWriteValue<String?> companyIsActive =
  ReadWriteValue('companyIsActive${AppConsts.appName}', null);
  ReadWriteValue<String?> userNamePerson2 =
  ReadWriteValue('user_name2${AppConsts.appName}', null);
  /*
  primaryColorApp.val = colorWithoutHashtag(color1);
    secondaryColorApp.val =  colorWithoutHashtag(color2);
    thirdColorApp.val =  colorWithoutHashtag(color3);
   */
  ReadWriteValue<String?> primaryColorApp =
  ReadWriteValue('primaryColorApp${AppConsts.appName}', null);


  ReadWriteValue<String?> setStatusUserChatsApp =  ReadWriteValue('setStatusUserChatsApp${AppConsts.appName}', null);
  ReadWriteValue<String?> secondaryColorApp =
  ReadWriteValue('secondaryColorApp${AppConsts.appName}', null);


  ReadWriteValue<String?> thirdColorApp =
  ReadWriteValue('thirdColorApp${AppConsts.appName}', null);
  ReadWriteValue<String?> notificationStatus =
      ReadWriteValue('notificationStatus${AppConsts.appName}', null);
  ReadWriteValue<String?> imageProfile =
      ReadWriteValue('imageProfile${AppConsts.appName}', null);
  ReadWriteValue<bool?> appEnableDisableTouchId =
      ReadWriteValue('appEnableDisableTouchId${AppConsts.appName}', null);
  ReadWriteValue<String?> lang =
  ReadWriteValue('lang${AppConsts.appName}', null);

  ReadWriteValue<double?> myLocationLat =
  ReadWriteValue('myLocationLat${AppConsts.appName}', null);

  ReadWriteValue<List?> listFortuneWheel =
  ReadWriteValue('listFortuneWheel${AppConsts.appName}', null);

  ReadWriteValue<double?> myLocationLang =
  ReadWriteValue('myLocationLang${AppConsts.appName}', null);

  ReadWriteValue<List?> listFortuneCustomerId =
  ReadWriteValue('listFortuneCustomerId${AppConsts.appName}', null);

  ReadWriteValue<bool?> appEnableDisablePin =
      ReadWriteValue('appEnableDisablePin${AppConsts.appName}', null);

  ReadWriteValue<String?> themeApp =
  ReadWriteValue('themeApp${AppConsts.appName}', null);
  // LoginModeEnum getLoginMode() => LoginModeEnum.values[_loginMode.val];

  // void setLoginMode(LoginModeEnum mode) {
  //   _loginMode.val = mode.index;
  // }

  void logout() {
    // setEmployeeMode(EmployeeModesEnum.NONE);
    // setLoginMode(LoginModeEnum.NONE);
    // setAuth(null);
    setToken(null);
    setRefreshToken(null);
    setImageProfile(null);
    setNotificationsStatus(null);
    setIsFirst(false);
    //GlobalNotification.instance.deleteFCMToken();
  }

  // EmployeeModesEnum getEmployeeMode() =>
  //     EmployeeModesEnum.values[_employeeMode.val];
  //
  // void setEmployeeMode(EmployeeModesEnum mode) {
  //   _employeeMode.val = mode.index;
  // }

  void setListFortuneCustomerId(List newValue) {
    listFortuneCustomerId.val = newValue;
  }
  Future<void> setAuthForBiometric(
      String org, String userName, String pass) async {
    // Write value
    await storage.write(key: 'appSelectedOrg${AppConsts.appName}', value: org);
    await storage.write(
        key: 'appUserName${AppConsts.appName}', value: userName);
    await storage.write(key: 'appPassword${AppConsts.appName}', value: pass);
  }

  void setListFortuneWheel(List newValue) {
    listFortuneWheel.val = newValue;
  }

  List? getListFortuneWheel() {
    return listFortuneWheel.val ??["Mahmoud","Ali","Raghad"];
  }
  List? getListFortuneCustomerId() {
    return listFortuneCustomerId.val ??[];
  }

  bool getSubscribeToNotification() {
    return subscribeToNotification.val;
  }
  void setSubscribeToNotification(bool newValue) {
    subscribeToNotification.val = newValue;
  }
  Future<void> setAuthForPin(String pin) async {
    // Write value
    await storage.write(key: 'appSelectedPin${AppConsts.appName}', value: pin);
  }

  void setEnableDisablePin(bool enableDisablePin) {
    appEnableDisablePin.val = enableDisablePin;
  }

  void setThemeApp(String theme) {
    themeApp.val = theme;
  }

   getThemeApp() {
   return  themeApp.val ;
  }

  void setEnableDisableTouchId(bool enableDisableTouchId) {
    appEnableDisableTouchId.val = enableDisableTouchId;
  }
  void setMyLocationLat(double? locationlat){
    myLocationLat.val = locationlat;
  }

  void setMyLocationLang(double? locationlang){
    myLocationLang.val = locationlang;
  }

  bool? hasEnableDisableTouchId() {
    return appEnableDisableTouchId.val;
  }

  bool? hasEnableDisablePin() {
    return appEnableDisablePin.val;
  }

  Future<String?> getOrg() async {
    // Read value
    String? value =
        await storage.read(key: 'appSelectedOrg${AppConsts.appName}');
    if (value != null) {
      return value;
    } else {
      return null;
    }
  }

 String? getUserName() {
 return userNamePerson.val;
  }

  double? getMyLocationLat() {
    return myLocationLat.val;
  }

  double? getMyLocationLang() {
    return myLocationLang.val;
  }

  Future<String?> getPass() async {
    // Read value
    String? value = await storage.read(key: 'appPassword${AppConsts.appName}');
    if (value != null) {
      return value;
    } else {
      return null;
    }
  }

  Future<String?> getPinCode() async {
    // Read value
    String? value =
        await storage.read(key: 'appSelectedPin${AppConsts.appName}');
    if (value != null) {
      return value;
    } else {
      return null;
    }
  }

  Future<bool> hasBiometricAuth() async {
    if (await getOrg() != null &&
        await getUserName() != null &&
        await getPass() != null) {
      return true;
    } else {
      return false;
    }
  }

  // void setAuth(AuthenticateModel? authenticateModel) {
  //   appAuth.val = authenticateModel;
  //   appToken.val = authenticateModel?.accessToken;
  //   appRefreshToken.val = authenticateModel?.refreshToken;
  // }

  setToken(String? token) {
    // print("SetToken : $token");
    appToken.val = token;
  }
  setStatusUGC(bool newValue) {
    isUgc.val = newValue;
  }
  getStatusUGC() {
    return isUgc.val ;
  }
  setYourCountry(String newValue) {
    // print("SetToken : $token");
    yourCountry.val = newValue;
  }
  getYourCountry() {
    return yourCountry.val ;
  }
  setCounterNotifications(int? counter) {
    // print("SetToken : $counter");
    counterNotifications.val = counter;
  }

  getMembershipNumber() {
    return membershipNumber.val ;
  }
  setMembershipNumber(String? value) {
    // print("SetToken : $counter");
    membershipNumber.val = value;
  }


//isPermissionChat
  setIsPermissionChatGroup(int? isAllow) {
    // print("SetToken : $counter");
    isPermissionChat.val = isAllow;
  }
  setAllowUserCreateAd(int? isAllow) {
    // print("SetToken : $counter");
    createUserAd.val = isAllow;
  }


  setUserIsBlocked(int? status) {
    // print("SetToken : $counter");
    isBlocked.val = status;
  }



  setAllowUserChatsInCommunity(int? isAllow) {
    // print("SetToken : $counter");
    allowChats.val = isAllow;
  }

  setFontType(String value) {
    // print("SetToken : $counter");
    fontType.val = value;
  }


  getFontType() {
    // return fontType.val ;
    return 'Janna' ;
  }
  setColorsApp({
    required String color1,
    required String color2,
    required String color3,
}) {
    // Brand colors come from the Lbeena logo, not the backend.
  }

  getBackGroundColorApp() {
    return 'F3F6F6';
  }
  getMainColorApp() {
    return '1F6B66';
  }
  getThirdColorApp() {
    return 'F58220';
  }

  getIfUsersCanCreateAd() {
    return createUserAd.val ;
  }

  getIfUsersPermissionChatGroup() {
    return isPermissionChat.val ;
  }

  getStatusUserIsBlocked() {
    return isBlocked.val ;
  }

  getIfUsersCanChatsCommunity() {
    return allowChats.val ;
  }

  //statusUser

  setAccountType(String? accountType2) {
    // print("SetToken : $accountType2");
    accountType.val = accountType2;
  }


  setMobileNumber(String? mobileNumber2) {
    // print("mobileNumber : $mobileNumber2");
    mobileNumber.val = mobileNumber2;
  }

  setUserNameCompany(String? userNameCompany2) {
    // print("userNameCompany : $userNameCompany2");
    userNameCompany.val = userNameCompany2;
  }


  setIsAllowVoice(int? isAllow) {
    isAllowVoice.val = isAllow ??0;
  }
  setTimeVoice(int? timeVoiceNew) {
    timeVoice.val = timeVoiceNew ??1;
  }

  setCompanyIsActive(String? companyIsActive2) {
    companyIsActive.val = companyIsActive2;
  }


  setUserInformation({
    required String? companyIsActive2,
    required String? userNameCompany2,
    required String? mobileNumber2,
    required String? accountType2,
    required String? token,
    required String? status,
    required String? imageProfile2,
    required int? userID2,
    required String? userNamePerson2,
    required String? createdAd2,
    required String? joinedAd2,
    required String? ratingUser2,
    required String? membershipNumberValue,
}) {
    userID.val = userID2.toString();
    companyIsActive.val = companyIsActive2;
    userNameCompany.val = userNameCompany2;
    mobileNumber.val = mobileNumber2;
    accountType.val = accountType2;
    appToken.val = token;
    statusUser.val = status;
    imageProfile.val = imageProfile2;
    userNamePerson.val = userNamePerson2;
    createdAd.val = createdAd2;
    joinedAd.val = joinedAd2;
    ratingUser.val = ratingUser2;
    membershipNumber.val = membershipNumberValue;

  }
  String? getRatingUser() {
    return ratingUser.val;
  }
  String? getMobileNumber() {
    return mobileNumber.val;
  }
  String? getUserNameCompany() {
    return userNameCompany.val;
  }
  String? getCompanyIsActive() {
    return companyIsActive.val;
  }

  int? getCounterNotifications() {
    return counterNotifications.val;
  }

  //ReadWriteValue<String?> mobileNumber =
  //   ReadWriteValue('mobileNumber${AppConsts.appName}', null);
  //   ReadWriteValue<String?> userNameCompany =
  //   ReadWriteValue('userNameCompany${AppConsts.appName}', null);
  //   ReadWriteValue<String?> companyIsActive =
  //   ReadWriteValue('companyIsActive${AppConsts.appName}', null);


  setStatusUser(String? status) {
    // print("SetStatus : $status");
    statusUser.val = status;
  }

  //StatusUser

 String? getStatusUser() {
   return statusUser.val;
  }

  String? getAccountType(){
    return accountType.val;
  }
  String? getCreateAt(){
    return createdAd.val;
  }
  String? getJoinAt(){
    return joinedAd.val;
  }
  String getLang(){
    return lang.val ??'ar';
  }


  int getTimeVoice(){
    return timeVoice.val ??1;
  }


  int getIsAllowVoice(){
    return isAllowVoice.val ??0;
  }

  setLang(String? lang2) {
    // print("lang : $lang2");
    lang.val = lang2;
  }
  setLinks({
     String? appLink2,
     String? policyLink2,
     String? termsLink2,
     String? faqLink2,
     String? safetyLink2,
  }) {

    termsLink.val = termsLink2;
    policyLink.val = policyLink2;
    appLink.val = appLink2;
    faqLink.val = faqLink2;
    safetyLink.val = safetyLink2;
  }

  String? getSafetyLink(){
    return safetyLink.val;
  }
  String? getFaqLink(){
    return faqLink.val;
  }

  String? getAppLink(){
    return appLink.val;
  }

  String? getStatusUserChats(){
    return setStatusUserChatsApp.val;
  }

  String? getTermsLink(){
    return termsLink.val;
  }

  String? getPolicyLink(){
    return policyLink.val;
  }


  setPasswordToken(String? PasswordToken) {
    passwordToken.val = PasswordToken;
  }

  setIsFirst(bool isFirst) {
    this.isFirst.val = isFirst;
  }

  setUserID(int? userId) {
    print('user id:  $userId');
    userID.val = userId.toString();
  }





  setUserNamePerson(String? firstName) {
    userNamePerson.val = firstName.toString();
  }

  setYourEmail(String? setYourEmail) {
    yourEmail.val = setYourEmail.toString();
  }


  setUserNamePerson2(String? lastName) {
    userNamePerson2.val = lastName.toString();
  }

  setImageProfile(String? image) {
    imageProfile.val = image.toString();
  }

  setNotificationsStatus(String? statues) {
    notificationStatus.val = statues.toString();
  }

  setFCMToken(String? token) {
    fcmToken.val = token;
  }

  setDeviceToken(String? token) {
    deviceToken.val = token;
  }

  setReadMessageStatus(String? readMessageNew) {
     readMessage.val =readMessageNew;
  }


  setStatusUserChats(String? setStatusUserNew) {
    setStatusUserChatsApp.val =setStatusUserNew;
  }

  setDeviceType(String? type) {
    deviceType.val = type;
  }

  setRefreshToken(String? token) {
    appRefreshToken.val = token;
  }

  // AuthenticateModel? getAuth() {
  //   if (!(appAuth.val?.isBlank ?? true)) {
  //     return appAuth.val;
  //   } else {
  //     return null;
  //   }
  // }

  String? getToken() {
     return appToken.val;
  }


  String? getPasswordToken() {
    return passwordToken.val;
  }

  bool? getIsFirst() {
    return isFirst.val;
  }


 String? getEmail(){
    return yourEmail.val;
  }
  String? getImageProfile() {
    return imageProfile.val;
  }

  String? getNotificationStatus() {
    return notificationStatus.val;
  }

  String? getUserID() {
    return userID.val;
  }

  String? getReadMessageStatus() {
    return readMessage.val;
  }

  String? getUserNamePerson() {
    return userNamePerson.val;
  }


  String? getUserNamePerson2() {
    return userNamePerson2.val;
  }

  String? getFCMToken() {
    return fcmToken.val;
  }

  String? getDeviceToken() {
    return deviceToken.val;
  }

  String? getDeviceType() {
    return deviceType.val;
  }

  String? getRefreshToken() {
    return appRefreshToken.val;
  }

  /// ---------------------------------- Post views (user views) ----------------------------------
  ReadWriteValue<String> _viewedPosts =
      ReadWriteValue('viewedPosts${AppConsts.appName}', '');

  List<String> get viewedPostIds => _viewedPosts.val.split(':');

  void setPostViewed(int postId) {
    print('setPostViewed .....');
    _viewedPosts.val = '${_viewedPosts.val}${postId.toString()}:';
  }

  bool isPostViewed(int postId) {
    print('viewedPostIds $viewedPostIds');
    print('viewedPostIds ${viewedPostIds.length}');
    return viewedPostIds.contains(postId.toString());
  }
// ------------------------------------------------------------------------------------------------
}
