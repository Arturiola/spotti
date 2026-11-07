import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();
  Stream<User?> userChanges() => _auth.userChanges();

  Future<UserCredential> signUp({required String email, required String password}) =>
      _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);

  Future<UserCredential> signIn({required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordReset({required String email}) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> sendEmailVerification() async {
    final user = _requireUser();
    if (!user.emailVerified) await user.sendEmailVerification();
  }

  Future<bool> refreshEmailVerification() async {
    final user = _requireUser();
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> updateProfile({required String name, String? photoUrl}) async {
    final user = _requireUser();
    await user.updateDisplayName(name.trim());
    if (photoUrl != null) await user.updatePhotoURL(photoUrl);
    await user.reload();
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    final user = _requireUser();
    await _reauthenticate(user, currentPassword);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({required String currentPassword}) async {
    final user = _requireUser();
    await _reauthenticate(user, currentPassword);
    await user.delete();
  }

  Future<void> _reauthenticate(User user, String password) async {
    final email = user.email;
    if (email == null) {
      throw FirebaseAuthException(code: 'missing-email', message: 'В обліковому записі немає адреси електронної пошти.');
    }
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
  }

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'not-authenticated', message: 'Спочатку увійдіть у застосунок.');
    }
    return user;
  }
}
