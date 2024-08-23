import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/widget/item_list.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
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

            leading: TextButton(
              onPressed: () {},
              child: const Text(
                'Edit',
                style: TextStyle(
                    fontSize: 18,
                    color: ColorThemes.secondary,
                    fontWeight: FontWeight.w600
                ),
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

          SliverToBoxAdapter(
            child: Container(
              color: ColorThemes.white,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),


          SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ItemList();
            },
          ),
        ],
      ),
    );
  }
}