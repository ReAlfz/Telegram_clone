import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/model/user.dart';
import 'package:telegram/provider/database.dart';
import 'package:telegram/widget/drawer_home.dart';
import 'package:telegram/widget/item_list.dart';

class HomePage extends HookConsumerWidget {
  final String? uid;
  const HomePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userCloudProvider);
    final controller = useTextEditingController();
    final listState = useState<List<UserModel>>([]);

    useEffect(() {
      controller.addListener(() {
        listState.value = (controller.text.isNotEmpty)
            ? data.value?.where(
                (element) => element.username.contains(controller.text)
        ).toList() ?? [] : data.value ?? [];
      });
      return null;
    }, [controller.text]);

    return Scaffold(
      drawer: DrawerHome(ref: ref),
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
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 25,
                color: ColorThemes.secondary,
              ),
            ),
          ),
        ],
      ),
      body: data.when(
        data: (userData) {
          userData.removeWhere((element) => element.uid == uid);
          listState.value = (controller.text.isNotEmpty) ? userData.where(
                  (element) => element.username.contains(controller.text)
          ).toList() : userData;
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: ColorThemes.white,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Search",
                      fillColor: ColorThemes.background,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    style: const TextStyle(color: ColorThemes.black),
                  ),
                ),
              ),

              SliverList.builder(
                itemCount: listState.value.length,
                itemBuilder: (context, index) => ItemList(
                  data: listState.value[index],
                  currentUid: uid,
                ),
              ),
            ],
          );
        },
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const Center(
          child: CircularProgressIndicator(color: ColorThemes.primary),
        ),
      ),
    );
  }
}