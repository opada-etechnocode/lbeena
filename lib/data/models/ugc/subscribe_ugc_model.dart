class SubscribeToUgcModel {
  SubscribeToUgcModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final String? status;
  final SubscribeToUgcData? data;

  factory SubscribeToUgcModel.fromJson(Map<String, dynamic> json){
    return SubscribeToUgcModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null ? null : SubscribeToUgcData.fromJson(json["data"]),
    );
  }

}

class SubscribeToUgcData {
  SubscribeToUgcData({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.cityId,
    required this.categoryUgcId,
    required this.gender,
    required this.links,
  });

  final int? id;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? cityId;
  final int? categoryUgcId;
  final String? gender;
  final List<Link> links;

  factory SubscribeToUgcData.fromJson(Map<String, dynamic> json){
    return SubscribeToUgcData(
      id: json["id"],
      userId: json["user_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      cityId: json["city_id"],
      categoryUgcId: json["category_ugc_id"],
      gender: json["gender"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    );
  }

}

class Link {
  Link({
    required this.id,
    required this.ugcId,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? ugcId;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      id: json["id"],
      ugcId: json["ugc_id"],
      url: json["url"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
