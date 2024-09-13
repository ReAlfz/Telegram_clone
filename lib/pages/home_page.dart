import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/model/user_model.dart';
import 'package:telegram/pages/addchat_page.dart';
import 'package:telegram/provider/database.dart';
import 'package:telegram/widget/drawer_home.dart';
import 'package:telegram/widget/item_list.dart';

class HomePage extends HookConsumerWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var getData = ref.watch(userCloudProviderV2(uid));

    return FutureBuilder(
      future: ref.read(userCloudProvider(uid).notifier).getUser(currentUid: uid),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            UserModel currentUser = snapshot.data!;
            return Scaffold(
              drawer: DrawerHome(
                currentUser: currentUser,
                ref: ref,
              ),
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: ColorThemes.white,
                surfaceTintColor: ColorThemes.white,
                title: const Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 22.5,
                    fontWeight: FontWeight.bold,
                    color: ColorThemes.black,
                  ),
                ),

                actions: [
                  AddChatPage(currentUser: currentUser),
                ],
              ),
              body: getData.when(
                data: (list) {
                  return ListView.builder(
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = list[index];
                      return ItemList(
                        fromData: data,
                        currentUser: currentUser,
                      );
                    },
                  );
                },
                error: (error, stack) => Center(child: Text('Error: $error')),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: ColorThemes.primary),
                ),
              ),
            );

          case ConnectionState.waiting:
            return const Material(
              child: Center(
                child: CircularProgressIndicator(color: ColorThemes.primary),
              ),
            );

          default:
            return const Material(
              child: Center(
                child: Text('Something Wrong, please try again later...'),
              ),
            );
        }
      },
    );
  }
}