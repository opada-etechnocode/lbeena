import 'dart:convert';

import 'package:syrians_in_uae/data/models/GeneralResult.dart';
import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:syrians_in_uae/data/models/chats/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/company/company_model.dart';
import '../../models/home_page/packages_user_model.dart';
import '../../models/notifications/all_notifications_model.dart';
import '../../models/notifications/send_notifications_to_user.dart';
import '../../../core/utils/endpoints.dart';

abstract class NotificationsDataSource {
  const NotificationsDataSource();

  Future<Result<NotificationsModel>> getAllNotifications();

  Future<Result<GeneralResult>> readAllNotification();

  Future<Result<GeneralResult>> deleteAllNotifications();

  Future<Result<GeneralResult>> deleteOneNotifications(
      {required int idNotifications});

  Future<Result<NotificationsModel>> getUnReadNotifications();
  Future<Result<PackagesUserModel>> getPackagesUser();
  Future<Result<SendNotificationsForUserModel>> sendNotificationsForUser({
    required String deviceToken,
    required String userNamSender,
    required String message,
    required bool isMessage,
    required ArgumentMessage dataMessage,
  });

  Future<Result<GeneralResult>> readNotificationAds({
    required int idAds,
  });
  Future<Result<PackagesUserModel>> payPackagesUser();
}

class NotificationsDataSourceImpl implements NotificationsDataSource {
  const NotificationsDataSourceImpl();

