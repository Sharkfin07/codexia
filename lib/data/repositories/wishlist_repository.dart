import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book_model.dart';
import '../models/wishlist_item_model.dart';
import '../services/firestore_service.dart';

class WishlistRepository {
  WishlistRepository({required this.userId});

  final String userId;
  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('users/$userId/wishlist');

  Future<List<WishlistItemModel>> fetchAll() async {
    if (userId.isEmpty) return [];
    final snap = await _col.orderBy('addedAt', descending: true).get();
    return snap.docs.map((d) => WishlistItemModel.fromMap(d.data())).toList();
  }

  Future<void> add(BookModel book) async {
    if (userId.isEmpty) throw Exception('User not signed in');
    final data = WishlistItemModel(
      id: book.id,
      title: book.title,
      coverUrl: book.coverUrl,
      addedAt: DateTime.now(),
    ).toMap();

    await FirestoreService.instance.set(
      'users/$userId/wishlist/${book.id}',
      data,
      setCreatedAt: true,
      merge: true,
    );
  }

  Future<void> remove(String bookId) async {
    if (userId.isEmpty) throw Exception('User not signed in');
    await FirestoreService.instance.delete('users/$userId/wishlist/$bookId');
  }
}
