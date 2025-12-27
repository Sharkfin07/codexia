import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_model.dart';
import '../../data/models/wishlist_item_model.dart';
import '../../data/repositories/wishlist_repository.dart';
import 'auth_provider.dart';

final wishlistProvider =
    AsyncNotifierProvider<WishlistNotifier, List<WishlistItemModel>>(
      () => WishlistNotifier(),
    );

class WishlistNotifier extends AsyncNotifier<List<WishlistItemModel>> {
  WishlistRepository? _repo;

  @override
  Future<List<WishlistItemModel>> build() async {
    final auth = ref.watch(authStateProvider);
    final user = auth.value;

    if (user == null) {
      _repo = null;
      return [];
    }

    _repo = WishlistRepository(userId: user.uid);
    return _repo!.fetchAll();
  }

  Future<void> toggle(BookModel book) async {
    if (_repo == null) {
      state = const AsyncError(
        'Please sign in to use wishlist',
        StackTrace.empty,
      );
      return;
    }

    final current = state.value ?? [];
    final exists = current.any((w) => w.id == book.id);

    state = await AsyncValue.guard(() async {
      if (exists) {
        await _repo!.remove(book.id);
        return current.where((w) => w.id != book.id).toList();
      }

      await _repo!.add(book);
      return [
        WishlistItemModel(
          id: book.id,
          title: book.title,
          coverUrl: book.coverUrl,
          addedAt: DateTime.now(),
        ),
        ...current,
      ];
    });
  }

  Future<void> removeById(String bookId) async {
    if (_repo == null) return;
    final current = state.value ?? [];
    state = await AsyncValue.guard(() async {
      await _repo!.remove(bookId);
      return current.where((w) => w.id != bookId).toList();
    });
  }
}
