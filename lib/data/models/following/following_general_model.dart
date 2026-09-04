class FollowingGeneralModel {
  FollowingGeneralModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final List<FollowingList> data;

  factory FollowingGeneralModel.fromJson(Map<String, dynamic> json){
    return FollowingGeneralModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<FollowingList>.from(json["data"]!.map((x) => FollowingList.fromJson(x))),
    );
  }

}

class FollowingList {
  FollowingList({
    required this.id,
    required this.roleId,
    required this.email,
    required this.confirmPassword,
    required this.lastLogin,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.cityId,
    required this.fullMobileNumber,
    required this.isMobileVerified,
    required this.profilePic,
    required this.advertiserPerecent,
    required this.accountType,
    required this.registrationWebsite,
    required this.userImage,
    required this.googleProviderId,
    required this.facebookProviderId,
    required this.twitterProviderId,
    required this.linkedinProviderId,
    required this.appleProviderId,
    required this.about,
    required this.isActive,
    required this.isPasswordWeak,
    required this.address,
    required this.note,
    required this.notificationStatus,
    required this.verificationCode,
    required this.emailVerifiedAt,
    required this.rememberToken,
    required this.verificationLink,
    required this.platformKind,
    required this.platformId,
    required this.country,
    required this.marketingCompanyCode,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.status,
    required this.loginToken,
    required this.mainId,
    required this.companyName,
    required this.companyLogo,
    required this.longitude,
    required this.latitude,
    required this.kind,
    required this.gender,
    required this.isShownEmail,
    required this.isShownMobile,
    required this.isAcceptTerms,
    required this.actionId,
    required this.isAccept,
    required this.isDelete,
    required this.isOrginUser,
    required this.isBlocked,
    required this.defaultPackage,
    required this.businessActivityId,
    required this.isAllowVoice,
    required this.allowVoiceTime,
    required this.businessActivityIdNew,
    required this.isPermissionChat,
    required this.pivot,
  });

  final int? id;
  final dynamic roleId;
  final String? email;
  final String? confirmPassword;
  final dynamic lastLogin;
  final dynamic userName;
  final dynamic firstName;
  final dynamic lastName;
  final String? mobile;
  final dynamic cityId;
  final dynamic fullMobileNumber;
  final int? isMobileVerified;
  final String? profilePic;
  final dynamic advertiserPerecent;
  final String? accountType;
  final dynamic registrationWebsite;
  final dynamic userImage;
  final dynamic googleProviderId;
  final dynamic facebookProviderId;
  final dynamic twitterProviderId;
  final dynamic linkedinProviderId;
  final dynamic appleProviderId;
  final dynamic about;
  final int? isActive;
  final int? isPasswordWeak;
  final dynamic address;
  final dynamic note;
  final String? notificationStatus;
  final dynamic verificationCode;
  final dynamic emailVerifiedAt;
  final dynamic rememberToken;
  final dynamic verificationLink;
  final String? platformKind;
  final dynamic platformId;
  final String? country;
  final dynamic marketingCompanyCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? status;
  final dynamic loginToken;
  final dynamic mainId;
  final String? companyName;
  final dynamic companyLogo;
  final dynamic longitude;
  final dynamic latitude;
  final String? kind;
  final dynamic gender;
  final int? isShownEmail;
  final int? isShownMobile;
  final int? isAcceptTerms;
  final int? actionId;
  final int? isAccept;
  final int? isDelete;
  final int? isOrginUser;
  final int? isBlocked;
  final int? defaultPackage;
  final int? businessActivityId;
  final int? isAllowVoice;
  final dynamic allowVoiceTime;
  final dynamic businessActivityIdNew;
  final int? isPermissionChat;
  final Pivot? pivot;

  factory FollowingList.fromJson(Map<String, dynamic> json){
    return FollowingList(
      id: json["id"],
      roleId: json["role_id"],
      email: json["email"],
      confirmPassword: json["confirm_password"],
      lastLogin: json["last_login"],
      userName: json["user_name"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      mobile: json["mobile"],
      cityId: json["city_id"],
      fullMobileNumber: json["full_mobile_number"],
      isMobileVerified: json["is_mobile_verified"],
      profilePic: json["profile_pic"],
      advertiserPerecent: json["advertiser_perecent"],
      accountType: json["account_type"],
      registrationWebsite: json["registration_website"],
      userImage: json["user_image"],
      googleProviderId: json["google_provider_id"],
      facebookProviderId: json["facebook_provider_id"],
      twitterProviderId: json["twitter_provider_id"],
      linkedinProviderId: json["linkedin_provider_id"],
      appleProviderId: json["apple_provider_id"],
      about: json["about"],
      isActive: json["is_active"],
      isPasswordWeak: json["is_password_weak"],
      address: json["address"],
      note: json["note"],
      notificationStatus: json["notification_status"],
      verificationCode: json["verification_code"],
      emailVerifiedAt: json["email_verified_at"],
      rememberToken: json["remember_token"],
      verificationLink: json["verification_link"],
      platformKind: json["platform_kind"],
      platformId: json["platform_id"],
      country: json["country"],
      marketingCompanyCode: json["marketing_company_code"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      status: json["status"],
      loginToken: json["login_token"],
      mainId: json["main_id"],
      companyName: json["company_name"],
      companyLogo: json["company_logo"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      kind: json["kind"],
      gender: json["gender"],
      isShownEmail: json["is_shown_email"],
      isShownMobile: json["is_shown_mobile"],
      isAcceptTerms: json["is_accept_terms"],
      actionId: json["action_id"],
      isAccept: json["is_accept"],
      isDelete: json["is_delete"],
      isOrginUser: json["is_orgin_user"],
      isBlocked: json["is_blocked"],
      defaultPackage: json["default_package"],
      businessActivityId: json["business_activity_id"],
      isAllowVoice: json["is_allow_voice"],
      allowVoiceTime: json["allow_voice_time"],
      businessActivityIdNew: json["business_activity_id_new"],
      isPermissionChat: json["is_permission_chat"],
      pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );
  }

}

class Pivot {
  Pivot({
    required this.followerId,
    required this.followingId,
  });

  final int? followerId;
  final int? followingId;

  factory Pivot.fromJson(Map<String, dynamic> json){
    return Pivot(
      followerId: json["follower_id"],
      followingId: json["following_id"],
    );
  }

}
