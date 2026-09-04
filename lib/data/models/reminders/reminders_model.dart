class RemindersModel {
  RemindersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final RemindersData? data;

  factory RemindersModel.fromJson(Map<String, dynamic> json){
    return RemindersModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : RemindersData.fromJson(json["data"]),
    );
  }

}

class RemindersData {
  RemindersData({
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
  final List<RemindersListModel> data;
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

  factory RemindersData.fromJson(Map<String, dynamic> json){
    return RemindersData(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<RemindersListModel>.from(json["data"]!.map((x) => RemindersListModel.fromJson(x))),
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

class RemindersListModel {
  RemindersListModel({
    required this.id,
    required this.description,
    required this.reminderDate,
    required this.reminderTime,
    required this.repeatType,
    required this.notifyBefore,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.sent,
    required this.remind_others,
    required this.phone_number,
  });

  final int? id;
  final String? description;
  final String? phone_number;
  final String? reminderDate;
  final String? reminderTime;
  final String? repeatType;
  final String? notifyBefore;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? userId;
  final int? sent;
  final int? remind_others;

  factory RemindersListModel.fromJson(Map<String, dynamic> json){
    return RemindersListModel(
      id: json["id"],
      remind_others: json["reminder_others"],
      description: json["description"],
      phone_number: json["phone_number"],
      reminderDate: json["reminder_date"]?.toString(),
      reminderTime: json["reminder_time"]?.toString(),
      repeatType: json["repeat_type"]?.toString(),
      notifyBefore: json["notify_before"]?.toString(),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      userId: json["user_id"],
      sent: json["sent"],
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
