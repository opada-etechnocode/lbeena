class DetailsProductModel {
  DetailsProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final DataProductBannerModel? data;

  factory DetailsProductModel.fromJson(Map<String, dynamic> json){
    return DetailsProductModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataProductBannerModel.fromJson(json["data"]),
    );
  }

}

class DataProductBannerModel {
  DataProductBannerModel({
    required this.adsId,
    required this.name,
    required this.userId,
    required this.mobile,
    required this.activeChat,
    required this.image,
    required this.isHave,
    required this.idAdSpecialFeature,
    required this.status,
    required this.endAt,
    required this.clicks,
    required this.isAddCoupon,
    required this.type,
    required this.description,
    required this.categoryId,
    required this.videoName,
    required this.videoLink,
    required this.sortOrder,
    required this.createdAd,
    required this.finishedAt,
    required this.couponPercent,
    required this.isFavoriate,
    required this.paymentStatus,
    required this.languageId,
    required this.imageNames,
    required this.categoryName,
    required this.favoritesCount,
    required this.deletedAt,
    required this.company,
    required this.adSpecialFeatures,
    required this.acceptDate,
    required this.price,
    required this.finalPrice,
    required this.evaluationsAd,
    required this.note,
    required this.bannerId,
    required this.url,
    required this.background_color,
    required this.inOut ,
    required this.adsPrice ,
    required this.bannerPrice ,
    required this.days_add_coupon ,
    required this.have_price ,
    required this.city_name ,
    required this.ad_id ,
  });
  final String? price;
  final String? city_name;
  final String? bannerId;
  final String? ad_id;

  final String? note;
  final String? finalPrice;
  final String? adsId;
  final String? name;
  final String? userId;
  final dynamic mobile;
  final String? activeChat;
  final String? isHave;
  final String? idAdSpecialFeature;
  final String? status;
  final DateTime? endAt;
  final String? clicks;
  final String? isAddCoupon;
  final String? type;
  final String? description;
  final String? categoryId;
  final dynamic videoName;
  final dynamic videoLink;
  final String? sortOrder;
  final DateTime? createdAd;
  final DateTime? finishedAt;
  final DateTime? acceptDate;
  final String? deletedAt;
  final String? couponPercent;
  final String? paymentStatus;
  final String? isFavoriate;
  final String? languageId;
  final List<String> imageNames;
  final String? categoryName;
  final String? evaluationsAd;
  final String? image;
  final String? url;
  final String? inOut;
  final String? bannerPrice;
  final String? adsPrice;
  final String? favoritesCount;
  final String? days_add_coupon;
  final String? background_color;
  final String? have_price;
  final List<Company> company;
  final List<AdSpecialFeature> adSpecialFeatures;

