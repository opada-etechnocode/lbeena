// import 'package:dio/dio.dart';
//
// class DioHelper {
//
//   static Dio? dio;
//   // static init() async {
//   //
//   //   try {
//   //     await pusher!.init(
//   //       apiKey: "c8776a00baa2385708d7",
//   //       cluster: 'ap2',
//   //     );
//   //     await pusher!.subscribe(channelName: 'bidding');
//   //     await pusher!.connect();
//   //   } catch (e) {
//   //     print("ERROR: $e");
//   //   }
//   //   dio = Dio(
//   //     BaseOptions(
//   //       baseUrl: "https://student.valuxapps.com/api/",
//   //       receiveDataWhenStatusError: true,
//   //     ),
//   //   );
//   // }
//
//   static Future<Response> getData({
//     required String url,
//     Map<String,dynamic>? query,
//     String lang ='en',
//     String? token,
//   }) async{
//     dio!.options.headers ={
//       'Content-Type':'application/json',
//       'lang':lang,
//       'Authorization':token??'',
//     };
//     return await dio!.get(url ,queryParameters: query);
//   }
//
//   static Future<Response> postData({
//     required String url,
//     // required Map<String,dynamic> data,
//     Map<String,dynamic>? query,
//     String lang ='en',
//     String? token,
//   }) async{
//
//     dio!.options.headers ={
//       'Accept':'application/json',
//
//       // 'Authorization':token??'',
//     };
//
//     return await dio!.post(
//         url,
//         // queryParameters: query,
//         // data: data
//     );
//   }
//
//
//   static Future<Response> putData({
//     required String url,
//     required Map<String,dynamic> data,
//     Map<String,dynamic>? query,
//     String lang ='en',
//     String? token,
//   }) async{
//
//     dio!.options.headers ={
//       'Content-Type':'application/json',
//       'lang':lang,
//       'Authorization':token??'',
//     };
//
//     return await dio!.put(
//         url,
//         queryParameters: query,
//         data: data
//     );
//   }
//
// }