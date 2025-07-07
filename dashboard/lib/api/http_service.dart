import "dart:developer" as dev;
import "dart:io";

import "package:dio/dio.dart";
import "package:inspired_blog_panel/utils/functions.dart";

/// HTTP Client with high level functions
class HTTP {
  static final Dio _client = Dio();

  static _triggerMessage(String name, String message) =>
      dev.log(message, name: name);

  static Future<Response?> get({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
  }) async {
    Options options = Options(
      headers: headers,
      validateStatus: (_) => true,
    );

    _triggerMessage("HTTP GET", endPoint);

    final response = await _client.get(endPoint,
        queryParameters: parameters, options: options);

    return response;
  }

  static Future<Response?> post({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    Object? body,
    Function(int,int)? onSendProgress,
    Function(int,int)? onReceiveProgress,
    
  }) async {
    Options options = Options(
      headers: headers,
      validateStatus: (_) => true,
    );

    try {
      _triggerMessage("HTTP POST", endPoint);

      final response = await _client.post(endPoint,
          queryParameters: parameters, options: options, data: body,onReceiveProgress:onReceiveProgress,onSendProgress: onSendProgress );
      return response;
    } on DioException catch (error) {
      dd('HTTP POST Error : ${error.message}', emphasized: false);
    }
  }

  static Future<Response?> put({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    Options options = Options(
      headers: headers,
      validateStatus: (_) => true,
    );

    _triggerMessage("HTTP PUT", endPoint);

    final response = await _client.put(endPoint,
        queryParameters: parameters, options: options, data: body);

    return response;
  }

  static Future<Response?> patch({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    Options options = Options(
      headers: headers,
      validateStatus: (_) => true,
    );

    _triggerMessage("HTTP PATCH", endPoint);

    final response = await _client.patch(endPoint,
        queryParameters: parameters, options: options, data: body);

    return response;
  }

  static Future<Response?> delete({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    Options options = Options(
      headers: headers,
      validateStatus: (_) => true,
    );

    _triggerMessage("HTTP DELETE", endPoint);

    final response = await _client.delete(endPoint,
        queryParameters: parameters, options: options, data: body);

    return response;
  }
}
