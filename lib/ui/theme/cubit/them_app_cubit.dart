import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/shared_prefs/shared_prefs.dart';

part 'them_app_state.dart';

class ThemAppCubit extends Cubit<ThemAppState> {
  ThemAppCubit() : super(ThemAppInitial());

  changeTheme(ThemeState state){
    switch (state){
      case ThemeState.initial:
        if(DIManager.findDep<SharedPrefs>().getThemeApp() != null) {
          if(DIManager.findDep<SharedPrefs>().getThemeApp() == 'l'){
            ThemeHelper.toggleDarkMode(false);
            emit(ThemLiteAppState());
          }else {
            ThemeHelper.toggleDarkMode(true);
            emit(ThemDarkAppState());
          }
        }
        break;
      case ThemeState.light:
        DIManager.findDep<SharedPrefs>().setThemeApp('l');
        ThemeHelper.toggleDarkMode(false);
        emit(ThemLiteAppState());
        break;
      case ThemeState.dark:
        DIManager.findDep<SharedPrefs>().setThemeApp('d');
        ThemeHelper.toggleDarkMode(true);
        emit(ThemDarkAppState());
        break;
      default:
    }
  }


  changeLang({
    required String lang
}){
    DIManager.findDep<SharedPrefs>().setLang(lang);

    emit(ChangeLangAppState());
  }
}

enum ThemeState {initial,light,dark}