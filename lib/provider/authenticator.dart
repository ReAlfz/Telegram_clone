import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authFirebaseProvider = StateNotifierProvider<AuthConfigure, User?>((ref) {
  return AuthConfigure(FirebaseAuth.instance);
});

class AuthConfigure extends StateNotifier<User?> {
  final FirebaseAuth auth;

  AuthConfigure(this.auth) : super(auth.currentUser) {
    auth.authStateChanges().listen((event) => state = event);
  }

  Future<String> register({required String email, required String password}) async {
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
    }

    return 'pass';
  }

  Future<String> login({required String email, required String password}) async {
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
    }

    return 'pass';
  }

  Future<String> logout() async {
    try {
      await auth.signOut();
      return 'pass';
    } catch (e) {
      print(e);
    }

    return 'out';
  }
}