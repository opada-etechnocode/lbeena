class SendNotificationsForUserModel {
  SendNotificationsForUserModel({
    required this.multicastId,
    required this.success,
    required this.failure,
    required this.canonicalIds,
    required this.results,
  });

  final String? multicastId;
  final String? success;
  final String? failure;
  final String? canonicalIds;
  final List<ResultMessage> results;

  factory SendNotificationsForUserModel.fromJson(Map<String, dynamic> json){
    return SendNotificationsForUserModel(
      multicastId: json["multicast_id"].toString(),
      success: json["success"].toString(),
      failure: json["failure"].toString(),
      canonicalIds: json["canonical_ids"].toString(),
      results: json["results"] == null ? [] : List<ResultMessage>.from(json["results"]!.map((x) => ResultMessage.fromJson(x))),
    );
  }

}

class ResultMessage {
  ResultMessage({
    required this.messageId,
  });

  final String? messageId;

  factory ResultMessage.fromJson(Map<String, dynamic> json){
    return ResultMessage(
      messageId: json["message_id"]?.toString(),
    );
  }

}
