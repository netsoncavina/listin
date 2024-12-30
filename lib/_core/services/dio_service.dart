import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_listin/_core/data/local_data_handler.dart';
import 'package:flutter_listin/_core/services/dio_endpoints.dart';
import 'package:flutter_listin/_core/services/dio_interceptor.dart';
import 'package:flutter_listin/listins/data/database.dart';

class DioService {
  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: DioEndpoints.devBaseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3)),
  );

  DioService() {
    _dio.interceptors.add(DioInterceptor());
  }

  Future<String?> saveLocalToServer(AppDatabase appDatabase) async {
    try {
      Map<String, dynamic> localData = await LocalDataHandler().localDataToMap(appdatabase: appDatabase);
      await _dio.put(
        DioEndpoints.listins,
        data: json.encode(localData['listins']),
      );
    } on DioException catch (error) {
      if (error.response != null && error.response?.data != null) {
        return "An error occurred: ${error.response?.data!.toString()}";
      } else {
        return "An error occurred: ${error.message}";
      }
    } on Exception catch (error) {
      return "An error occurred: $error";
    }
    return null;
  }

  getDataFromServer(AppDatabase appDatabase) async {
    Response response = await _dio.get(DioEndpoints.listins, queryParameters: {
      'orderBy': '"name"',
      "startAt": 0,
    });
    if (response.statusCode == 200 && response.data != null) {
      Map<String, dynamic> map = {};
      if (response.data.runtimeType == List) {
        if ((response.data as List<dynamic>).isNotEmpty) {
          map['listins'] = response.data;
        }
      } else {
        List<Map<String, dynamic>> list = [];
        for (var mapResponse in response.data.values) {
          list.add(mapResponse);
        }
        map['listins'] = list;
      }
      await LocalDataHandler().mapToLocalData(map: map, appdatabase: appDatabase);
    }
  }

  Future<void> clearServerData() async {
    await _dio.delete(DioEndpoints.listins).then((response) {
      print(response.data);
    }).catchError((error) {
      print(error);
    });
  }
}
