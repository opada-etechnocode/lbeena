class VoicesModel {
  VoicesModel({
    required this.success,
    required this.data,
  });

  final bool? success;
  final DataVoices? data;

  factory VoicesModel.fromJson(Map<String, dynamic> json){
    return VoicesModel(
      success: json["success"],
      data: json["data"] == null ? null : DataVoices.fromJson(json["data"]),
    );
  }

}

class DataVoices {
  DataVoices({
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
  final List<VoiceModel> data;
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

  factory DataVoices.fromJson(Map<String, dynamic> json){
    return DataVoices(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<VoiceModel>.from(json["data"]!.map((x) => VoiceModel.fromJson(x))),
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

class VoiceModel {
  VoiceModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.hashtagVoiceSelectionId,
    required this.name,
  });

  final int? id;
  final int? userId;
  final String? title;
  final String? fileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? hashtagVoiceSelectionId;
  final String? name;

  factory VoiceModel.fromJson(Map<String, dynamic> json){
    return VoiceModel(
      id: json["id"],
      userId: json["user_id"],
      title: json["title"],
      fileUrl: json["file_url"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      hashtagVoiceSelectionId: json["hashtag_voice_selection_id"],
      name: json["name"],
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
