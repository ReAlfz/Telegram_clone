import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final authFirebaseProvider = NotifierProvider<AuthConfigure, User?>(
        () => AuthConfigure()
);

class AuthConfigure extends Notifier<User?> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  build() {
    auth.authStateChanges().listen((event) => state = event);
    return auth.currentUser;
  }

  Future<void> register({required String email, required String password}) async {
    String getError = "";
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'weak-password':
          getError = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          getError = 'The password provided is too weak';
        default:
          getError = error.code;
      }

      Fluttertoast.showToast(
        msg: getError,
        fontSize: 16,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    String getError = "";
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          getError = 'Email or password wrong';
        case 'wrong-password':
          getError = 'Email or password wrong';
        default:
          getError = error.code;
      }

      Fluttertoast.showToast(
        msg: getError,
        fontSize: 16,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: error.code,
        fontSize: 16,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}