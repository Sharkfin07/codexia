import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_model.dart';
import '../../data/repositories/book_repository.dart';

final bookDetailProvider = FutureProvider.autoDispose.family<BookModel, String>(
  (ref, id) async {
    final repo = BookRepository();
    return repo.fetchBookDetail(id);
  },
);
