import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_model.dart';
import '../../data/models/rental_model.dart';
import '../../data/repositories/rental_repository.dart';
import 'auth_provider.dart';

final rentalProvider = AsyncNotifierProvider<RentalNotifier, List<RentalModel>>(
  () => RentalNotifier(),
);

class RentalNotifier extends AsyncNotifier<List<RentalModel>> {
  RentalRepository? _repo;

  Future<RentalRepository> _ensureRepo() async {
    if (_repo != null) return _repo!;
    final user = await ref.read(authStateProvider.future);
    if (user == null) {
      throw Exception('Please sign in to rent books');
    }
    _repo = RentalRepository(userId: user.uid);
    return _repo!;
  }

  @override
  Future<List<RentalModel>> build() async {
    final auth = ref.watch(authStateProvider);
    final user = auth.value;

    if (user == null) {
      _repo = null;
      return [];
    }

    _repo = RentalRepository(userId: user.uid);
    return _repo!.fetchAll();
  }

  Future<void> refresh() async {
    try {
      final repo = await _ensureRepo();
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => repo.fetchAll());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> rent(BookModel book, {required int days}) async {
    final current = state.value ?? [];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _ensureRepo();
      final rental = await repo.rent(book, days: days);
      return [rental, ...current];
    });
  }

  Future<void> markReturned(String rentalId) async {
    final current = state.value ?? [];
    final target = current.firstWhere((r) => r.rentalId == rentalId);
    state = await AsyncValue.guard(() async {
      final repo = await _ensureRepo();
      final updated = await repo.markReturned(target);
      return current.map((r) => r.rentalId == rentalId ? updated : r).toList();
    });
  }
}
