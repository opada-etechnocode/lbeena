import '../profile_company/profile_company_model.dart';

class CompanyModel {
  CompanyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory CompanyModel.fromJson(Map<String, dynamic> json){
    return CompanyModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

}

class Data {
  Data({
    required this.companies,
  });

  final Companies? companies;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      companies: json["companies"] == null ? null : Companies.fromJson(json["companies"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'companies': companies?.toJson(),
    };
  }


}

class Companies {
  Companies({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<CompaniesListModel> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Companies.fromJson(Map<String, dynamic> json){
    return Companies(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<CompaniesListModel>.from(json["data"]!.map((x) => CompaniesListModel.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((x) => x.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((x) => x.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

}

class CompaniesListModel {
  CompaniesListModel({
    required this.id,
    required this.profilePic,
    required this.companyName,
    required this.country,
    required this.createdAt,
    required this.joinedAt,
    required this.status,
    required this.rating,
    required this.ownerName,
    required this.subcategory_name,
    required this.licenseNumber,
    required this.companyActivity,
    required this.expiryDate,
    required this.commercialLicense,
    required this.business_activities_id,
    required this.createdAtVerification,
    required this.description,
    required this.business_activities_name,
    required this.membershipNumber,
    required this.links,
  });

  final int? id;
  final String? profilePic;
  final String? membershipNumber;
  final String? companyName;
  final String? country;
  final DateTime? createdAt;
  final DateTime? joinedAt;
  final String? status;
  final String? rating;
  final String? ownerName;
  final String? licenseNumber;
  final String? companyActivity;
  final DateTime? expiryDate;
  final String? commercialLicense;
  final DateTime? createdAtVerification;
  final String? description;
  final String? business_activities_name;
  final String? subcategory_name;
  final int? business_activities_id;

  List<LinkSocialMedia> links;
  factory CompaniesListModel.fromJson(Map<String, dynamic> json){
    return CompaniesListModel(
      id: json["id"],
      profilePic: json["profile_pic"],
      membershipNumber: json["membership_number"]?.toString(),
      business_activities_id: json["business_activities_id"],
      companyName: json["company_name"],
      country: json["country"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      joinedAt: DateTime.tryParse(json["joined_at"] ?? ""),
      status: json["status"],
      rating: json["rating"],
      ownerName: json["owner_name"],
      licenseNumber: json["license_number"],
      business_activities_name: json["business_activities_name"],
      subcategory_name: json["subcategory_name"],
      companyActivity: json["company_activity"],
      expiryDate: DateTime.tryParse(json["expiry_date"] ?? ""),
      commercialLicense: json["commercial_license"],
      createdAtVerification: DateTime.tryParse(json["created_at_verification"] ?? ""),
      description: json["description"],
      links: json["links"] == null ? [] : List<LinkSocialMedia>.from(json["links"]!.map((x) => LinkSocialMedia.fromJson(x))),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_pic': profilePic,
      'company_name': companyName,
      'subcategory_name': subcategory_name,
      'country': country,
      'created_at': createdAt?.toIso8601String(),
      'joined_at': joinedAt?.toIso8601String(),
      'status': status,
      'rating': rating,
      'owner_name': ownerName,
      'license_number': licenseNumber,
      'company_activity': companyActivity,
      'expiry_date': expiryDate?.toIso8601String(),
      'commercial_license': commercialLicense,
      'created_at_verification': createdAtVerification?.toIso8601String(),
      'description': description,
      'business_activities_name': business_activities_name,
      'business_activities_id': business_activities_id,
      'links': links,
    };
  }

}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }

}