 Future<String> getOAuthToken() async {
    final int iat = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final int exp = iat + 3600;
    final jwt = JWT(
      {
        'iss': 'firebase-adminsdk-fbsvc@syriansinuae-84f35.iam.gserviceaccount.com', // copy value from downloaded json file
        'sub': 'firebase-adminsdk-fbsvc@syriansinuae-84f35.iam.gserviceaccount.com', // copy value from downloaded json file
        'aud': 'https://oauth2.googleapis.com/token',
        'iat': iat,
        'exp': exp,
        'scope': 'https://www.googleapis.com/auth/firebase.messaging',
      },
    );
    var privateKey = "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCgVJg1LnfY7tsV\njSwJQPoOn6SdnGdPHDG+9uHnkaoZm9ecJ8MENvQuk5iCJZvLlYydZNpCc3VG57jj\nEnCzXINWrSIDMBEAl8nMxzQsZoI2nxn4DI9f5LImqFLTCUnbGJyncpxyjjUMFBCJ\njCc+srUr6213PxIxWpPu5pPxJnWywjlrp1G953N0a1jf/7h6p5WUSOuDaM6WnOOs\n0CELRno9dFbt8j0kzoUB072Zd1fVVhNRZ2z+FZN1lRCwJTsK7og+Sr6tgEZeKqa4\nJ/5SJ4m3fuznWAEcwk6dni7OJHw9UAymvPRkMQYy+9CnxSl7dwraubVZP60N+0me\nxcfyfIYRAgMBAAECggEADh75Q2jW8ycxalPjWqLLi1Vt8hhEBJSVAI7dvW+nycbf\nLfCWFWVSKxaCjobpsnv21Sd8bjEdVYwD7ZLylGeL5UrNJbb6bmEQC95JJvZ11kH7\nz2wqxg0+UBeP6Oim5bpElN5sL049V5WeUcEDdVsXyBkdjGzEiU6DHD3Ybps+r0pW\ndUwD7YrLmq5DIxIdpn6S5SaaHlVknsS25/R0vqmugXcHPBiV4L0CU+gMwteDz1hZ\nfpDeDHWuACUU1S+IfhPMNtxI8pl2lZLoo7T8E7nUM7/TiXMPFTloACBuYflM0i2y\nWvvfvBr4eyRVHoZdNxTtmKteDRvhEP6R1k1cYhOJKQKBgQDWrrlceNYE59Fo0/e3\njiZbMcrC/voYcBL2cR7Eb1RW6mO8XStRz7cUiw/yhu5y/I2yNANgUgKcj747y073\nqaFL9H/NTFi14Jo17SH/9J8NsIPUgNze9TbD9o+n5tG992tzCCGHX0UN7BAO2kYg\nRWVjq8jwiL3KiXBM2XpuOkhZuQKBgQC/L/o3e8ERFJOagyLPQFRZg8ix6KM/V+zt\nXUAiuzSeSt0reikQVxCNBjOfZDHtAhEHK0SLR65KDBgKL78QstKgBXKgT5Qu44Q+\n5Jjuy1nAsicP8G+zUz994MQd1Do+KnYGmUqdMOMB0CVaGulrBNJiRipavSPekKUN\nFiM4nT9bGQKBgA8GnayuPHSNcSfAJkdvqJmba5CoXgLV3U3obvnavPF0aFSnxL9u\nJWdHsG8OKKRdruE5KL9WHh6tJOh0e2t0MPjq/QL2hAL+3GxH06hhi7xejWuTNWJZ\nkWK34CglTKraJWggupAKCABIdHtFpcDeepE2VdMYDwidBAIs+pe6dpPpAoGAWH0f\nRaDcykgIzUIW0XAH2mqZcGapcD8E5RP9BFY7U2x5E492BB8YBP2y1Pot9XG4aeYH\n0qM5swIH+mcA+vyZagE7faF3h4A8jFOHyTaLcxnB5Km3OXu1blCi1N+OmYlTmVhH\n5Ztj5kntj9fW43aW3W92WQsj1/aAvh7Z7HEzirkCgYAfqXnWNrqbRl7jGB2r1U3M\n9oWMIA3JCaEJ8V2I5xzHqVHfVsclYyTnOhcrKwS7XyVRhWPidKwo5FlrJgGyv8SZ\nV+R0hWBk03hDrbsZvLmgY26o93EtoSkvVq4QGxjCOcyWQfi7ZbOwMBGU8uxUaZ/l\n5qzLDckKf+yeXlLnNUqVpA==\n-----END PRIVATE KEY-----\n"; // copy value from downloaded json file
    final token =
        jwt.sign(RSAPrivateKey(privateKey), algorithm: JWTAlgorithm.RS256);

    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': token,
      },
    );

    if (response.statusCode == 200) {
      final oauth2Token = json.decode(response.body)['access_token'];
      print('OAuth2 Token: $oauth2Token');
      return oauth2Token;

    } else {
      print('Failed to get OAuth2 token. Status code: ${response.statusCode}');

      print('Response: ${response.body}');
      return 'Response: ${response.body}';
    }
  }

  @override
  Future<Result<SendNotificationsForUserModel>> sendNotificationsForUser({
    required String deviceToken,
    required String userNamSender,
    required String message,
    required ArgumentMessage dataMessage,
    required bool isMessage,
  }) async {
    String token = await getOAuthToken();

    return await RemoteDataSource.request<SendNotificationsForUserModel>(
      converter: (model) => SendNotificationsForUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        "Content-Type": "application/json",
        'Authorization':
            'Bearer $token'
      },
      data: {
        "message": {
          "token": deviceToken,
          "notification": {
            "title": userNamSender,
            "body": message,
          },
          "data": {
            "bodyText": message.toString(),
            "isMessage": 'true',
            "nameAds": dataMessage.nameAds.toString(),
            "imageAds": imageWithoutUrl(dataMessage.imageAds).toString(),
            "imageCompany": imageWithoutUrl(dataMessage.imageCompany).toString(),
            "imageUser": imageWithoutUrl(dataMessage.imageUser).toString(),
            "nameOwnerAds": dataMessage.nameOwnerAds.toString(),
            "user_name_person_sender": dataMessage.user_name_person_sender.toString(),
            "user_id": dataMessage.user_id.toString(),
            "user_id_2": dataMessage.user_id_2.toString(),
            "ad_id": dataMessage.ad_id.toString(),
            'isBannerInOut': dataMessage.isBannerInOut.toString(),
            'categoryId': dataMessage.categoryId.toString(),
            'isBanner': dataMessage.isBanner.toString(),
            'idBannerOrProduct': dataMessage.idBannerOrProduct.toString(),
            'idAdOnwerCompany': dataMessage.idAdOnwerCompany.toString(),
            // "organization": {}
          }
        }
      },

      url: "https://fcm.googleapis.com/v1/projects/syriansinuae-84f35/messages:send",
    );
  }

  String? imageWithoutUrl(String? image) {
   print('image befor :$image');
    RegExp regExp = RegExp(r'[^/]+(\.\w+)$');

    // البحث عن المطابقة في النص
    Match? match = regExp.firstMatch(image!);
   print('image after :${match?.group(0)}');
    if (match != null) {
      return match.group(0); // سيطبع 1721307078_66990fc62def08.55119972.webp
    } else {
      return "notfound.jpg";
    }
  }

  @override
  Future<Result<GeneralResult>> deleteOneNotifications(
      {required int idNotifications}) async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url:
          "${AppEndpoints.baseUrl}mobile/notifications/remove/$idNotifications",
    );
  }


  @override
  Future<Result<GeneralResult>> deleteAllNotifications() async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/notifications/remove_all",
    );
  }

  @override
  Future<Result<NotificationsModel>> getAllNotifications() async {
    String? deviceToken =
        DIManager.findDep<SharedPrefs>().getDeviceToken() ;
    String deviceType = DIManager.findDep<SharedPrefs>().getDeviceType()!;
    return await RemoteDataSource.request<NotificationsModel>(
      converter: (model) => NotificationsModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {"device_token": deviceToken, "device_type": deviceType},
      url: "${AppEndpoints.baseUrl}mobile/notifications/ar",
    );
  }

  @override
  Future<Result<NotificationsModel>> getUnReadNotifications() async {
    return await RemoteDataSource.request<NotificationsModel>(
      converter: (model) => NotificationsModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/notifications/unread",
    );
  }
  @override
  Future<Result<PackagesUserModel>> getPackagesUser() async {
    return await RemoteDataSource.request<PackagesUserModel>(
      converter: (model) => PackagesUserModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      // url: "${AppEndpoints.baseUrl}packages/home",
      url: "${AppEndpoints.baseUrl}packages_new/home",
    );
  }

  @override
  Future<Result<PackagesUserModel>> payPackagesUser() async {
    return await RemoteDataSource.request<PackagesUserModel>(
      converter: (model) => PackagesUserModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}packages/add",
    );
  }
  @override
  Future<Result<GeneralResult>> readAllNotification() async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/notifications/read_all",
    );
  }

  @override
  Future<Result<GeneralResult>> readNotificationAds({
    required int idAds,
  }) async {
    return await RemoteDataSource.request<GeneralResult>(
      converter: (model) => GeneralResult.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/notifications/read/$idAds",
    );
  }
}
