import 'dart:async';

import 'package:dio/dio.dart';

import '../models/book_model.dart';

class BookRepository {
  BookRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  /// Berdasarkan dokumentasi Buku Acak: https://bukuacak.vercel.app/api
  /// Endpoint: https://bukuacak-9bdcb4ef2605.herokuapp.com/api/v1
  static const String _baseUrl =
      'https://bukuacak-9bdcb4ef2605.herokuapp.com/api/v1';
  final Dio _dio;

  Future<List<BookModel>> fetchBooks({
    String? keyword,
    String? genre,
    int? year,
    BookSort sort = BookSort.newest,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/book',
        queryParameters: {
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (genre != null && genre.isNotEmpty) 'genre': genre,
          if (year != null) 'year': '$year',
          'sort': sort.key,
          'page': '$page',
        },
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw BookRepositoryException(
          'Failed to load books (${response.statusCode})',
        );
      }

      // API mengembalikan { books: [...], pagination: {...} }
      final rawList = data['books'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => BookModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw BookRepositoryException(_dioMessage(e));
    }
  }

  Future<BookModel> fetchBookDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/book/$id');
      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw BookRepositoryException('Failed to load book ($id)');
      }

      return BookModel.fromMap(data);
    } on DioException catch (e) {
      throw BookRepositoryException(_dioMessage(e));
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

// TODO: Implementasikan sorting buku
enum BookSort {
  newest('newest'),
  oldest('oldest'),
  titleAZ('titleAZ'),
  titleZA('titleZA'),
  priceLowHigh('priceLowHigh'),
  priceHighLow('priceHighLow');

  const BookSort(this.key);
  final String key;
}

class BookRepositoryException implements Exception {
  BookRepositoryException(this.message);
  final String message;

  @override
  String toString() => 'BookRepositoryException: $message';
}
