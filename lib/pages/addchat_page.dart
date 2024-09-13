import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/model/user_model.dart';
import 'package:telegram/provider/database.dart';
import 'package:telegram/widget/item_list.dart';

class AddChatPage extends HookConsumerWidget {
  final UserModel currentUser;
  const AddChatPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final data = ref.read(userCloudProvider(currentUser.uid));

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            constraints: BoxConstraints.loose(
              Size(
                size.width,
                size.height * 0.95,
              ),
            ),
            context: context,
            builder: (context) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)
                    ),
                    child: AppBar(
                      centerTitle: true,
                      title: const Text(
                        'New Message',
                        style: TextStyle(
                          color: ColorThemes.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leadingWidth: 100,
                      leading: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorThemes.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      color: ColorThemes.white,
                      child: data.when(
                        data: (list) {
                          return ListView.builder(
                            itemCount: list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ItemList(
                                fromData: list[index],
                                currentUser: currentUser,
                              );
                            },
                          );
                        },
                        error: (error, stack) => Center(child: Text(error.toString())),
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: ColorThemes.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 25,
          color: ColorThemes.secondary,
        ),
      ),
    );
  }
}