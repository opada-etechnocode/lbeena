class PackageCompanyModel {
  PackageCompanyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory PackageCompanyModel.fromJson(Map<String, dynamic> json){
    return PackageCompanyModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.packagecompany,
  });

  final List<PackageCompany> packagecompany;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      packagecompany: json["packagecompany"] == null ? [] : List<PackageCompany>.from(json["packagecompany"]!.map((x) => PackageCompany.fromJson(x))),
    );
  }

}

class PackageCompany {
  PackageCompany({
    required this.id,
     this.title,
     this.period,
     this.price,
     this.titleCategory,
     this.adsPeriod,
     this.startAt,
     this.colorPackage,
     this.adsQty,
     this.categoryId,
     this.startAtCompanyPackage,
     this.endAtCompanyPackage,
     this.statusPayment,
     this.remainingAdsQty,
     this.packagePeriod,
     this.adsUsed,
  });

  final int? id;
  final String? title;
  final String? period;
  final String? price;
  final String? titleCategory;
  final String? adsPeriod;
  final String? startAt;
  final String? colorPackage;
  final String? adsQty;
  final String? categoryId;
  final String? startAtCompanyPackage;
  final String? endAtCompanyPackage;
  final String? statusPayment;
  final String? adsUsed;
  final String? packagePeriod;
  final int? remainingAdsQty;

  factory PackageCompany.fromJson(Map<String, dynamic> json){
    return PackageCompany(
      id: json["id"],
      title: json["title_package"],
      packagePeriod: json["package_period"]?.toString(),
      titleCategory: json["title_category"]?.toString(),
      period: json["package_period"]?.toString(),
      adsPeriod: json["ads_period"]?.toString(),
      price: json["price"]?.toString(),
      startAt: json["start_at"]?.toString(),
      colorPackage: json["color"]?.toString(),
      adsQty: json["ads_qty"]?.toString(),
      categoryId: json["category_id"]?.toString(),
      startAtCompanyPackage: json["start_at_company_package"]?.toString(),
      endAtCompanyPackage: json["end_at_company_package"]?.toString(),
      statusPayment: json["status_payment"]?.toString(),
      remainingAdsQty: json["remaining_ads_qty"],
      adsUsed: json["ads_used"]?.toString(),
    );
  }

}
