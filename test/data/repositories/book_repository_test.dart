// * Unit Testing 2: Book Repository Test
// Mengetes book repository
import 'package:codexia/data/repositories/book_repository.dart';
import 'package:codexia/data/services/book_service.dart';
import 'package:flutter_test/flutter_test.dart';

// Create fake book service (tanpa pemanggilan BukuAcak API)
class _FakeBookService extends BookService {
  _FakeBookService({this.booksResponse});

  Map<String, dynamic>? booksResponse;
  Map<String, dynamic>? detailResponse;
  bool throwOnBooks = false;
  bool throwOnDetail = false;
  String? lastSortKey;

  @override
  Future<Map<String, dynamic>> fetchBooksRaw({
    String? keyword,
    String? genre,
    int? year,
    String sort = 'newest',
    int page = 1,
    int pageSize = 20,
  }) async {
    if (throwOnBooks) throw BookServiceException('books failed');
    lastSortKey = sort;
    return booksResponse ?? {'books': []};
  }

  @override
  Future<Map<String, dynamic>> fetchBookDetailRaw(String id) async {
    if (throwOnDetail) throw BookServiceException('detail failed');
    final data = detailResponse ?? {'_id': id};
    return data;
  }

  @override
  Future<Map<String, dynamic>> fetchRandomBookRaw() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> fetchGenres() {
    throw UnimplementedError();
  }
}

// Placeholder book
Map<String, dynamic> _bookJson({required String id}) {
  return {
    '_id': id,
    'title': 'The Testing Book',
    'cover_image': 'https://example.com/cover.jpg',
    'author': {'name': 'Jane Tester'},
    'category': {'name': 'Fiction'},
    'summary': 'A tale about writing tests.',
    'details': {
      'price': 'Rp 50.000',
      'total_pages': '320 pages',
      'published_date': '2023-11-29',
    },
    'publisher': 'QA Press',
  };
}

void main() {
  group('BookRepository', () {
    test('maps fetchBooks response and forwards sort key', () async {
      final fakeService = _FakeBookService(
        booksResponse: {
          'books': [_bookJson(id: 'book-1')],
        },
      );
      final repo = BookRepository(service: fakeService);

      final result = await repo.fetchBooks(
        sort: BookSort.titleAZ,
        page: 2,
        pageSize: 5,
      );

      expect(fakeService.lastSortKey, equals('titleAZ'));
      expect(result, hasLength(1));
      final book = result.first;
      expect(book.id, 'book-1');
      expect(book.title, 'The Testing Book');
      expect(book.authorName, 'Jane Tester');
      expect(book.category, 'Fiction');
      expect(book.totalPages, 320);
      expect(book.publishedDate.year, 2023);
      expect(book.publishedDate.month, 11);
      expect(book.publishedDate.day, 29);
      expect(book.price, 'Rp 50.000');
    });

    test('wraps service error into BookRepositoryException', () async {
      final fakeService = _FakeBookService()..throwOnDetail = true;
      final repo = BookRepository(service: fakeService);

      expect(
        repo.fetchBookDetail('missing-id'),
        throwsA(
          isA<BookRepositoryException>().having(
            (e) => e.message,
            'message',
            contains('detail failed'),
          ),
        ),
      );
    });
  });
}
