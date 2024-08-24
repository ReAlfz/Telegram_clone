import 'package:flutter/cupertino.dart';
import 'package:telegram/color.dart';
import 'package:telegram/widget/login_button.dart';
import 'package:telegram/widget/login_textfield.dart';

class LoginContainer extends StatelessWidget {
  final bool keys;
  final ValueNotifier loading;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;

  const LoginContainer({
    super.key,
    required this.keys,
    required this.usernameController,
    required this.passwordController,
    required this.emailController,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return (keys)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorThemes.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              LoginTextField(
                title: 'Email',
                hintText: '',
                controller: emailController,
              ),

              const SizedBox(height: 20),
              LoginTextField(
                title: 'Password',
                hintText: '',
                controller: passwordController,
              ),

              const SizedBox(height: 40),
              LoginButton(
                loading: loading,
                passwordController: passwordController,
                usernameController: usernameController,
                emailController: emailController,
                keys: keys,
              ),
            ],
          )

        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorThemes.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              LoginTextField(
                title: 'Username',
                hintText: '',
                controller: usernameController,
              ),

              const SizedBox(height: 20),
              LoginTextField(
                title: 'Email',
                hintText: '',
                controller: emailController,
              ),

              const SizedBox(height: 20),
              LoginTextField(
                title: 'Password',
                hintText: '',
                controller: passwordController,
              ),

              const SizedBox(height: 40),
              LoginButton(
                loading: loading,
                passwordController: passwordController,
                usernameController: usernameController,
                emailController: emailController,
                keys: keys,
              ),
            ],
          );
  }
}
