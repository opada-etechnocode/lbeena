import 'package:syrians_in_uae/data/models/auth/login/login_model.dart';
import 'package:syrians_in_uae/data/sources/home_page/home_page_data_source.dart';
import 'package:syrians_in_uae/ui/screens/auth/login/cubit/status.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/di_manager.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../../data/sources/auth/auth_remote_data_source.dart';
import '../../../../../data/sources/notifications/notifications_data_source.dart';
import '../../../chats/cubit/apis_chat_firebase.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialLoginState());
  static LoginCubit get(context) => BlocProvider.of(context);

  Future<void> login(String phone, String password) async {
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
        const AuthRemoteDataSourceImpl();
    try {
      emit(LoadingLoginState());

      var authentication =
          await authRemoteDataSourceImpl.login(phone, password);



      if (authentication.data!.data != null) {
        unSubscribeToTopic();
        emit(SuccessLoginState(authentication.data!));
      } else {
        emit(ErrorLoginState(authentication.data!));
      }
    } catch (e, stack) {
      print("Error In Login is : $e in $stack");
      emit(ErrorLoginState(LoginModel(
        data: null,
        is_mobile_verified: null,
        message: 'Error In Login',
        status: 'error'
      )));
    }
  }

}


void unSubscribeToTopic() async{

  try {
    await FirebaseMessaging.instance.unsubscribeFromTopic('unregistered');
    if(DIManager.findDep<SharedPrefs>().getToken() != null){

      await FirebaseMessaging.instance.subscribeToTopic('registered');
    }
    if(DIManager.findDep<SharedPrefs>().getAccountType() =='company'){
      await FirebaseMessaging.instance.subscribeToTopic('registeredCompany');
    }
    if(DIManager.findDep<SharedPrefs>().getAccountType() =='individual'){
      await FirebaseMessaging.instance.subscribeToTopic('registeredIndividual');
    }
    print('Successfully unsubscribed to topic');
  } catch (e) {
    print('Failed to unsubscribed to topic: $e');
  }
}