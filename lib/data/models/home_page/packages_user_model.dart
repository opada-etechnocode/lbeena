class PackagesUserModel {
  PackagesUserModel({
    required this.message,
    required this.status,
    required this.package,
    required this.posts,
    required this.followersCount,
    required this.followingCount,
    required this.adsProductCount,
  });

  final String? message;
  final String? posts;
  final String? followersCount;
  final String? followingCount;
  final String? adsProductCount;
  final bool? status;
  final Package? package;

  factory PackagesUserModel.fromJson(Map<String, dynamic> json){
    return PackagesUserModel(
      message: json["message"],
      status: json["status"],
      followersCount: json["followers_count"]?.toString(),
      posts: json["posts"]?.toString(),
      followingCount: json["following_count"]?.toString(),
      adsProductCount: json["ads_product_count"]?.toString(),
      package: json["package"] == null ? null : Package.fromJson(json["package"]),
    );
  }

}

class Package {
  Package({
    required this.freeAdsQty,
    required this.text_package,
    required this.freeAdsPeriod,
    required this.membership_number,
    required this.premiumAdsQty,
    required this.premiumAdsPeriod,
    required this.price,
    required this.period,
    required this.pointCount,
    required this.colorPackage,
    required this.title,
    required this.isDefault,
  });

  final int? freeAdsQty;
  final int? freeAdsPeriod;
  final int? premiumAdsQty;
  final int? premiumAdsPeriod;
  final int? membership_number;
  final int? price;
  final int? period;
  final int? pointCount;
  final String? colorPackage;
  final String? text_package;
  final String? title;
  final int? isDefault;

  factory Package.fromJson(Map<String, dynamic> json){
    return Package(
      freeAdsQty: json["free_ads_qty"],
      membership_number: json["membership_number"],
      freeAdsPeriod: json["free_ads_period"],
      premiumAdsQty: json["premium_ads_qty"],
      title: json["title"],
      premiumAdsPeriod: json["premium_ads_period"],
      price: json["price"],
      period: json["period"],
      pointCount: json["point_count"],
      colorPackage: json["color"],
      text_package: json["text_package"],
      isDefault: json["is_default"],
    );
  }

}
