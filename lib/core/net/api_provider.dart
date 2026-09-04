import 'dart:convert';
import 'dart:io';

import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:dio/dio.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/errors/base_error.dart';
import '../../../../core/errors/cancel_error.dart';
import '../../../../core/errors/custom_error.dart';
import '../../../../core/errors/net_error.dart';
import '../../../../core/errors/not_found_error.dart';
import '../../../../core/errors/time_out_error.dart';
import '../../../../core/errors/unauthorized_error.dart';
import '../../../../core/errors/unexpected_error.dart';
import '../../../../core/net/http_method.dart';
import '../../../../core/results/result.dart';


class ApiProvider {

  static Future<Result<T>> sendObjectRequest<T>({
    T Function(dynamic)? converter,
    T Function(List<dynamic>)? converterList,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    FormData? formData,
  }) async {
    try {
      // print('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
      // print('[$method: $url ]');
      // print('[formData: $formData ]');
      // print('[data: $data ]');
      // print('[headers: $headers ]');
      // print('[queryParameters: $queryParameters ]');
      // print('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
      // print('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
      print('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');

      // Get the response from the server
      late Response response;
      final dio = DIManager.setupDio();

        if(method==HttpMethod.GET) {
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
        }
      if(method==HttpMethod.POST) {
        response = await dio.post(
          url,
          data: data ?? formData,
          queryParameters: queryParameters,
          options: Options(headers: headers,),
          cancelToken: cancelToken,
        ).timeout(const Duration(milliseconds: AppEndpoints.connectionTimeout));
      }

      if(method==HttpMethod.PATCH) {
        response = await dio.patch(
          url,
          data: data ?? formData,
          queryParameters: queryParameters,
          options: Options(headers: headers),
          cancelToken: cancelToken,
        );
      }
      if(method==HttpMethod.PUT) {
        response = await dio.put(
          url,
          data: data ?? formData,
          queryParameters: queryParameters,
          options: Options(headers: headers),
          cancelToken: cancelToken,
        );
      }
      if(method==HttpMethod.DELETE) {
        response = await dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers),
          cancelToken: cancelToken,
        );
      }
      // Get the decoded json
      var decodedJson;
      if (response.data is String)
        if (response.data.toString().isEmpty) {
          decodedJson = {"status": true, "result":"success"};
        }else{
          decodedJson = json.decode(response.data);
        }
      else {
        decodedJson = response.data;
      }

      print("$decodedJson");

      // if (decodedJson['status'] == true) {
      if (converterList != null) {
        return Result(data: converterList(decodedJson['data']));
      }
      return Result(data: converter!(decodedJson));
      /*if (decodedJson['data'] == null && decodedJson['success'] == null) {
        print("I'm Hereeeeeeeeee");
        return Result(error: CustomError(message: 'No Data found'));
      }*/

      /*final dataM;
      if (decodedJson['data'] is List) {
        dataM = {'data': decodedJson['data']};
      } else {
        dataM = decodedJson['data'];
      }
      return Result(data: (dataM != null) ? converter!(dataM) : converter!(''));
      */
      // }
      //throw decodedJson['error'];
    }

    // Handling errors
    on DioException catch (e,stack) {
      print("Dio Error : ${e.message}");
      print("Dio stack : $stack");
      return Result(error: _handleDioError(e));
    }

    // Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      print('hello 2 -_- $e');
      print(e);
      print(stacktrace);
      return Result(error: CustomError(message: 'Socket Error'));
    } catch (e, stacktrace) {
      print('hello 3 -_- $e stacktrace : $stacktrace');
      return Result(error: CustomError(message: stacktrace.toString()));
    }
  }



  static BaseError _handleDioError(DioException error) {
    if (error.type == DioExceptionType.unknown ||
        error.type == DioExceptionType.badResponse) {
      if (error is SocketException) return NetError();
      if (error.type == DioExceptionType.badResponse) {
        switch (error.response!.statusCode) {

          case 401:
            if(error.response != null) {
              return UnauthorizedError(
                  message: json.decode(json.encode(error.response!.data))['message']
              );
            }
            return UnauthorizedError();
          case 400:
          case 422:
            if(error.response != null) {
              return CustomError(
                  message: json.decode(json.encode(error.response!.data))["message"]
              );
            }
            return CustomError(message: 'Bad Request', statusCode: 400);
          case 404:
            return NotFoundError();
          case 403:
          case 409:  return CustomError(message: json.decode(json.encode(error.response!.data))["message"], statusCode: 409);
          case 500:
            return CustomError(message: "Internal Server Error", statusCode: 500);
          default:
            return UnExpectedError();
        }
      }
      return NetError();
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return TimeOutError();
    } else if (error.type == DioExceptionType.cancel) {
      return CancelError();
    } else {
      return UnExpectedError();
    }
  }
}
