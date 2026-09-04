class EffectivenessModel {
  EffectivenessModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<Effectiveness> data;

  factory EffectivenessModel.fromJson(Map<String, dynamic> json){
    return EffectivenessModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Effectiveness>.from(json["data"]!.map((x) => Effectiveness.fromJson(x))),
    );
  }

}

class Effectiveness {
  Effectiveness({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.featuredImageOne,
    required this.number,
    required this.date,
    required this.createdAt,
    required this.link,
    required this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? shortDescription;
  final String? link;
  final dynamic featuredImageOne;
  final String? number;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Effectiveness.fromJson(Map<String, dynamic> json){
    return Effectiveness(
      id: json["id"],
      title: json["title"],
      shortDescription: json["short_description"],
      link: json["link"],
      featuredImageOne: json["featured_image_one"],
      number: json["number"],
      date: DateTime.tryParse(json["date"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
