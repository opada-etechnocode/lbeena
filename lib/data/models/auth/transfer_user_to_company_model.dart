class TransferUserToCompanyModel {
  TransferUserToCompanyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory TransferUserToCompanyModel.fromJson(Map<String, dynamic> json){
    return TransferUserToCompanyModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.companyName,
    required this.userId,
    required this.country,
    required this.accountType,
    required this.mobile,
    required this.isMobileVerified,
    required this.actionId,
    required this.ownerName,
    required this.licenseNumber,
    required this.companyActivity,
    required this.expiryDate,
    required this.profilePic,
    required this.commercialLicense,
    required this.description,
    required this.accessToken,
  });

  final String? companyName;
  final int? userId;
  final String? country;
  final String? accountType;
  final String? mobile;
  final int? isMobileVerified;
  final int? actionId;
  final String? ownerName;
  final String? licenseNumber;
  final String? companyActivity;
  final DateTime? expiryDate;
  final dynamic profilePic;
  final String? commercialLicense;
  final String? description;
  final String? accessToken;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      companyName: json["company_name"]?.toString(),
      userId: json["user_id"],
      country: json["country"]?.toString(),
      accountType: json["account_type"]?.toString(),
      mobile: json["mobile"]?.toString(),
      isMobileVerified: json["is_mobile_verified"],
      actionId: json["action_id"],
      ownerName: json["owner_name"]?.toString(),
      licenseNumber: json["license_number"]?.toString(),
      companyActivity: json["company_activity"]?.toString(),
      expiryDate: DateTime.tryParse(json["expiry_date"]?.toString() ?? ""),
      profilePic: json["profile_pic"]?.toString(),
      commercialLicense: json["commercial_license"]?.toString(),
      description: json["description"]?.toString(),
      accessToken: json["access_token"]?.toString(),
    );
  }

}
