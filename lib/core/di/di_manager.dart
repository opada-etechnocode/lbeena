import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../data/sources/chats/chat_remote_data_source_firebase.dart';
import '../../repos/chat_repo_i_firebase.dart';
import '../../repos/impl_chat_repo_firebase.dart';
import '../../ui/screens/chats/cubit/cubit.dart';
import '../navigator/app_navigator.dart';
import '../shared_prefs/shared_prefs.dart';


import 'package:get_storage/get_storage.dart';
final getIt = GetIt.instance;

class DIManager {
  DIManager._();

  static Future<void> initDI() async {
    _injectDep(
      AppNavigator(),
    );
    /// Shared Prefs
    await _setupSharedPreference();

    /// Chat' Firebase  Remotes
    _injectDepLazy<ChatRemoteDataSourceFirebase>(ChatRemoteDataSourceFirebaseImplFirebase());

    /// Chat' Repo Firebase
    _injectDepLazy<ChatFacadeFirebase>(
      ChatRepoFirebase(
        findDep(),
        findDep(),
      ) ,
    );

    /// Chat' Blocs
    _injectDep(
      ChatCubitFirebase(adsRepo: findDep<ChatFacadeFirebase>()),
    );

  }
  static _setupSharedPreference() async {
    await GetStorage.init();
    _injectDep(SharedPrefs());
  }
  static AppNavigator findNavigator() {
    return findDep<AppNavigator>();
  }
  static T _injectDep<T extends Object>(T dependency) {
    getIt.registerSingleton<T>(dependency);
    return getIt<T>();
  }

  static void _injectDepLazy<T extends Object>(T dependency) {
    getIt.registerLazySingleton<T>(() => dependency);
  }

  static Future<void> _injectDepLazyAsync<T extends Object>(
      T dependency,
      ) async {
    getIt.registerLazySingletonAsync<T>(() async => dependency);
    return null;
  }

  static T findDep<T extends Object>() {
    return getIt<T>();
  }

  static Dio setupDio() {
    if (getIt.isRegistered<Dio>()) {
      return getIt<Dio>();
    }
    return getIt.registerSingleton<Dio>(Dio());
  }

  static Future<T> findDepAsync<T extends Object>() async {
    return getIt.getAsync<T>();
  }


}
