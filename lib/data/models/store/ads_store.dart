import '../home_page/banner_product_model.dart';

class AdsStoreModel {
  AdsStoreModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final DataStore? data;

  factory AdsStoreModel.fromJson(Map<String, dynamic> json){
    return AdsStoreModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataStore.fromJson(json["data"]),
    );
  }

}

class DataStore {
  DataStore({
    required this.adsBanner,
    required this.adsProduct,
  });

  final AdsBanner? adsBanner;
  final AdsProduct? adsProduct;

  factory DataStore.fromJson(Map<String, dynamic> json){
    return DataStore(
      adsBanner: json["adsBanner"] == null ? null : AdsBanner.fromJson(json["adsBanner"]),
      adsProduct: json["adsProduct"] == null ? null : AdsProduct.fromJson(json["adsProduct"]),
    );
  }

}

class AdsBanner {
  AdsBanner({
    required this.data,
  });

   List<DataProductBannerModel> data =[];

  factory AdsBanner.fromJson(Map<String, dynamic> json){
    return AdsBanner(
      data:  json["data"] == null ? [] : List<DataProductBannerModel>.from(json["data"]!.map((x) => DataProductBannerModel.fromJson(x))),
    );
  }

}

class AdsProduct {
  AdsProduct({
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
  List<DataProductBannerModel> data =[];
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

  factory AdsProduct.fromJson(Map<String, dynamic> json){
    return AdsProduct(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<DataProductBannerModel>.from(json["data"]!.map((x) => DataProductBannerModel.fromJson(x))),
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
