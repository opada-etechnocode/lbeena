class LoginModel {
  LoginModel({
    required this.status,
    required this.is_mobile_verified,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final int? is_mobile_verified;
  final Data? data;

  factory LoginModel.fromJson(Map<String, dynamic> json){
    return LoginModel(
      status: json["status"],
      message: json["message"],
      is_mobile_verified: json["is_mobile_verified"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    // required this.isSignup,
  });

  final String? accessToken;
  final String? tokenType;
  final User? user;
  // final dynamic isSignup;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      // isSignup: json["is_signup"],
    );
  }

}

class User {
  User({
    required this.userId,
    required this.mobile,
    required this.status,
    required this.companyName,
    required this.isActive,
    required this.email,
    required this.accountType,
    required this.membershipNumber,
    required this.userName,
    required this.profilePic,
    required this.createdAt,
    required this.joinedAt,
    required this.rating,
  });

  final String? userId;
  final String? mobile;
  final String? status;
  final String? companyName;
  final String? isActive;
  final String? email;
  final String? accountType;
  final String? userName;
  final dynamic profilePic;
  final String? createdAt;
  final String? joinedAt;
  final String? rating;
  final String? membershipNumber;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json["user_id"]?.toString(),
      mobile: json["mobile"]?.toString(),
      membershipNumber: json["membership_number"]?.toString(),
      status: json["status"]?.toString(),
      companyName: json["company_name"]?.toString(),
      isActive: json["is_active"]?.toString(),
      email: json["email"]?.toString(),
      accountType: json["account_type"]?.toString(),
      userName: json["user_name"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      createdAt: json["created_at"]?.toString(),
      joinedAt: json["joined_at"]?.toString(),
      rating: json["rating"]?.toString(),
    );
  }

}
