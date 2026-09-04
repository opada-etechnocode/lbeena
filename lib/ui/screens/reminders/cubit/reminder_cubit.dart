// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
// import 'package:radio_player/radio_player.dart';
import 'package:syrians_in_uae/ui/screens/reminders/cubit/reminder_state.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/reminders/reminders_model.dart';
import '../../../../data/sources/reminders/reminders_page_data_source.dart';

// import 'package:assets_audio_player/assets_audio_player.dart' as not;
class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  static ReminderCubit get(context) => BlocProvider.of(context);


  Future<void> addReminder({
    required String description,
    required String reminderDate,
    required String reminderTime,
    String? repeatType,
    String? mobileNumber,
    bool isHaveWhatsapp =false,
  }) async {
    RemindersDataSourceImpl remindersDataSourceImpl =
    const RemindersDataSourceImpl();
    try {
      emit(AddReminderLoadingState());

      var remindersData = await remindersDataSourceImpl.addReminder(
          description: description, reminderDate: reminderDate, reminderTime: reminderTime, repeatType: repeatType,
      isHaveWhatsapp: isHaveWhatsapp,
        mobileNumber: mobileNumber,
      );
      if (remindersData.data != null) {
        //
        // remindersList.add(remindersData.data!.data!);
        // final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss a'); // تنسيق التاريخ والوقت مع AM/PM
        //
        // remindersList.sort((a, b) {
        //   DateTime dateA = dateFormat.parse(a.reminderDate!);
        //   DateTime dateB = dateFormat.parse(b.reminderDate!);
        //   return dateA.compareTo(dateB);
        // });
        emit(AddReminderSuccessState(remindersData.data!));
      } else {
        emit(AddReminderErrorState(remindersData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(AddReminderErrorState(e.toString()));
    }
  }
  Future<void> editReminder({
    required String description,
    required String reminderDate,
    required String reminderTime,
    String? repeatType,
    String? phoneNumber,
    required int reminderOthers,
    required int idReminder,
  }) async {
    RemindersDataSourceImpl remindersDataSourceImpl =
    const RemindersDataSourceImpl();
    try {
      emit(EditReminderLoadingState());

      var remindersData = await remindersDataSourceImpl.editReminder(
          description: description, reminderDate: reminderDate, reminderTime: reminderTime, repeatType: repeatType,idReminder:idReminder ,phoneNumber:phoneNumber,reminderOthers: reminderOthers );
      if (remindersData.data != null) {
        emit(EditReminderSuccessState(remindersData.data!));
      } else {
        emit(EditReminderErrorState(remindersData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(EditReminderErrorState(e.toString()));
    }
  }
  List<RemindersListModel> remindersList=[];
  List<RemindersListModel> archiveRemindersList=[];
  Future<void> getReminder({
    required int page,
    required String status,
     bool isNotNeedLoading =true,
  }) async {
    RemindersDataSourceImpl remindersDataSourceImpl =
    const RemindersDataSourceImpl();
    try {
      if(isNotNeedLoading){
        emit(GetRemindersLoadingState());
      }


      var remindersData = await remindersDataSourceImpl.getReminders(page: page,
      status:status );

      if (remindersData.data != null) {
        emit(GetRemindersSuccessState(remindersData.data!));
        if(status !='finished')
        {
          remindersList.addAll(remindersData.data!.data!.data);
          // for (var newReminder in remindersList) {
          //
          //   bool exists = remindersList.any((reminder) => reminder.id == newReminder.id);
          //
          //   if (!exists) {
          //     remindersList.add(newReminder);
          //   }
          // }
        }else {
          archiveRemindersList.addAll(remindersData.data!.data!.data);
        }


      } else {
        emit(GetRemindersErrorState(remindersData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(GetRemindersErrorState(e.toString()));
    }
  }


  Future<void> getItemReminder({
    required int idReminder,
    required int reminderOthers,
  }) async {
    RemindersDataSourceImpl remindersDataSourceImpl =
    const RemindersDataSourceImpl();
    try {
      emit(GetReminderItemLoadingState());

      var remindersData = await remindersDataSourceImpl.getItemReminder(idReminder: idReminder, reminderOthers: reminderOthers);

      if (remindersData.data != null) {
        emit(GetReminderItemSuccessState(remindersData.data!));
      } else {
        emit(GetReminderItemErrorState(remindersData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(GetReminderItemErrorState(e.toString()));
    }
  }

  Future<void> deleteReminder({
    required int idReminder,
    required int reminderOthers,
    required int index,
    bool isArchiveReminder =false
  }) async {
    RemindersDataSourceImpl remindersDataSourceImpl =
    const RemindersDataSourceImpl();
    try {
      emit(DeleteRemindersLoadingState());
      var remindersData = await remindersDataSourceImpl.deleteReminders(idReminder: idReminder,reminderOthers:reminderOthers );

      if (remindersData.data != null) {
        if(index !=-1){
          if(isArchiveReminder){
            archiveRemindersList.removeAt(index);
          }else{
            remindersList.removeAt(index);
          }
        }


        emit(DeleteRemindersSuccessState(remindersData.data!));


      } else {
        emit(DeleteRemindersErrorState(remindersData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(DeleteRemindersErrorState(e.toString()));
    }
  }

  bool statusBackgroundRadio = false;
  bool isPlayingRadio = false;
  ///
  // final assetsAudioPlayer = AssetsAudioPlayer();

  changeStatusBackgroundRadio(){
    statusBackgroundRadio =!statusBackgroundRadio;
    emit(StatusBackgroundRadioState());
  }
  void playRadio() {
    // assetsAudioPlayer.open(
    //     Audio.network(
    //       'https://a8.asurahosting.com:8010/radio.mp3',
    //       headers: {
    //         "Authorization":
    //         'Bearer 4ab16008e0a3a062:5e0ddb92a78e14348ffe2d62d78083c2',
    //         "accept": 'application/json',
    //       },
    //
    //     ),
    //     autoStart: false,
    //     playInBackground:   PlayInBackground.disabledPause,
    //     // playInBackground: statusBackgroundRadio
    //     //     ? PlayInBackground.enabled
    //     //     : PlayInBackground.disabledPause,
    //     headPhoneStrategy: HeadPhoneStrategy.none,
    //     notificationSettings: not.NotificationSettings(
    //         prevEnabled: false,
    //         stopEnabled: statusBackgroundRadio,
    //         seekBarEnabled: true,
    //     )
    //   // ,showNotification: Platform.isAndroid? ReminderCubit.get(context).statusBackgroundRadio:false,
    // );
    //
    // assetsAudioPlayer.isPlaying.listen((playing) {
    //
    //   isPlayingRadio = playing;
    //   emit(ChangeStateRadioState());
    // });
    //

  }

  void stopRadio() {
    // assetsAudioPlayer.stop();
    // assetsAudioPlayer.dispose();
    // isPlayingRadio = false;
    // emit(StopRadioState());
  }

  void stopRadioIfPlay() {
    // if(isPlayingRadio){
    //
    //   pauseRadio();
    // }
  }

  void pauseRadio() {
    // assetsAudioPlayer.pause();
    isPlayingRadio = false;
    emit(PauseRadioState());
  }

  void resumeRadio() {
    // assetsAudioPlayer.play();
    isPlayingRadio = true;
    emit(ResumeRadioState());
  }

}






















//
// List<String> metadata = [];
// RadioPlayer assetsAudioPlayer = RadioPlayer();
// void playRadio() {
//   assetsAudioPlayer.setChannel(
//     title: 'Radio Player',
//     // url: 'https://a8.asurahosting.com:8010/radio.mp3',
//     url: 'https://a8.asurahosting.com:8010/radio.mp3',
//
//     // imagePath: 'assets/images/image_1.jpg',
//   );
//
//   assetsAudioPlayer.stateStream.listen((value) {
//
//     isPlayingRadio = value;
//
//   });
//
//   assetsAudioPlayer.metadataStream.listen((value) {
//
//       metadata = value;
//
//   });
// }
