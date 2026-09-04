class AllServicesTeamModel {
  AllServicesTeamModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final List<ServiceTeamList> data;

  factory AllServicesTeamModel.fromJson(Map<String, dynamic> json){
    return AllServicesTeamModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<ServiceTeamList>.from(json["data"]!.map((x) => ServiceTeamList.fromJson(x))),
    );
  }

}

class ServiceTeamList {
  ServiceTeamList({
    required this.id,
    required this.name,
    required this.image,
    required this.mobile,
    required this.description,
    required this.createdAt,
  });

  final int? id;
  final String? name;
  final String? image;
  final String? mobile;
  final String? description;
  final DateTime? createdAt;

  factory ServiceTeamList.fromJson(Map<String, dynamic> json){
    return ServiceTeamList(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      mobile: json["mobile"],
      description: json["description"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

}
