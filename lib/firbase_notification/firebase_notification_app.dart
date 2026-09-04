import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../core/di/di_manager.dart';
import '../core/shared_prefs/shared_prefs.dart';
import '../general_app.dart';

class FirebaseAppForUsers {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
   Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    FlutterLocalNotificationsPlugin().show(
      message.messageId.hashCode,
      message.notification?.title,
      message.notification?.body,
      payload: 'tr',
      NotificationDetails(
        android: AndroidNotificationDetails(
          '188',
          '123',
          icon: '@drawable/ic_launcher',
          importance: Importance.max,
          priority: Priority.high
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentBanner: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
    );
    navigationToPage(message);
  }

  void configureFirebaseMessaging() {
    List<String> messages = [];
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
      final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
      final InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          String? payload = response.payload;
          if (payload != null) {
            Map<String, dynamic> data = jsonDecode(payload);
            navigationToPagePayload (data,message);
          }
        },
      );
      print("Data message received: ${message.data}");
      print("Data message received: ${message.data}");
      print("Data message received: ${message.data}");
      print("Data message received: ${message.data}");
      print("Data message received: ${message.data}");
      print("Data message received: ${message.data}");
      if (message.notification?.body != null) {
        flutterLocalNotificationsPlugin.show(
          message.messageId.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              '188',
              '123',
                icon: '@drawable/ic_launcher',
                importance: Importance.max,
                priority: Priority.high
            ),
            iOS: DarwinNotificationDetails(
              presentSound: true,
              presentBanner: true,
              presentAlert: true,
              presentBadge: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Data message opened: ${message.data}");
      print("Data message opened: ${message.data}");
      print("Data message opened: ${message.data}");
      print("Data message opened: ${message.data}");
      print("Data message opened: ${message.data}");
      print("Data message opened: ${message.data}");
      print("Data message opened: ${message.data}");
      if (message.notification?.body != null) {
        messages.add(message.notification!.body!);
      }
      FlutterLocalNotificationsPlugin().show(
        message.messageId.hashCode,
        message.notification!.title,
        message.notification!.body,
        payload: 'tr',
        NotificationDetails(
          android: AndroidNotificationDetails(
            '188',
            '123',
              icon: '@drawable/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            styleInformation: InboxStyleInformation(
              messages.map((message) => message).toList(),
              contentTitle: '${messages.length} new messages',
              summaryText: '${messages.length} messages',
            ),
          ),
          iOS: DarwinNotificationDetails(
// subtitle:    '${message.notification!.title}',
            presentSound: true,
            presentBanner: true,
            presentAlert: true,
            presentBadge: true,
          ),
        ),
      );
      navigationToPage(message);
    });
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> initFirebaseMessaging() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

  }

  Future<void> getDeviceToken() async {

    await firebaseMessaging.getToken().then((token) {
      print("Device token is $token");
      DIManager.findDep<SharedPrefs>().setDeviceToken(token);
    }).catchError((e) {
      print("Error in getting device token: $e");
    });
  }
  Future<void> initFirebaseMessagingAndSaveDeviceToken() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if(DIManager.findDep<SharedPrefs>().getToken() == null)
    {

      await firebaseMessaging.getToken().then((token) {
        print("Device token is $token");
        DIManager.findDep<SharedPrefs>().setDeviceToken(token);
      }).catchError((e) {
        print("Error in getting device token: $e");
      });
    }

    // Request permission to receive notifications

  }
  Future<void> toggleNotifications() async {
   try{
     if (DIManager.findDep<SharedPrefs>().getSubscribeToNotification() ==false) {
       await firebaseMessaging.requestPermission();
       await firebaseMessaging.subscribeToTopic('all');
       DIManager.findDep<SharedPrefs>().setSubscribeToNotification(true);
       print(DIManager.findDep<SharedPrefs>().getSubscribeToNotification());
     } else {
       await firebaseMessaging.unsubscribeFromTopic('all');
       DIManager.findDep<SharedPrefs>().setSubscribeToNotification(false);
     }
   }catch (e,stack){
     print('$e  $stack');
   }
  }
  void navigationToPage(RemoteMessage message){
    if (message.data['isMessage'].toString() == "true") {
      navigatorKey.currentContext!.push(
          '/chat/${message.data['nameAds']}/${message.data['imageAds']}/${message.data['imageCompany']}/${message.data['imageUser']}/${message.data['nameOwnerAds']}/${message.data['user_name_person_sender']}/${message.data['user_id']}/${message.data['user_id_2']}/${message.data['ad_id']}/${message.data['categoryId']}/${message.data['idBannerOrProduct']}/${message.data['isBanner']}/${message.data['isBannerInOut']}/${message.data['idAdOnwerCompany']}');
    }else
    if (message.data['ad_id'] != null) {
      navigatorKey.currentContext!.push('/details/${message.data['ad_id']}/${message.data['isBanner']}/${message.data['company_id']}/${message.data['banner_id']}/${message.data['in_out']}/${message.data['category_id']}');
    }else

    if (message.data['is_company'] == '1') {
      navigatorKey.currentContext!.push('/company/${message.data['company_id']}');
    }else

    if (message.data['post_id'] !=null) {
      navigatorKey.currentContext!.push('/postScreen/${message.data['post_id']}');
    } else
    if (message.data['reminder_id'] !=null) {
      navigatorKey.currentContext!.push('/remindersItem/${message.data['reminder_id']}/${message.data['reminder_others']}');
    } else
    if (message.data['following_id'] != null) {
      navigatorKey.currentContext!.push(
          '/company/${message.data['following_id']}');
    } else
    if (message.data['user_id']!= null) {
      navigatorKey.currentContext!.push('/company/${message.data['user_id']}');
    }
    else if(message.data['is_order'] =='1'){
      navigatorKey.currentContext!.push(
          '/orderPage/${message.data['order_id']}/${message.data['order_type']}');
    }
  }

  void navigationToPagePayload (Map<String, dynamic> data,RemoteMessage message) {
    if (data['isMessage'].toString() == "true") {
      navigatorKey.currentContext!.push(
          '/chat/${message.data['nameAds']}/${message.data['imageAds']}/${message.data['imageCompany']}/${message.data['imageUser']}/${message.data['nameOwnerAds']}/${message.data['user_name_person_sender']}/${message.data['user_id']}/${message.data['user_id_2']}/${message.data['ad_id']}/${message.data['categoryId']}/${message.data['idBannerOrProduct']}/${message.data['isBanner']}/${message.data['isBannerInOut']}/${message.data['idAdOnwerCompany']}');
    }else
    if (message.data['ad_id'] != null) {
      navigatorKey.currentContext!.push(
          '/details/${message.data['ad_id']}/${message.data['isBanner']}/${message.data['company_id']}/${message.data['banner_id']}/${message.data['in_out']}/${message.data['category_id']}');
    }else

    if (message.data['is_company'] == '1') {
      navigatorKey.currentContext!.push(
          '/company/${message.data['company_id']}');
    }else

    if (message.data['post_id'] !=null) {
      navigatorKey.currentContext!.push(
          '/postScreen/${message.data['post_id']}');
    } else
    if (message.data['reminder_id'] !=null) {
      navigatorKey.currentContext!.push(
          '/remindersItem/${message.data['reminder_id']}/${message.data['reminder_others']}');
    } else
    if (message.data['following_id'] != null) {
      navigatorKey.currentContext!.push(
          '/company/${message.data['following_id']}');
    } else
    if (message.data['user_id']!= null) {
      navigatorKey.currentContext!.push('/company/${message.data['user_id']}');
    }else if(message.data['is_order'] =='1'){
      navigatorKey.currentContext!.push(
          '/orderPage/${message.data['order_id']}/${message.data['order_type']}');
    }
  }
}
