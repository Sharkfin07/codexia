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

  Future<List<String>> fetchGenres() async {
    try {
      final response = await _client.get<dynamic>('/stats/genre');
      final data = response.data;

      if (response.statusCode != 200 || data == null) {
        throw BookServiceException('Failed to load genres');
      }

      final genres = <String>{};

      String? normalizeGenre(dynamic value) {
        if (value == null) return null;
        final trimmed = value.toString().trim();
        if (trimmed.isEmpty) return null;
        final cleaned = trimmed.replaceAll(RegExp(r'[\s,]+$'), '');
        return cleaned.isEmpty ? null : cleaned;
      }

      void addIfValid(dynamic value) {
        final cleaned = normalizeGenre(value);
        if (cleaned != null) genres.add(cleaned);
      }

      void parseList(List<dynamic> items) {
        for (final item in items) {
          if (item is Map<String, dynamic>) {
            addIfValid(item['genre'] ?? item['name'] ?? item['category']);
          } else {
            addIfValid(item);
          }
        }
      }

      if (data is List) {
        parseList(data);
      } else if (data is Map<String, dynamic>) {
        if (data['genre_statistics'] is List) {
          parseList((data['genre_statistics'] as List).cast<dynamic>());
        }

        if (data['genreStats'] is List) {
          parseList((data['genreStats'] as List).cast<dynamic>());
        }

        for (final entry in data.entries) {
          final key = entry.key.toString();
          final isNumeric = entry.value is num;
          final looksLikeTotal = key.toLowerCase().contains('total');
          if (isNumeric && !looksLikeTotal) addIfValid(key);
        }
      }

      final result = genres.toList()..sort((a, b) => a.compareTo(b));
      if (result.isEmpty) {
        throw BookServiceException('Empty genre list');
      }

      return result;
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
