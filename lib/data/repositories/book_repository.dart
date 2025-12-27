import 'dart:async';

import '../models/book_model.dart';
import '../services/book_service.dart';

class BookRepository {
  BookRepository({BookService? service}) : _service = service ?? BookService();

  final BookService _service;

  Future<List<BookModel>> fetchBooks({
    String? keyword,
    String? genre,
    int? year,
    BookSort sort = BookSort.newest,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final data = await _service.fetchBooksRaw(
        keyword: keyword,
        genre: genre,
        year: year,
        sort: sort.key,
        page: page,
        pageSize: pageSize,
      );

      final rawList = data['books'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => BookModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on BookServiceException catch (e) {
      throw BookRepositoryException(e.message);
    }
  }

  Future<BookModel> fetchBookDetail(String id) async {
    try {
      final data = await _service.fetchBookDetailRaw(id);
      return BookModel.fromMap(data);
    } on BookServiceException catch (e) {
      throw BookRepositoryException(e.message);
    }
  }

  Future<BookModel> fetchRandomBook() async {
    try {
      final data = await _service.fetchRandomBookRaw();
      return BookModel.fromMap(data);
    } on BookServiceException catch (e) {
      throw BookRepositoryException(e.message);
    }
  }

  Future<List<String>> fetchGenres() async {
    try {
      return await _service.fetchGenres();
    } on BookServiceException catch (e) {
      throw BookRepositoryException(e.message);
    }
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
