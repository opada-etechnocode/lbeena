import 'banner_product_model.dart';

class CategoriesPartModel {
  CategoriesPartModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory CategoriesPartModel.fromJson(Map<String, dynamic> json){
    return CategoriesPartModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.socialMedia,
    required this.video,
    required this.banner,
    required this.product,
  });

  final List<SocialMedia> socialMedia;
  final VideoData? video;
  final Product? banner;
  final Product? product;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      socialMedia: json["social_media"] == null ? [] : List<SocialMedia>.from(json["social_media"]!.map((x) => SocialMedia.fromJson(x))),
      video: json["video"] == null ? null: VideoData.fromJson(json["video"]),
      banner: json["banner"] == null ? null : Product.fromJson(json["banner"]),
      product: json["Product"] == null ? null : Product.fromJson(json["Product"]),
    );
  }

}

class Product {
  Product({
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
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
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

class SocialMedia {
  SocialMedia({
    required this.socialMediaId,
    required this.socialMediaName,
    required this.image,
    required this.url,
  });

  final String? socialMediaId;
  final String? socialMediaName;
  final String? image;
  final String? url;

  factory SocialMedia.fromJson(Map<String, dynamic> json){
    return SocialMedia(
      socialMediaId: json["social_media_id"]?.toString(),
      socialMediaName: json["social_media_name"]?.toString(),
      image: json["image"]?.toString(),
      url: json["url"]?.toString(),
    );
  }

}

class VideoData {
  VideoData({
    required this.data,
  });

  final List<Video> data;

  factory VideoData.fromJson(Map<String, dynamic> json){
    return VideoData(
      data: json["data"] == null ? [] : List<Video>.from(json["data"]!.map((x) => Video.fromJson(x))),
    );
  }

}
class Video {
  Video({
    required this.videoLink,
    required this.videoName,
    required this.imageNames,
    required this.id,
    required this.createdAt,
  });

  final String? videoLink;
  final String? videoName;
  final DateTime? createdAt;
  final String? id;
  final List<String>? imageNames;

  factory Video.fromJson(Map<String, dynamic> json){
    return Video(
      videoLink: json["video_link"]?.toString(),
      videoName: json["video_name"]?.toString(),
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      id: json["id"]?.toString(),
        imageNames: json["image_names"] == null ? [] : List<String>.from(json["image_names"]!.map((x) => x))
    );
  }

}
