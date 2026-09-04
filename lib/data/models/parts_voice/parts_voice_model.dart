class PartsVoiceModel {
  PartsVoiceModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<PartsVoiceList> data;

  factory PartsVoiceModel.fromJson(Map<String, dynamic> json){
    return PartsVoiceModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<PartsVoiceList>.from(json["data"]!.map((x) => PartsVoiceList.fromJson(x))),
    );
  }

}

class PartsVoiceList {
  PartsVoiceList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PartsVoiceList.fromJson(Map<String, dynamic> json){
    return PartsVoiceList(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
