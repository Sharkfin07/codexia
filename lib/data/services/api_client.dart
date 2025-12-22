import 'package:dio/dio.dart';

/// Shared HTTP client wrapper to keep Dio config (baseUrl, timeout, interceptors) in one place.
class ApiClient {
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
            ),
          ) {
    // Add logging / interceptors here when needed.
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
