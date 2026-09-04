import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:syrians_in_uae/data/models/notifications/all_notifications_model.dart';
import 'package:syrians_in_uae/data/sources/notifications/notifications_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import 'notification_cubit.dart';


class NotificationCounterCubit extends Cubit<int> {
  NotificationCounterCubit() : super(0);
  static NotificationCubit get(context) => BlocProvider.of(context);


  /// UnRead Notifications User
  Future<void> unReadNotifications({required int notificationLength}) async {
    NotificationsDataSourceImpl getAllNotificationsSourceImpl =
    const NotificationsDataSourceImpl();
    try {
      emit(notificationLength);
      var getAllNotifications =
      await getAllNotificationsSourceImpl.getUnReadNotifications();
      if (getAllNotifications.data != null) {

          // emit(SuccessUnReadNotificationsState(getAllNotifications.data!));
          emit(getAllNotifications.data!.data.length);
          print("UnRead Notifications is : ${getAllNotifications.data!.data.length}");

      } else {

          emit(0);
          // emit(ErrorUnReadNotificationsState(
          //     getAllNotifications.error!.message!));

      }
    } catch (e, stack) {
      print("Error In ErrorUnReadNotificationsState is : $e in $stack");

       emit(0);
        // emit(ErrorUnReadNotificationsState("Error is $e"));

    }
  }

}
