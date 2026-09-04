
import 'package:syrians_in_uae/data/models/parts_voice/parts_voice_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/auth/otp/otp_model.dart';
import '../../models/parts_voice/voices_model.dart';
import '../../models/reminders/item_reminder.dart';
import '../../models/reminders/reminders_model.dart';

abstract class RemindersDataSource {
  const RemindersDataSource();
  Future<Result<ReminderItemModel>> addReminder({
    required String description,
    required String reminderDate,
    required String reminderTime,
    String? repeatType,
    String? mobileNumber,
    required bool isHaveWhatsapp,
  });
  Future<Result<RemindersModel>> getReminders({
    required int page,
    required String status,
  });
  Future<Result<ReminderItemModel>> editReminder({
    required String description,
    required String reminderDate,
    required String reminderTime,
    String? repeatType,
    String? phoneNumber,
    required int reminderOthers,
    required int idReminder,
  });
  @override
  Future<Result<RemindersModel>> deleteReminders({
    required int idReminder,
    required int reminderOthers,
  });

  Future<Result<ReminderItemModel>> getItemReminder({
    required int idReminder,
    required int reminderOthers,
  });
}

class RemindersDataSourceImpl implements RemindersDataSource {
  const RemindersDataSourceImpl();

  @override
  Future<Result<ReminderItemModel>> addReminder({
    required String description,
    required String reminderDate,
    required String reminderTime,
    String? repeatType,
    String? mobileNumber,
    required bool isHaveWhatsapp,
}) async {
    return await RemoteDataSource.request<ReminderItemModel>(
      converter: (model) => ReminderItemModel.fromJson(model),
      method: HttpMethod.POST,
      data:isHaveWhatsapp? {
        "description":description,
        "reminder_date":reminderDate,
        "reminder_time":reminderTime,
        "phone_number":mobileNumber,
      }: {
"description":description,
"reminder_date":reminderDate,
"reminder_time":reminderTime,
"repeat_type":repeatType,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: isHaveWhatsapp ?("${AppEndpoints.baseUrl}mobile/send_reminders"):("${AppEndpoints.baseUrl}mobile/reminders"),
    );
  }


  @override
  Future<Result<ReminderItemModel>> editReminder({
    required String description,
    required String reminderDate,
    required String reminderTime,
    String? repeatType,
    String? phoneNumber,
    required int reminderOthers,
    required int idReminder,
  }) async {
    return await RemoteDataSource.request<ReminderItemModel>(
      converter: (model) => ReminderItemModel.fromJson(model),
      method: HttpMethod.POST,
      data: reminderOthers ==1?{
        "description":description,
        "reminder_date":reminderDate,
        "reminder_time":reminderTime,
        "reminder_others":1,
        "phone_number":phoneNumber,
      }: {
        "description":description,
        "reminder_date":reminderDate,
        "reminder_time":reminderTime,
        "repeat_type":repeatType,
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/reminders_edit/$idReminder",
    );
  }

  @override
  Future<Result<RemindersModel>> getReminders({
    required int page,
    required String status,
}) async {
    return await RemoteDataSource.request<RemindersModel>(
      converter: (model) => RemindersModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "status":status,
      },
      queryParameters: {
        "page":page,

      },
      url: "${AppEndpoints.baseUrl}mobile/reminders_get",
    );
  }

  @override
  Future<Result<ReminderItemModel>> getItemReminder({
    required int idReminder,
    required int reminderOthers,
  }) async {
    return await RemoteDataSource.request<ReminderItemModel>(
      converter: (model) => ReminderItemModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "reminder_others":reminderOthers,
      },
      url: "${AppEndpoints.baseUrl}mobile/reminders/$idReminder",
    );
  }

  @override
  Future<Result<RemindersModel>> deleteReminders({
    required int idReminder,
    required int reminderOthers,
  }) async {
    return await RemoteDataSource.request<RemindersModel>(
      converter: (model) => RemindersModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        'reminder_others':reminderOthers
      },
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/reminders_delete/$idReminder",
    );
  }
}
