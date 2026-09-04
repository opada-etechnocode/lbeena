class ClickStatisticsModel {
  ClickStatisticsModel({
    required this.status,
    required this.message,
    required this.clicksShare,
    required this.clicksWhatsapp,
    required this.clicksChat,
  });

  final bool? status;
  final String? message;
  final String? clicksShare;
  final String? clicksWhatsapp;
  final String? clicksChat;

  factory ClickStatisticsModel.fromJson(Map<String, dynamic> json){
    return ClickStatisticsModel(
      status: json["status"],
      message: json["message"],
      clicksShare: json["clicks_share"]?.toString(),
      clicksWhatsapp: json["clicks_whatsapp"]?.toString(),
      clicksChat: json["clicks_chat"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "clicks_share": clicksShare,
    "clicks_whatsapp": clicksWhatsapp,
    "clicks_chat": clicksChat,
  };

}
