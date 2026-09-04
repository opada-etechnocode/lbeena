

import 'package:syrians_in_uae/data/models/home_page/categorie_part.dart';
import 'package:syrians_in_uae/data/models/home_page/categories_main.dart';
import 'package:syrians_in_uae/data/models/home_page/home_page_model.dart';

import '../../../../../data/models/auth/login/login_model.dart';
import '../../../../../data/models/home_page/ads_evaluation_model.dart';
import '../../../../../data/models/home_page/ads_random_model.dart';
import '../../../../../data/models/home_page/app_terms_policy_model.dart';
import '../../../../../data/models/notifications/all_notifications_model.dart';
import '../../../../../data/models/status_user.dart';

abstract class LoginStates  {}

class InitialLoginState extends LoginStates {
}

class LoadingLoginState extends LoginStates {

}

class SuccessLoginState extends LoginStates {
  final LoginModel loginModel;
  SuccessLoginState(this.loginModel);
}

class ErrorLoginState extends LoginStates {
  final LoginModel error;
  ErrorLoginState(this.error);
}