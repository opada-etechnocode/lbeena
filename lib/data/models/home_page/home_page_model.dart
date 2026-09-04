import '../community/community_post_model.dart';
import 'banner_product_model.dart';
class HomePageModel {
  HomePageModel({
    required this.status,
    required this.message,
    required this.data,
    required this.relatedAds,
  });

  final String? status;
  final String? message;
  final DataHomePage? data;
  final List<DataProductBannerModel>? relatedAds;

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    return HomePageModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DataHomePage.fromJson(json["data"]),
      relatedAds: json["ads"] == null ? [] : List<DataProductBannerModel>.from(json["ads"]!.map((x) => DataProductBannerModel.fromJson(x))),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),  // تم تعديلها لتكون data بدلاً من news
      'ads': relatedAds?.map((e) => e.toJson()).toList(), // تحويل relatedAds إلى JSON
    };
  }
}


class DataHomePage {
  DataHomePage({
    required this.adsBanner,
    required this.adsProduct,
    required this.company,
    required this.adsAddRecently,
    required this.adsRandom,
    required this.adsEvalution,
    required this.adsVideo,
    required this.newsHomePageModel,
    required this.postPin,
  });

  // final AdsBanner? adsBanner;
  final List<DataProductBannerModel> adsBanner;
  final Ads? adsProduct;
  final DataCompany? company;
  final Ads? adsAddRecently;
  final Ads? adsRandom;
  final Ads? adsEvalution;
  final AdsVideo? adsVideo;
  final List<NewsDatum> newsHomePageModel;
  final CommunityAllPost? postPin;

