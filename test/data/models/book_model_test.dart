// * Unit Testing 1: Book Model Mapping Test
import 'package:codexia/data/models/book_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseMap({required dynamic publishedDate}) {
  return {
    '_id': 'bk-1',
    'title': 'Chronicles of Testing',
    'cover_image': 'https://example.com/cover.png',
    'author': {'name': 'QA Author'},
    'category': {'name': 'Adventure'},
    'summary': 'An adventure in unit testing.',
    'details': {
      'price': 'Rp 10.000',
      'total_pages': '420 pages',
      'published_date': publishedDate,
    },
    'publisher': 'Test House',
  };
}

void main() {
  group('BookModel.fromMap Dates', () {
    test('natural language to date', () {
      final model = BookModel.fromMap(
        _baseMap(publishedDate: '29 November 2023'),
      );

      expect(model.publishedDate.year, 2023);
      expect(model.publishedDate.month, 11);
      expect(model.publishedDate.day, 29);
      expect(model.totalPages, 420);
    });

    test('falls back to epoch when published_date is invalid', () {
      final model = BookModel.fromMap(_baseMap(publishedDate: 'not a date'));

      expect(model.publishedDate.year, 1970);
      expect(model.publishedDate.month, 1);
      expect(model.publishedDate.day, 1);
    });
  });
}
