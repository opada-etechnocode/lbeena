import '../community/community_post_model.dart';
import '../home_page/banner_product_model.dart';

class ProfileCompanyModel {
  ProfileCompanyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory ProfileCompanyModel.fromJson(Map<String, dynamic> json){
    return ProfileCompanyModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.adsBanner,
    required this.adsProduct,
    required this.posts,
    required this.company,
  });

  final List<DataProductBannerModel> adsBanner;
  final List<DataProductBannerModel> adsProduct;
  final List<CommunityModelDatum> posts;
  final List<DataCompany> company;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      adsBanner: json["adsBanner"] == null ? [] : List<DataProductBannerModel>.from(json["adsBanner"]!.map((x) => DataProductBannerModel.fromJson(x))),
      adsProduct: json["adsProduct"] == null ? [] : List<DataProductBannerModel>.from(json["adsProduct"]!.map((x) => DataProductBannerModel.fromJson(x))),
      company: json["company"] == null ? [] : List<DataCompany>.from(json["company"]!.map((x) => DataCompany.fromJson(x))),
      posts: json["posts"] == null ? [] : List<CommunityModelDatum>.from(json["posts"]!.map((x) => CommunityModelDatum.fromJson(x))),
    );
  }

}

class DataCompany {
  DataCompany({
    required this.id,
    required this.companyName,
    required this.country,
    required this.profilePic,
    required this.createdAt,
    required this.joinedAt,
    required this.status,
    required this.rating,
    required this.ownerName,
    required this.licenseNumber,
    required this.is_have_whatsapp,
    required this.companyActivity,
    required this.expiryDate,
    required this.commercialLicense,
    required this.business_activities_id,
    required this.business_activities_name,
    required this.subcategory_id,
    required this.subcategory_name,
    required this.account_type,
    required this.note,
    required this.following_count,
    required this.followers_count,
    required this.desc_user,
    required this.ugc,
    required this.membershipNumber,
    required this.links,
  });

  final int? id;
  final int? business_activities_id;
  final String? business_activities_name;
  final String? companyName;
  final String? country;
  final String? membershipNumber;
  final dynamic profilePic;
  final DateTime? createdAt;
  final DateTime? joinedAt;
  final String? status;
  final String? account_type;
  final String? rating;
  final String? ownerName;
  final String? licenseNumber;
  final String? companyActivity;
  final DateTime? expiryDate;
  final DateTime? is_have_whatsapp;
  final String? commercialLicense;
  final String? desc_user;
  final String? subcategory_name;
  final String? subcategory_id;
  final String? note;
   int? following_count;
   int? followers_count;
  final List<Ugc>? ugc;
   List<LinkSocialMedia> links;
  factory DataCompany.fromJson(Map<String, dynamic> json){
    return DataCompany(
      id: json["id"],
      membershipNumber: json["membership_number"]?.toString(),
      subcategory_id: json["subcategory_id"]?.toString(),
      subcategory_name: json["subcategory_name"],
      following_count: json["following_count"],
      followers_count: json["followers_count"],
      desc_user: json["desc_user"],
      business_activities_name: json["business_activities_name"],
      business_activities_id: json["business_activities_id"],
      note: json["note"],
      account_type: json["account_type"],
      is_have_whatsapp: json["is_have_whatsapp"],
      companyName: json["company_name"],
      country: json["country"],
      profilePic: json["profile_pic"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      joinedAt: DateTime.tryParse(json["joined_at"] ?? ""),
      status: json["status"],
      rating: json["rating"],
      ownerName: json["owner_name"],
      licenseNumber: json["license_number"],
      companyActivity: json["company_activity"],
      expiryDate: DateTime.tryParse(json["expiry_date"] ?? ""),
      commercialLicense: json["commercial_license"],
      ugc: json["ugc"] == null ? [] : List<Ugc>.from(json["ugc"]!.map((x) => Ugc.fromJson(x))),
      links: json["links"] == null ? [] : List<LinkSocialMedia>.from(json["links"]!.map((x) => LinkSocialMedia.fromJson(x))),
    );
  }

}
class LinkSocialMedia {
  LinkSocialMedia({
    required this.id,
    required this.name,
    required this.url,
  });

  final int? id;
  final String? name;
  final String? url;

  factory LinkSocialMedia.fromJson(Map<String, dynamic> json){
    return LinkSocialMedia(
      id: json["id"],
      name: json["name"],
      url: json["url"],
    );
  }

}
class Ugc {
  Ugc({
    required this.id,
    required this.userId,
    required this.isUgcEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.cityId,
    required this.categoryUgcId,
    required this.gender,
    required this.status,
    required this.city_name,
    required this.category_name,
    required this.links,
  });

  final int? id;
  final int? userId;
  final int? isUgcEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? cityId;
  final int? categoryUgcId;
  final String? gender;
  final int? status;
  final String? city_name;
  final String? category_name;
   List<String>? links =[] ;

  factory Ugc.fromJson(Map<String, dynamic> json){
    return Ugc(
      id: json["id"],
      userId: json["user_id"],
      isUgcEnabled: json["is_ugc_enabled"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      cityId: json["city_id"],
      categoryUgcId: json["category_ugc_id"],
      gender: json["gender"],
      status: json["status"],
      city_name: json["city_name"],
      category_name: json["category_name"],
      links: json["links"] == null
          ? []
          : List<String>.from(json["links"]!.where((x) => x != null).map((x) => x)),
    );
  }

}

