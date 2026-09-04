import 'package:syrians_in_uae/data/models/reminders/reminders_model.dart';

class ReminderItemModel {
  ReminderItemModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final RemindersListModel? data;

  factory ReminderItemModel.fromJson(Map<String, dynamic> json){
    return ReminderItemModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : RemindersListModel.fromJson(json["data"]),
    );
  }

}