  factory DataProductBannerModel.fromJson(Map<String, dynamic> json){
    return DataProductBannerModel(
      adsId: json["ads_id"]?.toString() ?? json['banner_id']?.toString(),
      bannerPrice: json["banner_price"]?.toString(),
      ad_id: json["ad_id"]?.toString() ?? json["ads_id"]?.toString(),
      background_color: json["background_color"]?.toString(),
      have_price: json["have_price"]?.toString(),
      adsPrice: json["ads_price"]?.toString(),
      url: json["url"]?.toString(),
      image: json["image"]?.toString(),
      inOut: json["in_out"]?.toString(),
      note: json["note"]?.toString(),
      price: json["price"]?.toString(),
      days_add_coupon: json["days_add_coupon"]?.toString(),
      deletedAt: json["deleted_at"]?.toString() ,
      finalPrice: json["final_price"]?.toString(),
      evaluationsAd: json["evaluations_ad"]?.toString(),
      name: json["name"]?.toString(),
      userId: json["user_id"]?.toString(),
      city_name: json["city_name"]?.toString(),
      mobile: json["mobile"]?.toString(),
      paymentStatus: json["payment_status"]?.toString(),
      activeChat: json["active_chat"]?.toString(),
      isHave: json["is_have"]?.toString(),
      idAdSpecialFeature: json["id_ad_special_feature"]?.toString(),
      status: json["status"]?.toString(),
      endAt: DateTime.tryParse(json["end_at"] ?? ""),
      clicks: json["clicks"]?.toString(),
      isAddCoupon: json["is_add_coupon"]?.toString(),
      type: json["type"]?.toString(),
      description: json["description"],
      acceptDate: DateTime.tryParse(json["accept_date"]?.toString() ?? ""),
      categoryId: json["category_id"]?.toString(),
      videoName: json["video_name"]?.toString(),
      bannerId: json["bannerId"]?.toString(),
      videoLink: json["video_link"]?.toString(),
      sortOrder: json["sort_order"]?.toString(),
      createdAd: DateTime.tryParse(json["created_ad"]?.toString() ?? json["created_at"]?.toString() ?? ""),
      finishedAt: DateTime.tryParse(json["finished_ad"]?.toString() ?? json["finished_at"]?.toString() ??'' ),
      couponPercent: json["coupon_percent"]?.toString(),
      isFavoriate: json["is_favoriate"]?.toString(),
      languageId: json["language_id"]?.toString(),
      imageNames: json["image_names"]?.toString() == null ? [] : List<String>.from(json["image_names"]!.map((x) => x)),
      categoryName: json["category_name"]?.toString(),
      favoritesCount: json["favorites_count"]?.toString(),
      company: json["company"] == null ? [] : List<Company>.from(json["company"]!.map((x) => Company.fromJson(x))),
      adSpecialFeatures: json["ad_special_features"] == null ? [] : List<AdSpecialFeature>.from(json["ad_special_features"]!.map((x) => AdSpecialFeature.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ads_id': adsId,
      'banner_price': bannerPrice,
      'ad_id': ad_id,
      'background_color': background_color,
      'have_price': have_price,
      'ads_price': adsPrice,
      'url': url,
      'image': image,
      'in_out': inOut,
      'note': note,
      'price': price,
      'days_add_coupon': days_add_coupon,
      'deleted_at': deletedAt,
      'final_price': finalPrice,
      'evaluations_ad': evaluationsAd,
      'name': name,
      'user_id': userId,
      'city_name': city_name,
      'mobile': mobile,
      'payment_status': paymentStatus,
      'active_chat': activeChat,
      'is_have': isHave,
      'id_ad_special_feature': idAdSpecialFeature,
      'status': status,
      'end_at': endAt?.toIso8601String(),
      'clicks': clicks,
      'is_add_coupon': isAddCoupon,
      'type': type,
      'description': description,
      'accept_date': acceptDate?.toIso8601String(),
      'category_id': categoryId,
      'video_name': videoName,
      'bannerId': bannerId,
      'video_link': videoLink,
      'sort_order': sortOrder,
      'created_ad': createdAd?.toIso8601String(),
      'finished_at': finishedAt?.toIso8601String(),
      'coupon_percent': couponPercent,
      'is_favoriate': isFavoriate,
      'language_id': languageId,
      'image_names': List<dynamic>.from(imageNames.map((x) => x)),
      'category_name': categoryName,
      'favorites_count': favoritesCount,
      'company': List<dynamic>.from(company.map((x) => x.toJson())),
      'ad_special_features': List<dynamic>.from(adSpecialFeatures.map((x) => x.toJson())),
    };
  }

}

class AdSpecialFeature {
  AdSpecialFeature({
    required this.id,
    required this.featureName,
    required this.price,
    required this.languageId,
  });

  final String? id;
  final String? featureName;
  final String? price;
  final String? languageId;

  factory AdSpecialFeature.fromJson(Map<String, dynamic> json){
    return AdSpecialFeature(
      id: json["id"]?.toString(),
      featureName: json["feature_name"]?.toString(),
      price: json["price"]?.toString(),
      languageId: json["language_id"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feature_name': featureName,
      'price': price,
      'language_id': languageId,
    };
  }


}

class Company {
  Company({
    required this.id,
    required this.country,
    required this.is_have_whatsapp,
    required this.companyName,
    required this.profilePic,
    required this.evaluations,
    required this.account_type,
  });

  final int? id;
  final String? country;
  final String? companyName;
  final String? profilePic;
  final String? evaluations;
  final String? is_have_whatsapp;
  final String? account_type;

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      id: json["id"],
      country: json["country"]?.toString(),
      account_type: json["account_type"]?.toString(),
      companyName: json["company_name"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      is_have_whatsapp: json["is_have_whatsapp"]?.toString(),
      evaluations: json["evaluations"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'account_type': account_type,
      'company_name': companyName,
      'profile_pic': profilePic,
      'is_have_whatsapp': is_have_whatsapp,
      'evaluations': evaluations,
    };
  }


}
