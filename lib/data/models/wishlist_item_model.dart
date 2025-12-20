/*
 * Simplified book model for a more performative wishlist querying
 */

class WishlistItemModel {
  final String id;
  final String title;
  final String coverUrl;
  final DateTime addedAt;

  WishlistItemModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.addedAt,
  });

  factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
    return WishlistItemModel(
      id: map['bookId'],
      title: map['title'],
      coverUrl: map['coverUrl'],
      addedAt: DateTime.parse(map['addedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': id,
      'title': title,
      'coverUrl': coverUrl,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
