import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/pages/home_page.dart';
import 'package:telegram/provider/authenticator.dart';
import 'package:telegram/widget/login_container.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authFirebaseProvider);
    final boolState = useState<bool>(true);
    final loading = useState<bool>(false);
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailController = useTextEditingController();

    useEffect(() {
      if (authState != null) {
        Future.microtask(() {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return HomePage(uid: authState.uid);
                },
              ),
            );
          }
        });
      }
      return null;
    }, [authState, boolState, loading]);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                      final value = (isKey) ? min(rotate.value, pi / 2) : rotate.value;
                      return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.rotationY(value)
                            ..setEntry(3, 0, tilt),
                          alignment: Alignment.center,
                          child: child,
                        ),
                      );
                    },
                  );
                },
                child: (boolState.value)
                    ? containerLost(
                        keys: true,
                        user: authState?.uid,
                        loading: loading,
                        emailController: emailController,
                        usernameController: usernameController,
                        passwordController: passwordController,
                      )
                    : containerLost(
                        keys: false,
                        user: authState?.uid,
                        loading: loading,
                        emailController: emailController,
                        usernameController: usernameController,
                        passwordController: passwordController,
                      ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: (!boolState.value)
                      ? 'Already have an account? '
                      : "Don't an account? ",
                  children: [
                    TextSpan(
                        text: (!boolState.value) ? 'Login' : 'Register',
                        style: const TextStyle(
                          color: ColorThemes.secondary,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            boolState.value = !boolState.value;
                          })
                  ],
                  style: const TextStyle(
                    color: ColorThemes.black,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerLost({
    required bool keys,
    required String? user,
    required ValueNotifier loading,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required TextEditingController emailController,
  }) {
    return Container(
      height: 460,
      key: ValueKey(keys),
      margin: const EdgeInsets.symmetric(
        horizontal: 12.5,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorThemes.gray),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: LoginContainer(
        emailController: emailController,
        passwordController: passwordController,
        usernameController: usernameController,
        loading: loading,
        keys: keys,
      ),
    );
  }
}
