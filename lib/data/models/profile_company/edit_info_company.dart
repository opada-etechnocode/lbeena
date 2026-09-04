class EditInformationCompanyModel {
  EditInformationCompanyModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory EditInformationCompanyModel.fromJson(Map<String, dynamic> json){
    return EditInformationCompanyModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.company,
     this.profilePic,
  });

  final Company? company;
  final String? profilePic;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      company: json["company"] == null ? null : Company.fromJson(json["company"]),
      profilePic: json["profile_pic"],
    );
  }

}

class Company {
  Company({
    required this.id,
    required this.mobile,
    required this.profilePic,
    required this.accountType,
    required this.isActive,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.companyName,
    required this.companyLogo,
    required this.userId,
    required this.commercialLicense,
    required this.description,
    required this.licenseNumber,
    required this.companyActivity,
    required this.is_have_whatsapp,
    required this.companyActivityNew,
    required this.expiryDate,
    required this.commercialLicenseNew,
  });

  final int? id;
  final String? mobile;
  final dynamic profilePic;
  final String? accountType;
  final String? isActive;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final String? companyName;
  final dynamic companyLogo;
  final String? userId;
  final String? commercialLicense;
  final String? description;
  final String? licenseNumber;
  final String? companyActivity;
  final String? companyActivityNew;
  final DateTime? expiryDate;
  final String? commercialLicenseNew;
  final String? is_have_whatsapp;

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      id: json["id"],
      mobile: json["mobile"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      accountType: json["account_type"]?.toString(),
      isActive: json["is_active"]?.toString(),
      country: json["country"]?.toString(),
      is_have_whatsapp: json["is_have_whatsapp"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ""),
      status: json["status"]?.toString(),
      companyName: json["company_name"]?.toString(),
      companyLogo: json["company_logo"]?.toString(),
      userId: json["user_id"]?.toString(),
      commercialLicense: json["commercial_license"]?.toString(),
      description: json["description"]?.toString(),
      licenseNumber: json["license_number"]?.toString(),
      companyActivity: json["company_activity"]?.toString(),
      companyActivityNew: json["company_activity_new"]?.toString(),
      expiryDate: DateTime.tryParse(json["expiry_date"]?.toString() ?? ""),
      commercialLicenseNew: json["commercial_license_new"]?.toString(),
    );
  }

}
