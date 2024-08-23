import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authFirebaseProvider = StateNotifierProvider<AuthConfig, bool>((ref) {
  return AuthConfig(FirebaseAuth.instance);
});

class AuthConfig extends StateNotifier<bool> {
  final FirebaseAuth auth;

  AuthConfig(this.auth) : super(false);

  Future<String> register({required String email, required String password}) async {
    state = true;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak';
        case 'email-already-in-use':
          return 'The password provided is too weak';
        default:
          return e.code;
      }
    } finally {
      state = false;
    }

    return 'pass';
  }

  Future<String> login({required String email, required String password}) async {
    state = true;
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Email or password wrong';
        case 'wrong-password':
          return 'Email or password wrong';
        default:
          return e.code;
      }
    } finally {
      state = false;
    }

    return 'pass';
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}