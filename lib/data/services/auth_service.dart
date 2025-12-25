import 'package:firebase_auth/firebase_auth.dart';
import './firestore_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final cred = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (cred.user != null) {
      await cred.user!.updateDisplayName(name);

      // Store initial profile in users collection
      await FirestoreService.instance.set(
        'users/${cred.user!.uid}',
        {'uid': cred.user!.uid, 'name': name, 'email': email},
        merge: true,
        setCreatedAt: true,
      );
    }

    return cred;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateProfile({
    required String name,
    required String photoUrl,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user');

    await user.updateDisplayName(name);

    // Only update photo URL when provided
    final trimmedPhoto = photoUrl.trim();
    if (trimmedPhoto.isNotEmpty) {
      await user.updatePhotoURL(trimmedPhoto);
    }

    // Update also in users collection (merge to avoid overwriting other fields)
    final fsService = FirestoreService.instance;

    await fsService.set('users/${user.uid}', {'name': name}, merge: true);

    await fsService.set('users/${user.uid}', {
      'photoUrl': photoUrl,
    }, merge: true);

    // Refresh the auth user so listeners (authStateChanges) get the latest data
    await user.reload();
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user');

    await user.reauthenticateWithCredential(credential);
    await user.delete();
    await signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user');

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}
