class CalenderModel {
  CalenderModel({
    required this.status,
    required this.data,
    required this.message,
  });

  final bool? status;
  final List<Calender> data;
  final String? message;

  factory CalenderModel.fromJson(Map<String, dynamic> json){
    return CalenderModel(
      status: json["status"],
      data: json["data"] == null ? [] : List<Calender>.from(json["data"]!.map((x) => Calender.fromJson(x))),
      message: json["message"],
    );
  }

}

class Calender {
  Calender({
    required this.id,
    required this.country,
    required this.name,
    required this.date,
    required this.description,
    required this.isRecurring,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? country;
  final String? name;
  final DateTime? date;
  final dynamic description;
  final int? isRecurring;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Calender.fromJson(Map<String, dynamic> json){
    return Calender(
      id: json["id"],
      country: json["country"],
      name: json["name"],
      date: DateTime.tryParse(json["date"] ?? ""),
      description: json["description"],
      isRecurring: json["is_recurring"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
