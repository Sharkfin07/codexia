/*
 * Rental model representing a user's book loan and its lifecycle timestamps/status.
 */

class RentalModel {
  final String rentalId;
  final String userId;
  final String bookId;

  final String bookTitle;
  final String coverUrl;

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
    required this.rentedAt,
    required this.dueDate,
    this.returnedAt,
    required this.status,
  });

  factory RentalModel.fromMap(Map<String, dynamic> map) {
    return RentalModel(
      rentalId: map['rentalId'],
      userId: map['userId'],
      bookId: map['bookId'],
      bookTitle: map['bookTitle'],
      coverUrl: map['coverUrl'],
      rentedAt: DateTime.parse(map['rentedAt']),
      dueDate: DateTime.parse(map['dueDate']),
      returnedAt: map['returnedAt'] != null
          ? DateTime.parse(map['returnedAt'])
          : null,
      status: RentalStatus.values.firstWhere((e) => e.name == map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rentalId': rentalId,
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'coverUrl': coverUrl,
      'rentedAt': rentedAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnedAt': returnedAt?.toIso8601String(),
      'status': status.name,
    };
  }
}

enum RentalStatus { active, returned, overdue }
