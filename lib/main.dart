import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/di_manager.dart';
import 'core/helper/bloc_observer.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firbase_notification/firebase_notification_app.dart';
import 'firbase_notification/firebase_options.dart';
import 'my_app.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await DIManager.initDI();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  firebaseApp.configureFirebaseMessaging();
  usePathUrlStrategy();
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  runApp(

      // DevicePreview(
      //         enabled: true,
      //         tools: const [
      //           ...DevicePreview.defaultTools,
      //         ],
      //         builder: (context) => const MyApp(),));

      // usePathUrlStrategy();
      const MyApp());
}

FirebaseAppForUsers firebaseApp = FirebaseAppForUsers();
