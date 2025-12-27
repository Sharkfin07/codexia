import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book_model.dart';
import '../models/rental_model.dart';
import '../services/firestore_service.dart';

class RentalRepository {
  RentalRepository({required this.userId, this.pricePerDay = 5000});

  final String userId;
  final int pricePerDay;

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('users/$userId/rentals');

  Future<List<RentalModel>> fetchAll() async {
    if (userId.isEmpty) return [];
    final snap = await _col.orderBy('rentedAt', descending: true).get();
    return snap.docs.map((d) => RentalModel.fromMap(d.data())).toList();
  }

  Future<RentalModel> rent(BookModel book, {required int days}) async {
    if (userId.isEmpty) throw Exception('User not signed in');
    if (days < 1 || days > 7) {
      throw Exception('Rental duration must be between 1-7 days');
    }
    final now = DateTime.now();
    final due = now.add(Duration(days: days));
    final totalPrice = days * pricePerDay;
    final data = RentalModel(
      rentalId: _col.doc().id,
      userId: userId,
      bookId: book.id,
      bookTitle: book.title,
      coverUrl: book.coverUrl,
      rentalDays: days,
      pricePerDay: pricePerDay,
      totalPrice: totalPrice,
      rentedAt: now,
      dueDate: due,
      status: RentalStatus.active,
      returnedAt: null,
    ).toMap();

    await FirestoreService.instance.set(
      'users/$userId/rentals/${data['rentalId']}',
      data,
      setCreatedAt: true,
      merge: false,
    );

    return RentalModel.fromMap(data);
  }

  Future<RentalModel> markReturned(RentalModel rental) async {
    if (userId.isEmpty) throw Exception('User not signed in');
    final updated = rental.toMap()
      ..['status'] = RentalStatus.returned.name
      ..['returnedAt'] = DateTime.now().toIso8601String();

    await FirestoreService.instance.set(
      'users/$userId/rentals/${rental.rentalId}',
      updated,
      merge: true,
    );

    return RentalModel.fromMap(updated);
  }
}
