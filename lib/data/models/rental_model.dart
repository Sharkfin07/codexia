/*
 * Rental model representing a user's book loan and its lifecycle timestamps/status.
 */

class RentalModel {
  final String rentalId;
  final String userId;
  final String bookId;

  final String bookTitle;
  final String coverUrl;

  final int rentalDays;
  final int pricePerDay;
  final int totalPrice;

  final DateTime rentedAt;
  final DateTime dueDate;
  final DateTime? returnedAt;

  final RentalStatus status;

  RentalModel({
    required this.rentalId,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.coverUrl,
    required this.rentalDays,
    required this.pricePerDay,
    required this.totalPrice,
    required this.rentedAt,
    required this.dueDate,
    this.returnedAt,
    required this.status,
  });

  factory RentalModel.fromMap(Map<String, dynamic> map) {
    final status = RentalStatus.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => RentalStatus.active,
    );
    final dueDate = DateTime.parse(map['dueDate']);

    return RentalModel(
      rentalId: map['rentalId'],
      userId: map['userId'],
      bookId: map['bookId'],
      bookTitle: map['bookTitle'],
      coverUrl: map['coverUrl'],
      rentalDays: map['rentalDays'] ?? 0,
      pricePerDay: map['pricePerDay'] ?? 0,
      totalPrice: map['totalPrice'] ?? 0,
      rentedAt: DateTime.parse(map['rentedAt']),
      dueDate: dueDate,
      returnedAt: map['returnedAt'] != null
          ? DateTime.parse(map['returnedAt'])
          : null,
      status: status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rentalId': rentalId,
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'coverUrl': coverUrl,
      'rentalDays': rentalDays,
      'pricePerDay': pricePerDay,
      'totalPrice': totalPrice,
      'rentedAt': rentedAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnedAt': returnedAt?.toIso8601String(),
      'status': status.name,
    };
  }

  RentalStatus get effectiveStatus {
    if (status == RentalStatus.active && DateTime.now().isAfter(dueDate)) {
      return RentalStatus.overdue;
    }
    return status;
  }
}

enum RentalStatus { active, returned, overdue }
