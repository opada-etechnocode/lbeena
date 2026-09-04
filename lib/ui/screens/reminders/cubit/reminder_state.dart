import 'package:syrians_in_uae/data/models/reminders/reminders_model.dart';
import 'package:syrians_in_uae/ui/screens/reminders/reminder_item.dart';

import '../../../../data/models/reminders/item_reminder.dart';

abstract class ReminderState {}

class ReminderInitial extends ReminderState {}


class AddReminderLoadingState extends ReminderState {}
class AddReminderSuccessState extends ReminderState {
 ReminderItemModel addReminderModel;
 AddReminderSuccessState(this.addReminderModel);
}
class AddReminderErrorState extends ReminderState {
 String error;
 AddReminderErrorState(this.error);

}


class StatusBackgroundRadioState extends ReminderState {}
class StatusNotificationState extends ReminderState {}

class EditReminderLoadingState extends ReminderState {}
class EditReminderSuccessState extends ReminderState {
 ReminderItemModel addReminderModel;
 EditReminderSuccessState(this.addReminderModel);
}
class EditReminderErrorState extends ReminderState {
 String error;
 EditReminderErrorState(this.error);

}


class GetRemindersLoadingState extends ReminderState {}
class GetRemindersSuccessState extends ReminderState {
 RemindersModel remindersModel;
 GetRemindersSuccessState(this.remindersModel);
}
class GetRemindersErrorState extends ReminderState {
 String error;
 GetRemindersErrorState(this.error);

}


class GetReminderItemLoadingState extends ReminderState {}
class GetReminderItemSuccessState extends ReminderState {
 ReminderItemModel  remindersModel;
 GetReminderItemSuccessState(this.remindersModel);
}
class GetReminderItemErrorState extends ReminderState {
 String error;
 GetReminderItemErrorState(this.error);

}


class DeleteRemindersLoadingState extends ReminderState {}
class DeleteRemindersSuccessState extends ReminderState {
 RemindersModel remindersModel;
 DeleteRemindersSuccessState(this.remindersModel);
}
class DeleteRemindersErrorState extends ReminderState {
 String error;
 DeleteRemindersErrorState(this.error);

}




class ChangeStateRadioState extends ReminderState {}
class StopRadioState extends ReminderState {}
class PauseRadioState extends ReminderState {}
class ResumeRadioState extends ReminderState {}