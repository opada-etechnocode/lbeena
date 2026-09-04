
class CouponUserModel {
  CouponUserModel({
    required this.status,
    required this.coupons,
    required this.hasCoupon,
    required this.couponUser,
  });

  final bool? status;
  final Coupons? coupons;

  final String? couponUser;
  final String? hasCoupon;

  factory CouponUserModel.fromJson(Map<String, dynamic> json){
    return CouponUserModel(
      status: json["status"],
      couponUser: json["coupon"],
      hasCoupon: json["has_coupon"],
      coupons: json["coupons"] == null ? null : Coupons.fromJson(json["coupons"]),
    );
  }

}

class Coupons {
  Coupons({
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
  final List<CouponList> data;
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

  factory Coupons.fromJson(Map<String, dynamic> json){
    return Coupons(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<CouponList>.from(json["data"]!.map((x) => CouponList.fromJson(x))),
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

}

class CouponList {
  CouponList({
    required this.code,
    required this.startDate,
    required this.adId,
    required this.userId,
    required this.couponPercent,
    required this.adsName,
    required this.userName,
    required this.companyName,
    required this.read,
    required this.used,
    required this.userMobile,
    required this.bannerName,
    required this.ads_description,

  });

   String? code;
   DateTime? startDate;
   String? adId;
   String? userId;
   String? couponPercent;
   String? adsName;
   String? companyName;
   String? userName;
   String? userMobile;
   String? ads_description;
   String? bannerName;
   String? read;
   String? used;

  factory CouponList.fromJson(Map<String, dynamic> json){
    return CouponList(
      code: json["code"]?.toString(),
      used: json["used"]?.toString(),
      read: json["read"]?.toString(),
      startDate: DateTime.tryParse(json["start_date"]?.toString() ?? ""),
      adId: json["ad_id"]?.toString(),
      adsName: json["ads_name"]?.toString(),
      bannerName: json["name"]?.toString(),
      ads_description: json["ads_description"]?.toString(),
      userName: json["user_name"]?.toString(),
      userMobile: json["mobile"]?.toString(),
      userId: json["user_id"]?.toString(),
      couponPercent: json["coupon_percent"]?.toString(),
      companyName: json["company_name"]?.toString(),
    );
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
      url: json["url"]?.toString(),
      label: json["label"]?.toString(),
      active: json["active"],
    );
  }

}
