class RelatedNewsModel {
  RelatedNewsModel({
    required this.message,
    required this.success,
    required this.relatedNews,
  });

  final String? message;
  final bool? success;
  final List<RelatedNew> relatedNews;

  factory RelatedNewsModel.fromJson(Map<String, dynamic> json){
    return RelatedNewsModel(
      message: json["message"],
      success: json["success"],
      relatedNews: json["related_news"] == null ? [] : List<RelatedNew>.from(json["related_news"]!.map((x) => RelatedNew.fromJson(x))),
    );
  }

}

class RelatedNew {
  RelatedNew({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.sortOrder,
    required this.createdAt,
    required this.link,
    required this.source,
    required this.image,
    required this.id,
    required this.isTape,
  });

  final String? title;
  final String? description;
  final String? backgroundColor;
  final String? sortOrder;
  final DateTime? createdAt;
  final String? link;
  final String? source;
  final String? image;
  final String? id;
  final String? isTape;

  factory RelatedNew.fromJson(Map<String, dynamic> json){
    return RelatedNew(
      title: json["title"],
      description: json["description"]?.toString(),
      backgroundColor: json["background_color"]?.toString(),
      sortOrder: json["sort_order"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      link: json["link"]?.toString(),
      source: json["source"]?.toString(),
      image: json["Image"]?.toString(),
      id: json["id"]?.toString(),
      isTape: json["is_tape"]?.toString(),
    );
  }

}
