import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_listin/_core/services/dio_endpoints.dart';
import 'package:logger/logger.dart';

class DioInterceptor extends Interceptor {
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String log = "";
    log += "Request\n";
    log += "Timestamp: ${DateTime.now().toIso8601String()}\n";
    log += "METHOD: ${options.method}\n";
    log += "URL: ${options.uri}\n";
    log += "HEADERS: ${const JsonEncoder.withIndent('  ').convert(options.headers)}\n";
    if (options.data != null) {
      log += "DATA: ${const JsonEncoder.withIndent('  ').convert(json.decode(options.data))}\n";
    }
    _logger.w(log);
    Dio().post('https://flutter-dio-6efb1-default-rtdb.firebaseio.com/logs.json', data: {
      "request": log,
    });
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String log = "";
    log += "Response\n";
    log += "Timestamp: ${DateTime.now().toIso8601String()}\n";
    log += "STATUS CODE: ${response.statusCode}\n";
    log += "URL: ${response.requestOptions.uri}\n";
    log += "HEADERS: ${const JsonEncoder.withIndent('  ').convert(response.headers.map)}\n";
    if (response.data != null) {
      log += "DATA: ${const JsonEncoder.withIndent('  ').convert(response.data)}\n";
    }
    _logger.i(log);
    Dio().post("${DioEndpoints.devBaseUrl}${DioEndpoints.logs}", data: {
      "response": log,
    });
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String log = "";
    log += "Error\n";
    log += "Timestamp: ${DateTime.now().toIso8601String()}\n";
    log += "URL: ${err.requestOptions.uri}\n";
    log += "MESSAGE: ${err.message}\n";
    if (err.response != null) {
      log += "STATUS CODE: ${err.response?.statusCode}\n";
      log += "DATA: ${const JsonEncoder.withIndent('  ').convert(err.response?.data)}\n";
    }
    _logger.e(log);
    Dio().post('https://flutter-dio-6efb1-default-rtdb.firebaseio.com/logs.json', data: {
      "error": log,
    });
    super.onError(err, handler);
  }
}
