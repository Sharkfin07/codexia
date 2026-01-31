import 'dart:developer';

import 'package:dio/dio.dart';

// * Shared HTTP client wrapper to keep Dio config (baseUrl, timeout, interceptors) in one place.
class ApiClient {
  ApiClient({Dio? dio, bool enableLogging = true})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
            ),
          ) {
    // * Enables logging capability
    if (enableLogging) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onResponse: (resp, handler) {
            log(
              'API ${resp.requestOptions.method} ${resp.requestOptions.path} -> ${resp.statusCode}',
              name: 'ApiClient',
            );
            handler.next(resp);
          },
          onError: (err, handler) {
            log(
              'API ERROR ${err.requestOptions.method} ${err.requestOptions.path} -> ${err.response?.statusCode ?? 'no-status'} ${err.message}',
              name: 'ApiClient',
            );
            if (err.response?.data != null) {
              log('Body: ${err.response?.data}', name: 'ApiClient');
            }
            handler.next(err);
          },
        ),
      );
    }
  }

  static const String _baseUrl =
      'https://bukuacak-9bdcb4ef2605.herokuapp.com/api/v1';
  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }
}
