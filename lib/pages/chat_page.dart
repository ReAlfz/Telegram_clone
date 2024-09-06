import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:telegram/color.dart';
import 'package:telegram/model/user.dart';
import 'package:telegram/provider/database.dart';

class ChatPage extends HookConsumerWidget {
  final UserModel user;
  final Params params;
  const ChatPage({super.key, required this.user, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final initialData = ref.watch(chatCloudProvider(params));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorThemes.white,
        centerTitle: true,
        title: Text(
          user.username,
          style: const TextStyle(
            fontSize: 22.5,
            color: ColorThemes.black,
          ),
        ),
        actions: [
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(user.icon),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: ColorThemes.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: initialData.when(
              data: (chats) {
                return ListView.builder(
                  itemCount: chats.length,
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = chats[chats.length -1 - index];
                    return ChatBubble(
                      clipper: ChatBubbleClipper8(
                        type: (data.sender)
                            ? BubbleType.sendBubble
                            : BubbleType.receiverBubble,
                      ),
                      backGroundColor: (data.sender)
                          ? ColorThemes.primary
                          : ColorThemes.gray,
                      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      alignment: (data.sender)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 30, 10),
                            child: Text(
                              data.text,
                              style: const TextStyle(
                                  fontSize: 18, color: ColorThemes.black),
                            ),
                          ),
                          Positioned(
                            bottom: 2.5,
                            right: 3.5,
                            child: Text(
                              formatDateTime(data.timestamp.toDate()),
                              style: const TextStyle(
                                  fontSize: 10, color: ColorThemes.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (error, stack) => Center(child: Text('Error: $error')),
              loading: () => const Center(
                child: CircularProgressIndicator(color: ColorThemes.primary),
              ),
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                alignment: Alignment.bottomCenter,
                color: ColorThemes.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 9,
                      fit: FlexFit.tight,
                      child: TextField(
                        minLines: 1,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        controller: textController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Message',
                          fillColor: ColorThemes.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: ColorThemes.primary,
                        ),
                        icon: const Icon(
                          Icons.arrow_upward_rounded,
                          color: ColorThemes.white,
                        ),
                        onPressed: () async {
                          ref.read(chatCloudProvider(params).notifier).createData(
                            text: textController.text,
                          ).then((value) => textController.clear());
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    int hours = dateTime.hour;
    int minute = dateTime.minute;

    String hourStr = hours.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    return '$hourStr:$minuteStr';
  }
}
