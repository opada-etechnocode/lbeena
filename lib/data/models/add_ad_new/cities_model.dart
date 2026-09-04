
class CitiesModel {
  CitiesModel({
    required this.status,
    required this.message,
    required this.data,
    required this.titleAds,
  });

  final String? status;
  final String? message;
  final String? titleAds;
  final List<Cities> data;

  factory CitiesModel.fromJson(Map<String, dynamic> json){
    return CitiesModel(
      status: json["status"],
      message: json["message"],
      titleAds: json["title_ads"],
      data: json["data"] == null ? [] : List<Cities>.from(json["data"]!.map((x) => Cities.fromJson(x))),
    );
  }

}

class Cities {
  Cities({
    required this.id,
    required this.status,
    required this.title,
    required this.createdAt,
    required this.deletedAt,
  });

  final int? id;
  final String? status;
  final String? title;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory Cities.fromJson(Map<String, dynamic> json){
    return Cities(
      id: json["id"],
      status: json["status"],
      title: json["title"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}
