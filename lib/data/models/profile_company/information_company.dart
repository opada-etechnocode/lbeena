class ProfileInformationCompanyModel {
  ProfileInformationCompanyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory ProfileInformationCompanyModel.fromJson(Map<String, dynamic> json){
    return ProfileInformationCompanyModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.user,
    this.description
  });

  final User? user;
  final String? description;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      description: json["description"],
    );
  }

}

class User {
  User({
    required this.id,
    required this.profilePic,
    required this.companyName,
    required this.createdAt,
    required this.joinedAt,
    required this.status,
    required this.rating,
    required this.ownerName,
    required this.licenseNumber,
    required this.companyActivity,
    required this.expiryDate,
    required this.country,
    required this.commercialLicense,
    required this.description,
    required this.is_have_whatsapp,
    required this.business_activity_id,
    required this.createdAtVerification,
    required this.account_type,
    required this.note,
  });

  final int? id;
  final int? business_activity_id;
  final String? profilePic;
  final String? companyName;
  final DateTime? createdAt;
  final DateTime? joinedAt;
  final String? status;
  final String? rating;
  final String? ownerName;
  final String? country;
  final String? licenseNumber;
  final String? companyActivity;
  final String? account_type;
  final DateTime? expiryDate;
  final String? commercialLicense;
  final String? description;
  final String? is_have_whatsapp;
  final String? note;
  final DateTime? createdAtVerification;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      business_activity_id: json["business_activity_id"],
      is_have_whatsapp: json["is_have_whatsapp"]?.toString(),
      note: json["note"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      account_type: json["account_type"]?.toString(),
      companyName: json["company_name"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      joinedAt: DateTime.tryParse(json["joined_at"]?.toString() ?? ""),
      status: json["status"]?.toString(),
      country: json["country"]?.toString(),
      rating: json["rating"]?.toString(),
      ownerName: json["owner_name"]?.toString(),
      licenseNumber: json["license_number"]?.toString(),
      companyActivity: json["business_activities_name"]?.toString(),
      expiryDate: DateTime.tryParse(json["expiry_date"]?.toString() ?? ""),
      commercialLicense: json["commercial_license"]?.toString(),
      description: json["description"]?.toString(),
      createdAtVerification: DateTime.tryParse(json["created_at_verification"]?.toString() ?? ""),
    );
  }

}
