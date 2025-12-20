import 'dart:async';

import 'package:dio/dio.dart';

import '../models/book_model.dart';

class BookRepository {
  BookRepository({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  static const String _baseUrl = 'https://bukuacak.vercel.app/api';
  final Dio _dio;

  Future<List<BookModel>> fetchBooks({
    String? search,
    String? genre,
    int? year,
    BookSort sort = BookSort.newest,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/books',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (genre != null && genre.isNotEmpty) 'genre': genre,
          if (year != null) 'year': '$year',
          'sort': sort.key,
          'page': '$page',
          'limit': '$pageSize',
        },
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw BookRepositoryException(
          'Failed to load books (${response.statusCode})',
        );
      }

      final rawList = data['data'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => BookModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw BookRepositoryException(_dioMessage(e));
    }
  }

  Future<BookModel> fetchBookDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/books/$id');
      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw BookRepositoryException('Failed to load book ($id)');
      }

      return BookModel.fromMap(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw BookRepositoryException(_dioMessage(e));
    }
  }

  String _dioMessage(DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    return 'Network error${status != null ? ' ($status)' : ''}: ${body ?? e.message}';
  }
}

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
