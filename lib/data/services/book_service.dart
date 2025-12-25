import 'package:dio/dio.dart';

import 'api_client.dart';

class BookService {
  BookService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<Map<String, dynamic>> fetchBooksRaw({
    String? keyword,
    String? genre,
    int? year,
    String sort = 'newest',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/book',
        queryParameters: {
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (genre != null && genre.isNotEmpty) 'genre': genre,
          if (year != null) 'year': '$year',
          'sort': sort,
          'page': '$page',
          'pageSize': '$pageSize',
        },
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw BookServiceException(
          'Failed to load books (${response.statusCode})',
        );
      }
      return data;
    } on DioException catch (e) {
      throw BookServiceException(_dioMessage(e));
    }
  }

  Future<Map<String, dynamic>> fetchBookDetailRaw(String id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/book/$id');
      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw BookServiceException('Failed to load book ($id)');
      }
      return data;
    } on DioException catch (e) {
      throw BookServiceException(_dioMessage(e));
    }
  }

  String _dioMessage(DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    final message = e.message;
    final underlying = e.error?.toString();

    final buffer = StringBuffer('Network error');
    if (status != null) buffer.write(' ($status)');
    if (body != null) {
      buffer.write(': $body');
    } else if (message != null) {
      buffer.write(': $message');
    } else if (underlying != null) {
      buffer.write(': $underlying');
    }
    return buffer.toString();
  }
}

class BookServiceException implements Exception {
  BookServiceException(this.message);
  final String message;

  @override
  String toString() => 'BookServiceException: $message';
}