  factory DataHomePage.fromJson(Map<String, dynamic> json){
    return DataHomePage(
      // adsBanner: json["adsBanner"] == null ? null : AdsBanner.fromJson(json["adsBanner"]),
      adsBanner: json["adsBanner"] == null ? [] : List<DataProductBannerModel>.from(json["adsBanner"]!.map((x) => DataProductBannerModel.fromJson(x))),

      adsVideo: json["adsVideo"] == null ? null : AdsVideo.fromJson(json["adsVideo"]),
      newsHomePageModel: json["news"] == null ? [] : List<NewsDatum>.from(json["news"]!.map((x) => NewsDatum.fromJson(x))),
      adsProduct: json["adsProduct"] == null ? null : Ads.fromJson(json["adsProduct"]),
      company: json["specialCompanies"] == null ? null : DataCompany.fromJson(json["specialCompanies"]),
      adsAddRecently: json["adsAddRecently"] == null ? null : Ads.fromJson(json["adsAddRecently"]),
      adsRandom: json["mergedAds"] == null ? null : Ads.fromJson(json["mergedAds"]),
      adsEvalution: json["mergedData"] == null ? null : Ads.fromJson(json["mergedData"]),
      postPin: json["posts"] == null ? null : CommunityAllPost.fromJson(json["posts"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'adsBanner': adsBanner?.toJson(),
      'adsBanner': List<dynamic>.from(adsBanner.map((x) => x.toJson())),
      'adsProduct': adsProduct?.toJson(),
      'specialCompanies': company?.toJson(),
      'adsAddRecently': adsAddRecently?.toJson(),
      'mergedAds': adsRandom?.toJson(),
      'mergedData': adsEvalution?.toJson(),
      'adsVideo': adsVideo?.toJson(),
      'news': List<dynamic>.from(newsHomePageModel.map((x) => x.toJson())),
      'posts': postPin?.toJson(),
    };
  }
}

class Ads {
  Ads({
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
  final List<DataProductBannerModel> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Ads.fromJson(Map<String, dynamic> json){
    return Ads(
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

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': List<dynamic>.from(links.map((x) => x.toJson())),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

}


class AdsVideo {
  AdsVideo({
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
  final List<AdsVideoDatum> data;
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

  factory AdsVideo.fromJson(Map<String, dynamic> json){
    return AdsVideo(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<AdsVideoDatum>.from(json["data"]!.map((x) => AdsVideoDatum.fromJson(x))),
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

class AdsVideoDatum {
  AdsVideoDatum({
    required this.adsId,
    required this.userId,
    required this.categoryId,
    required this.activeChat,
    required this.isFavoriate,
    required this.mobile,
    required this.clicks,
    required this.isAddCoupon,
    required this.couponPercent,
    required this.categoryName,
    required this.status,
    required this.languageId,
    required this.type,
    required this.name,
    required this.isHave,
    required this.acceptDate,
    required this.description,
    required this.videoLink,
    required this.videoName,
    required this.sortOrder,
    required this.price,
    required this.note,
    required this.finalPrice,
    required this.paymentStatus,
    required this.createdAt,
    required this.finishedAd,
    required this.evaluationsAd,
    required this.imageNames,
    required this.favoritesCount,
    required this.company,
    required this.adSpecialFeatures,
  });

  final String? adsId;
  final String? userId;
  final String? categoryId;
  final String? activeChat;
  final String? isFavoriate;
  final dynamic mobile;
  final String? clicks;
  final String? isAddCoupon;
  final dynamic couponPercent;
  final String? categoryName;
  final String? status;
  final String? languageId;
  final String? type;
  final dynamic name;
  final String? isHave;
  final DateTime? acceptDate;
  final dynamic description;
  final String? videoLink;
  final String? videoName;
  final String? sortOrder;
  final dynamic price;
  final dynamic note;
  final dynamic finalPrice;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? finishedAd;
  final dynamic evaluationsAd;
  final List<String> imageNames;
  final String? favoritesCount;
  final List<CompanyElement> company;
  final List<AdSpecialFeature> adSpecialFeatures;

  factory AdsVideoDatum.fromJson(Map<String, dynamic> json){
    return AdsVideoDatum(
      adsId: json["ads_id"]?.toString(),
      userId: json["user_id"]?.toString(),
      categoryId: json["category_id"]?.toString(),
      activeChat: json["active_chat"]?.toString(),
      isFavoriate: json["is_favoriate"]?.toString(),
      mobile: json["mobile"]?.toString(),
      clicks: json["clicks"]?.toString(),
      isAddCoupon: json["is_add_coupon"]?.toString(),
      couponPercent: json["coupon_percent"]?.toString(),
      categoryName: json["category_name"]?.toString(),
      status: json["status"]?.toString(),
      languageId: json["language_id"]?.toString(),
      type: json["type"]?.toString(),
      name: json["name"]?.toString(),
      isHave: json["is_have"]?.toString(),
      acceptDate: DateTime.tryParse(json["accept_date"] ?? ""),
      description: json["description"]?.toString(),
      videoLink: json["video_link"]?.toString(),
      videoName: json["video_name"]?.toString(),
      sortOrder: json["sort_order"]?.toString(),
      price: json["price"]?.toString(),
      note: json["note"]?.toString(),
      finalPrice: json["final_price"]?.toString(),
      paymentStatus: json["payment_status"]?.toString(),
      createdAt: DateTime.tryParse(json["created_ad"] ?? ""),
      finishedAd: DateTime.tryParse(json["finished_ad"] ?? ""),
      evaluationsAd: json["evaluations_ad"]?.toString(),
      imageNames: json["image_names"] == null ? [] : List<String>.from(json["image_names"]!.map((x) => x)),
      favoritesCount: json["favorites_count"]?.toString(),
      company: json["company"] == null ? [] : List<CompanyElement>.from(json["company"]!.map((x) => CompanyElement.fromJson(x))),
      adSpecialFeatures: json["ad_special_features"] == null ? [] : List<AdSpecialFeature>.from(json["ad_special_features"]!.map((x) => AdSpecialFeature.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ads_id': adsId,
      'user_id': userId,
      'category_id': categoryId,
      'active_chat': activeChat,
      'is_favoriate': isFavoriate,
      'mobile': mobile,
      'clicks': clicks,
      'is_add_coupon': isAddCoupon,
      'coupon_percent': couponPercent,
      'category_name': categoryName,
      'status': status,
      'language_id': languageId,
      'type': type,
      'name': name,
      'is_have': isHave,
      'accept_date': acceptDate?.toIso8601String(),
      'description': description,
      'video_link': videoLink,
      'video_name': videoName,
      'sort_order': sortOrder,
      'price': price,
      'note': note,
      'final_price': finalPrice,
      'payment_status': paymentStatus,
      'created_at': createdAt?.toIso8601String(),
      'finished_ad': finishedAd?.toIso8601String(),
      'evaluations_ad': evaluationsAd,
      'image_names': imageNames,
      'favorites_count': favoritesCount,
      'company': company.map((x) => x.toJson()).toList(),
      'ad_special_features': adSpecialFeatures.map((x) => x.toJson()).toList(),
    };
  }


}

class NewsDatum {
  NewsDatum({
    required this.id,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.link,
    required this.source,
    required this.createdAt,
    required this.image,
    required this.sortOrder,
    required this.isTape,
  });

  final String? id;
  final String? title;
  final String? description;
  final dynamic backgroundColor;
  final String? link;
  final String? source;
  final DateTime? createdAt;
  final String? image;
  final String? sortOrder;
  final String? isTape;

  factory NewsDatum.fromJson(Map<String, dynamic> json){
    return NewsDatum(
      id: json["id"]?.toString(),
      title: json["title"]?.toString(),
      description: json["description"]?.toString(),
      backgroundColor: json["background_color"]?.toString(),
      link: json["link"]?.toString(),
      source: json["source"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      image: json["Image"]?.toString(),
      sortOrder: json["sort_order"]?.toString(),
      isTape: json["is_tape"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'background_color': backgroundColor,
      'link': link,
      'source': source,
      'created_at': createdAt?.toIso8601String(),
      'image': image,
      'sort_order': sortOrder,
      'is_tape': isTape,
    };
  }


}
class CompanyElement {
  CompanyElement({
    required this.id,
    required this.companyName,
    required this.profilePic,
    required this.country,
    required this.evaluations,
    required this.is_have_whatsapp,
  });

  final int? id;
  final String? companyName;
  final String? profilePic;
  final String? country;
  final String? is_have_whatsapp;
  final String? evaluations;

  factory CompanyElement.fromJson(Map<String, dynamic> json){
    return CompanyElement(
      id: json["id"],
      companyName: json["company_name"]?.toString(),
      is_have_whatsapp: json["is_have_whatsapp"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      country: json["country"]?.toString(),
      evaluations: json["evaluations"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'profile_pic': profilePic,
      'country': country,
      'is_have_whatsapp': is_have_whatsapp,
      'evaluations': evaluations,
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
      url: json["url"]?.toString(),
      label: json["label"]?.toString(),
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

class AdsBanner {
  AdsBanner({
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
  final List<DataProductBannerModel> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory AdsBanner.fromJson(Map<String, dynamic> json){
    return AdsBanner(
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

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': List<dynamic>.from(links.map((x) => x.toJson())),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }


}

class AdsBannerDatum {
  AdsBannerDatum({
    required this.adsId,
    required this.userId,
    required this.id,
    required this.price,
    required this.finalPrice,
    required this.paymentStatus,
    required this.categoryName,
    required this.activeChat,
    required this.isFavoriate,
    required this.mobile,
    required this.clicks,
    required this.isAddCoupon,
    required this.couponPercent,
    required this.type,
    required this.languageId,
    required this.url,
    required this.bannerId,
    required this.image,
    required this.inOut,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.status,
    required this.isHave,
    required this.createdAd,
    required this.acceptDate,
    required this.finishedAt,
    required this.favoritesCount,
    required this.company,
    required this.adSpecialFeatures,
    required this.categoryId,
    required this.videoLink,
    required this.videoName,
    required this.imageNames,
    required this.evaluatorId,
    required this.adId,
    required this.value,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.evaluationsAd,
    required this.note,
  });

  final String? adsId;
  final String? note;
  final String? userId;
  final int? id;
  final String? categoryName;
  final String? paymentStatus;
  final String? activeChat;
  final String? isFavoriate;
  final String? mobile;
  final String? clicks;
  final String? isAddCoupon;
  final String? couponPercent;
  final String? type;
  final String? languageId;
  final String? url;
  final String? bannerId;
  final String? image;
  final String? inOut;
  final String? name;
  final String? description;
  final String? sortOrder;
  final String? status;
  final String? isHave;
  final DateTime? createdAd;
  final DateTime? finishedAt;
  final DateTime? acceptDate;
  final String? favoritesCount;
  final List<CompanyElement> company;
  final List<AdSpecialFeature> adSpecialFeatures;
  final String? categoryId;
  final dynamic videoLink;
  final dynamic videoName;
  final List<String> imageNames;
  final String? evaluatorId;
  final String? adId;
  final String? value;
  final String? price;
  final String? finalPrice;
  final String? evaluationsAd;
  final dynamic comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AdsBannerDatum.fromJson(Map<String, dynamic> json){
    return AdsBannerDatum(
      evaluationsAd:json['evaluations_ad']?.toString(),
      note:json['note']?.toString(),
      adsId: json["ads_id"]?.toString(),
      userId: json["user_id"]?.toString(),
      id: json["id"],
      paymentStatus: json["payment_status"]?.toString(),
      price: json["price"]?.toString(),
      finalPrice: json["final_price"]?.toString(),
      categoryName: json["category_name"]?.toString(),
      activeChat: json["active_chat"]?.toString(),
      isFavoriate: json["is_favoriate"]?.toString(),
      mobile: json["mobile"]?.toString(),
      clicks: json["clicks"]?.toString(),
      isAddCoupon: json["is_add_coupon"]?.toString(),
      couponPercent: json["coupon_percent"]?.toString(),
      type: json["type"]?.toString(),
      languageId: json["language_id"]?.toString(),
      url: json["url"]?.toString(),
      bannerId: json["bannerId"]?.toString(),
      image: json["image"]?.toString(),
      inOut: json["in_out"]?.toString(),
      name: json["name"]?.toString(),
      description: json["description"]?.toString(),
      sortOrder: json["sort_order"]?.toString(),
      status: json["status"]?.toString(),
      isHave: json["is_have"]?.toString(),
      createdAd: DateTime.tryParse(json["created_ad"] ?? ""),
      acceptDate: DateTime.tryParse(json["accept_date"] ?? ""),
      finishedAt: DateTime.tryParse(json["finished_ad"] ?? ""),
      favoritesCount: json["favorites_count"]?.toString(),
      company: json["company"] == null ? [] : List<CompanyElement>.from(json["company"]!.map((x) => CompanyElement.fromJson(x))),
      adSpecialFeatures: json["ad_special_features"] == null ? [] : List<AdSpecialFeature>.from(json["ad_special_features"]!.map((x) => AdSpecialFeature.fromJson(x))),
      categoryId: json["category_id"]?.toString(),
      videoLink: json["video_link"]?.toString(),
      videoName: json["video_name"]?.toString(),
      imageNames: json["image_names"] == null ? [] : List<String>.from(json["image_names"]!.map((x) => x)),
      evaluatorId: json["evaluator_id"]?.toString(),
      adId: json["ad_id"]?.toString(),
      value: json["value"]?.toString(),
      comment: json["comment"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}

class DataCompany {
  DataCompany({
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
  final List<CompanyDatum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory DataCompany.fromJson(Map<String, dynamic> json){
    return DataCompany(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<CompanyDatum>.from(json["data"]!.map((x) => CompanyDatum.fromJson(x))),
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
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': List<dynamic>.from(links.map((x) => x.toJson())),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }


}

class CompanyDatum {
  CompanyDatum({
    required this.id,
    required this.companyName,
    required this.profilePic,
    required this.is_have_whatsapp,
    required this.isSpecial,
  });

  final int? id;
  final String? companyName;
  final String? profilePic;
  final String? isSpecial;
  final String? is_have_whatsapp;

  factory CompanyDatum.fromJson(Map<String, dynamic> json){
    return CompanyDatum(
      id: json["id"],
      companyName: json["company_name"]?.toString(),
      profilePic: json["profile_pic"]?.toString(),
      is_have_whatsapp: json["is_have_whatsapp"]?.toString(),
      isSpecial: json["is_special"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'profile_pic': profilePic,
      'is_have_whatsapp': is_have_whatsapp,
      'is_special': isSpecial,
    };
  }


}
