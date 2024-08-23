import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/pages/home.dart';
import 'package:telegram/provider/provider.dart';
import 'package:telegram/widget/login_text_field.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authFirebaseProvider);
    final boolState = useState<bool>(true);
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.telegram_outlined,
            color: ColorThemes.primary,
            size: 100,
          ),

          const Text(
            'Welcome Back!',
            style: TextStyle(
              color: ColorThemes.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'Enter your username and password to login',
            style: TextStyle(
              color: ColorThemes.gray,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          AnimatedSwitcher(
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut.flipped,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(children: [currentChild!, ...previousChildren]);
            },
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) {
              final rotate = Tween<double>(begin: pi, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: rotate,
                child: child,
                builder: (context, child) {
                  final isKey = ValueKey(boolState.value) != child!.key;
                  var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                  tilt *= isKey ? -1.0 : 1.0;
                  final value = (isKey)
                      ? min(rotate.value, pi / 2)
                      : rotate.value;
                  return Transform(
                    transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
              );
            },
            child: (boolState.value)
                ? authContainer(
              keys: true,
              ref: ref,
              context: context,
              isLoading: isLoading,
              usernameController: usernameController,
              passwordController: passwordController,
            )
                : authContainer(
              keys: false,
              ref: ref,
              context: context,
              isLoading: isLoading,
              usernameController: usernameController,
              passwordController: passwordController,
            ),
          ),

          const SizedBox(height: 10),

          RichText(
            text: TextSpan(
                text: (!boolState.value) ? 'Already have an account? ' : "Don't an account? ",
                children: [
                  TextSpan(
                      text: (!boolState.value) ? 'Login' : 'Register',
                      style: const TextStyle(
                        color: ColorThemes.secondary,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        boolState.value = !boolState.value;
                      }
                  )
                ],
                style: const TextStyle(
                  color: ColorThemes.black,
                  fontSize: 15,
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget authContainer({
    required bool keys,
    required bool isLoading,
    required WidgetRef ref,
    required BuildContext context,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
  }) {
    return Container(
      key: ValueKey(keys),
      margin: const EdgeInsets.symmetric(horizontal: 12.5),
      decoration: BoxDecoration(
        border: Border.all(color: ColorThemes.gray),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              (keys) ? 'Login' : 'Register',
              style: const TextStyle(
                fontSize: 20,
                color: ColorThemes.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          LoginTextField(
            title: 'Username',
            hintText: 'Username...',
            controller: usernameController,
          ),

          const SizedBox(height: 20),

          LoginTextField(
            title: 'Password',
            hintText: '',
            controller: passwordController,
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorThemes.white,
              backgroundColor: ColorThemes.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: (isLoading)
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
              if (isLoading) return;

              final nContext = context;
              final emailValidation = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
              if (!emailValidation.hasMatch(usernameController.text)) {
                Fluttertoast.showToast(
                  msg: 'Email is not valid',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
                return;
              }

              String passable = (keys)
                  ? await ref.read(authFirebaseProvider.notifier).login(
                email: usernameController.text,
                password: passwordController.text,
              )
                  : await ref.read(authFirebaseProvider.notifier).register(
                email: usernameController.text,
                password: passwordController.text,
              );

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
          ),
        ],
      ),
    );
  }
}
