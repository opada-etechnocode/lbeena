class StatusRecorderModel {
  StatusRecorderModel({
    required this.status,
    required this.message,
    required this.is_allow_voice,
    required this.allow_voice_time,
    required this.is_blocked,
    required this.is_permission_chat,
  });

  final bool? status;
  final String? message;
  final int? is_allow_voice;
  final int? allow_voice_time;
  final int? is_blocked;
  final int? is_permission_chat;

  factory StatusRecorderModel.fromJson(Map<String, dynamic> json){
    return StatusRecorderModel(
      status: json["status"],
      message: json["message"],
      is_allow_voice: json["is_allow_voice"],
      allow_voice_time: json["allow_voice_time"],
      is_blocked: json["is_blocked"],
      is_permission_chat: json["is_permission_chat"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "is_allow_voice": is_allow_voice,
    "allow_voice_time": allow_voice_time,
    "is_blocked": is_blocked,
    "is_permission_chat": is_permission_chat,
  };

}
