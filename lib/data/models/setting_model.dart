class     SettingAppModel {
  SettingAppModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<SettingApp> data;

  factory SettingAppModel.fromJson(Map<String, dynamic> json){
    return SettingAppModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<SettingApp>.from(json["data"]!.map((x) => SettingApp.fromJson(x))),
    );
  }

}

class SettingApp {
  SettingApp({
    required this.allowAdsUsers,
    required this.allowChat,
    required this.underMaintenance,
    required this.controlMessage,
    required this.font_type,
  });

  final int? allowAdsUsers;
  final int? allowChat;
  final int? underMaintenance;
  final String? controlMessage;
  final String? font_type;

  factory SettingApp.fromJson(Map<String, dynamic> json){
    return SettingApp(
      allowAdsUsers: json["allow_ads_users"],
      allowChat: json["allow_chat"],
      underMaintenance: json["under_maintenance"],
      controlMessage: json["control_message"],
      font_type: json["font_type"],
    );
  }

}



class GetSectionModel {
  GetSectionModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<GetSectionData> data;

  factory GetSectionModel.fromJson(Map<String, dynamic> json){
    return GetSectionModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<GetSectionData>.from(json["data"]!.map((x) => GetSectionData.fromJson(x))),
    );
  }

}

class GetSectionData {
  GetSectionData({
    required this.title,
    required this.link,
  });

  final String? title;
  final String? link;

  factory GetSectionData.fromJson(Map<String, dynamic> json){
    return GetSectionData(
      title: json["title"],
      link: json["link"],
    );
  }

}
