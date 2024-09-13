import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/model/user_model.dart';
import 'package:telegram/pages/login_page.dart';
import 'package:telegram/provider/authenticator.dart';
import 'package:telegram/provider/database.dart';
import 'package:telegram/provider/themes.dart';

class DrawerHome extends StatelessWidget {
  final WidgetRef ref;
  final UserModel currentUser;
  const DrawerHome({super.key, required this.currentUser, required this.ref});

  @override
  Widget build(BuildContext context) {
    bool valueSwitch = ref.watch(themeApp);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(currentUser.icon),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              currentUser.username,
              style: const TextStyle(
                fontSize: 22.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.dark_mode,
                      size: 20,
                    ),

                    SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                Switch(
                  value: valueSwitch,
                  onChanged: (value) {
                    ref.read(themeApp.notifier).toggle();
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.logout_outlined,
                  size: 20,
                ),

                const SizedBox(width: 20),
                SizedBox(
                  width: 100,
                  child: GestureDetector(
                    onTap: () async {
                      await ref.read(authFirebaseProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return const LoginPage();
                            },
                          ), (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}