import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:payment_app/Screen/login.page.dart';
import 'package:payment_app/config/utils/globalKey.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio createDio() {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final box = Hive.box("userdata");
        final token = box.get("token"); // 🔥 har request par fresh token

        options.headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        });
        handler.next(options);
      },
      onError: (error, handler) async {
        // if (error.type == DioExceptionType.connectionError ||
        //     error.type == DioExceptionType.connectionTimeout ||
        //     error.type == DioExceptionType.receiveTimeout) {
        //   Fluttertoast.showToast(
        //     msg: "Server not reachable. Please try again later.",
        //     backgroundColor: Colors.red,
        //     toastLength: Toast.LENGTH_LONG,
        //   );
        //   return handler.next(error);
        // }

        if (error.response != null) {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            final box = Hive.box("userdata");
            await box.clear();
            Fluttertoast.showToast(
              msg: "Session expired. Please login again.",
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
            );
            navigatorKey.currentState?.pushAndRemoveUntil(
              CupertinoPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          }
        } else {
          log("❌ Dio error without response: ${error.message}");
        }

        handler.next(error);
      },
      onResponse: (response, handler) async {
        if (response.data['code'] == 401 || response.data['code'] == 3) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
          final box = Hive.box("userdata");
          await box.clear(); // 🔥 await add किया
          Fluttertoast.showToast(
            msg: response.data['message'],
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        handler.next(response);
      },
    ),
  );
  return dio;
}
