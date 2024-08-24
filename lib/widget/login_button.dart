import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/pages/home.dart';
import 'package:telegram/provider/authenticator.dart';
import 'package:telegram/provider/database.dart';

class LoginButton extends HookConsumerWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;

  final ValueNotifier loading;
  final bool keys;
  const LoginButton({
    required this.loading,
    required this.passwordController,
    required this.usernameController,
    required this.emailController,
    required this.keys,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(() {
      return null;
    }, [
      loading.dispose
    ]);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorThemes.white,
        backgroundColor: ColorThemes.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.5)
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
      child: (loading.value)
          ? const SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          color: ColorThemes.white,
        ),
      )
          : Text(
        (keys) ? 'Login' : 'Register',
        style: const TextStyle(fontSize: 18),
      ),

      onPressed: () async {
        loading.value = true;
        final nContext = context;
        final emailValidation = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (!emailValidation.hasMatch(emailController.text)) {
          Fluttertoast.showToast(
            msg: 'Email is not valid',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          loading.value = false;
          return;
        }

        String passable = (keys)
            ? await ref.read(authFirebaseProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
        )
            : await ref.read(authFirebaseProvider.notifier).register(
          email: emailController.text,
          password: passwordController.text,
        );

        if (passable == 'pass') {
          await ref.read(dataFirebaseProvider.notifier).createUser(
            ref.watch(authFirebaseProvider.notifier).auth.currentUser?.uid,
          );
        }

        if (passable == 'pass' && nContext.mounted) {
          Navigator.of(nContext).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const HomePage();
              },
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: passable,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
    );
  }
}