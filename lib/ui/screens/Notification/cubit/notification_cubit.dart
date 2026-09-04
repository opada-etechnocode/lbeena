import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:syrians_in_uae/data/models/notifications/all_notifications_model.dart';
import 'package:syrians_in_uae/data/sources/notifications/notifications_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/GeneralResult.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  static NotificationCubit get(context) => BlocProvider.of(context);

  /// get All Notifications User
  Future<void> getAllNotifications() async {
    NotificationsDataSourceImpl getAllNotificationsSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingGetAllNotificationsState());

      var getAllNotifications =
      await getAllNotificationsSourceImpl.getAllNotifications();
      if (getAllNotifications.data != null) {
        emit(SuccessGetAllNotificationsState(getAllNotifications.data!));
      } else {
        emit(ErrorGetAllNotificationsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In GetAllNotificationsState is : $e in $stack");
      emit(ErrorGetAllNotificationsState("Error is $e"));
    }
  }

  /// Delete All Notifications User
  Future<void> deleteAllNotifications() async {
    NotificationsDataSourceImpl deleteAllNotificationsSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingDeleteAllNotificationsState());

      var deleteAllNotifications =
      await deleteAllNotificationsSourceImpl.deleteAllNotifications();
      if (deleteAllNotifications.data != null) {
        emit(SuccessDeleteAllNotificationsState(deleteAllNotifications.data!));
        getAllNotifications();
        readAllNotifications();
        DIManager.findDep<SharedPrefs>().setCounterNotifications(0);
      } else {
        emit(ErrorDeleteAllNotificationsState(deleteAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorDeleteAllNotificationsState is : $e in $stack");
      emit(ErrorDeleteAllNotificationsState("Error is $e"));
    }
  }

  /// Delete All Notifications User
  Future<void> deleteOneNotifications({
    required int idNotification
}) async {
    NotificationsDataSourceImpl deleteAllNotificationsSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingDeleteOneNotificationsState());

      var deleteAllNotifications =
      await deleteAllNotificationsSourceImpl.deleteOneNotifications(idNotifications: idNotification);
      if (deleteAllNotifications.data != null) {
        emit(SuccessDeleteOneNotificationsState(deleteAllNotifications.data!));
        getAllNotifications();
      } else {
        emit(ErrorDeleteOneNotificationsState(deleteAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorDeleteAllNotificationsState is : $e in $stack");
      emit(ErrorDeleteOneNotificationsState("Error is $e"));
    }
  }
  /// read ads Notifications User
  Future<void> readAdsNotifications({required int idAds}) async {
    NotificationsDataSourceImpl getAllNotificationsSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingReadAdsNotificationsState());

      var getAllNotifications =
      await getAllNotificationsSourceImpl.readNotificationAds(idAds: idAds);
      if (getAllNotifications.data != null) {
        emit(SuccessReadAdsNotificationsState(getAllNotifications.data!));
      } else {
        emit(ErrorReadAdsNotificationsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ReadAdsNotificationsState is : $e in $stack");
      emit(ErrorReadAdsNotificationsState("Error is $e"));
    }
  }

  Future<void> readAllNotifications() async {
    NotificationsDataSourceImpl getAllNotificationsSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(LoadingReadAdsNotificationsState());

      var getAllNotifications =
      await getAllNotificationsSourceImpl.readAllNotification();
      if (getAllNotifications.data != null) {
        emit(SuccessReadAdsNotificationsState(getAllNotifications.data!));
      } else {
        emit(ErrorReadAdsNotificationsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ReadAdsNotificationsState is : $e in $stack");
      emit(ErrorReadAdsNotificationsState("Error is $e"));
    }
  }

}
