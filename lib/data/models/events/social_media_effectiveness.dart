class SocialMediaEffectivenessModel {
  SocialMediaEffectivenessModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<SocialMediaEffectiveness> data;

  factory SocialMediaEffectivenessModel.fromJson(Map<String, dynamic> json){
    return SocialMediaEffectivenessModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<SocialMediaEffectiveness>.from(json["data"]!.map((x) => SocialMediaEffectiveness.fromJson(x))),
    );
  }

}

class SocialMediaEffectiveness {
  SocialMediaEffectiveness({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.status,
    required this.createdAt,
  });

  final int? id;
  final String? title;
  final String? url;
  final String? image;
  final int? status;
  final DateTime? createdAt;

  factory SocialMediaEffectiveness.fromJson(Map<String, dynamic> json){
    return SocialMediaEffectiveness(
      id: json["id"],
      title: json["title"],
      url: json["url"],
      image: json["image"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

}
