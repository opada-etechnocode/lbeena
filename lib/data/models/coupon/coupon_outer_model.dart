class CouponOuterModel {
  CouponOuterModel({
    required this.status,
    required this.coupons,
  });

  final bool? status;
  final Coupons? coupons;

  factory CouponOuterModel.fromJson(Map<String, dynamic> json){
    return CouponOuterModel(
      status: json["status"],
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
  final List<CouponsOuterList> data;
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
      data: json["data"] == null ? [] : List<CouponsOuterList>.from(json["data"]!.map((x) => CouponsOuterList.fromJson(x))),
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

class CouponsOuterList {
  CouponsOuterList({
    required this.id,
    required this.providerName,
    required this.code,
    required this.durationDays,
    required this.discountPercentage,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? providerName;
  final String? code;
  final String? description;
  final int? durationDays;
  final int? discountPercentage;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory CouponsOuterList.fromJson(Map<String, dynamic> json){
    return CouponsOuterList(
      id: json["id"],
      providerName: json["provider_name"],
      description: json["description"],
      code: json["code"],
      durationDays: json["duration_days"],
      discountPercentage: json["discount_percentage"],
      isActive: json["is_active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
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
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }

}
