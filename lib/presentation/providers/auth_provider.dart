import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
AuthService authService(Ref ref) => AuthService();

@riverpod
Stream<User?> authState(Ref ref) =>
    ref.watch(authServiceProvider).authStateChanges;

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .signIn(email: email, password: password);
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .signUp(name: name, email: email, password: password);
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).resetPassword(email: email);
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).signOut();
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String photoUrl,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .updateProfile(name: name, photoUrl: photoUrl);
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .resetPasswordFromCurrentPassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            email: email,
          );
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
