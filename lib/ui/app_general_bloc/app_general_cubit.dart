import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syrians_in_uae/ui/app_general_bloc/app_general_state.dart';

import '../../core/di/di_manager.dart';
import '../../core/shared_prefs/shared_prefs.dart';
import '../../data/sources/app_general/app_general_source.dart';

class AppGeneralCubit extends Cubit<AppGeneralState> {
  AppGeneralCubit() : super(AppGeneralInitial());

  static AppGeneralCubit get(context) => BlocProvider.of(context);

  Future<void> deletedDeviceToken() async {
    AppGeneralDataSourceImpl deletedDeviceToken =
        const AppGeneralDataSourceImpl();
    try {
      emit(LoadingDeletedDeviceTokenState());
      var data = await deletedDeviceToken.deletedDeviceToken();
      if (data.data != null) {
        emit(SuccessDeletedDeviceTokenState(data.data!));
      } else {
        emit(ErrorDeletedDeviceTokenState());
      }
    } catch (e, stack) {
      print("Error In ErrorMyOrderState is : $e in $stack");
      emit(ErrorDeletedDeviceTokenState());
    }
  }


  bool notificationEnable = DIManager.findDep<SharedPrefs>().getSubscribeToNotification();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> toggleNotifications() async {
    try {
      if (DIManager.findDep<SharedPrefs>().getSubscribeToNotification() == false) {
        DIManager.findDep<SharedPrefs>().setSubscribeToNotification(true);
        notificationEnable = true;
        deletedDeviceToken();
      } else {
        DIManager.findDep<SharedPrefs>().setSubscribeToNotification(false);
        notificationEnable = false;
        deletedDeviceToken();
      }
    } catch (e, stack) {
      print('Error toggling notifications: $e  $stack');
    }
  }
}
