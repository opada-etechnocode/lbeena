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
      payload: jsonEncode(message.data),
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
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        navigationToPage(message);
      }
    });
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
          try {
            final payload = response.payload;
            if (payload != null && payload != 'tr') {
              final decoded = jsonDecode(payload);
              if (decoded is Map<String, dynamic>) {
                _openFromData(decoded);
                return;
              }
            }
          } catch (_) {}
          navigationToPage(message);
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
        payload: jsonEncode(message.data),
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
  void navigationToPage(RemoteMessage message) {
    _openFromData({
      ...message.data,
      if (message.notification?.title != null)
        'title': message.notification!.title,
      if (message.notification?.body != null)
        'body': message.notification!.body,
    });
  }

  void navigationToPagePayload(
      Map<String, dynamic> data, RemoteMessage message) {
    _openFromData({...message.data, ...data});
  }

  bool _isOrderPayload(Map<String, dynamic> data) {
    final type =
        '${data['type_notification'] ?? data['type'] ?? ''}'.toLowerCase();
    final isOrderFlag = '${data['is_order']}'.toLowerCase();
    final title = '${data['title'] ?? ''} ${data['body'] ?? ''}';
    final orderId = '${data['order_id'] ?? ''}';
    if (isOrderFlag == '1' || isOrderFlag == 'true') return true;
    if (type == 'order' || type == 'orders') return true;
    if (orderId.isNotEmpty && orderId != 'null') return true;
    return title.contains('طلبية') ||
        title.contains('طلباتي') ||
        title.contains('تم اضافة طلب') ||
        title.contains('تم إضافة طلب');
  }

  void _openFromData(Map<String, dynamic> data) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    if (data['isMessage'].toString() == 'true') {
      ctx.push(
          '/chat/${data['nameAds']}/${data['imageAds']}/${data['imageCompany']}/${data['imageUser']}/${data['nameOwnerAds']}/${data['user_name_person_sender']}/${data['user_id']}/${data['user_id_2']}/${data['ad_id']}/${data['categoryId']}/${data['idBannerOrProduct']}/${data['isBanner']}/${data['isBannerInOut']}/${data['idAdOnwerCompany']}');
      return;
    }

    if (_isOrderPayload(data)) {
      final orderId = '${data['order_id'] ?? '0'}';
      ctx.push(
          '/orderPage/${orderId.isEmpty || orderId == 'null' ? '0' : orderId}/my');
      return;
    }

    if (data['ad_id'] != null) {
      ctx.push(
          '/details/${data['ad_id']}/${data['isBanner']}/${data['company_id']}/${data['banner_id']}/${data['in_out']}/${data['category_id']}');
      return;
    }

    if (data['is_company'] == '1') {
      ctx.push('/company/${data['company_id']}');
      return;
    }

    if (data['post_id'] != null) {
      ctx.push('/postScreen/${data['post_id']}');
      return;
    }

    if (data['reminder_id'] != null) {
      ctx.push(
          '/remindersItem/${data['reminder_id']}/${data['reminder_others']}');
      return;
    }

    if (data['following_id'] != null) {
      ctx.push('/company/${data['following_id']}');
      return;
    }

    if (data['user_id'] != null) {
      ctx.push('/company/${data['user_id']}');
    }
  }
}
