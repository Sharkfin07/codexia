/*
 * Book model scaffolded via https://app.quicktype.io/ using data from https://bukuacak.vercel.app/api
 */

class BookModel {
  final String id;
  final String title;
  final String coverUrl;
  final String authorName;
  final String category;
  final String summary;
  final String price;
  final int totalPages;
  final DateTime publishedDate;
  final String publisher;

  BookModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.authorName,
    required this.category,
    required this.summary,
    required this.price,
    required this.totalPages,
    required this.publishedDate,
    required this.publisher,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['_id'],
      title: map['title'],
      coverUrl: map['cover_image'],
      authorName: map['author']['name'],
      category: map['category']['name'],
      summary: map['summary'],
      price: map['details']['price'],
      totalPages:
          int.tryParse(
            map['details']['total_pages'].toString().split(' ').first,
          ) ??
          0,
      publishedDate: DateTime.parse(
        _parseDate(map['details']['published_date']),
      ),
      publisher: map['publisher'],
    );
  }
}

String _parseDate(dynamic raw) {
  const fallback = '1970-01-01'; // Conventional date fallback
  if (raw == null) return fallback;

  final value = raw.toString().trim();
  if (value.isEmpty) return fallback;

  // Direct ISO or standard parse
  final direct = DateTime.tryParse(value);
  if (direct != null) return direct.toIso8601String();

  // Handle formats like "29 November 2023"
  final match = RegExp(
    r'^(\d{1,2})[\s/-]([A-Za-z]+)[\s/-](\d{4})$',
  ).firstMatch(value);
  if (match != null) {
    final day = int.tryParse(match.group(1) ?? '') ?? 0;
    final monthName = (match.group(2) ?? '').toLowerCase();
    final year = int.tryParse(match.group(3) ?? '') ?? 0;

    // Supports Indonesian/English month names
    const monthMap = {
      'january': 1,
      'jan': 1,
      'januari': 1,
      'february': 2,
      'feb': 2,
      'februari': 2,
      'march': 3,
      'mar': 3,
      'maret': 3,
      'april': 4,
      'apr': 4,
      'may': 5,
      'mei': 5,
      'june': 6,
      'jun': 6,
      'juni': 6,
      'july': 7,
      'jul': 7,
      'juli': 7,
      'august': 8,
      'aug': 8,
      'agustus': 8,
      'september': 9,
      'sep': 9,
      'sept': 9,
      'october': 10,
      'oct': 10,
      'oktober': 10,
      'okt': 10,
      'november': 11,
      'nov': 11,
      'december': 12,
      'dec': 12,
      'desember': 12,
    };

    final month = monthMap[monthName];
    if (month != null && day > 0 && year > 0) {
      return DateTime(year, month, day).toIso8601String();
    }
  }

  return fallback;
}
