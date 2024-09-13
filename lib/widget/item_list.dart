import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/color.dart';
import 'package:telegram/model/user_model.dart';
import 'package:telegram/pages/chat_page.dart';
import 'package:telegram/provider/database.dart';

class ItemList extends StatelessWidget {
  final UserModel fromData;
  final UserModel currentUser;

  const ItemList({
    super.key,
    required this.fromData,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ChatPage(
                fromUser: fromData,
                currentUser: currentUser,
                params: Params(currentUid: currentUser.uid, fromUid: fromData.uid),
              );
            },
          ),
        );
      },
      child: Container(
        height: 90,
        color: ColorThemes.background,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(fromData.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Flexible(
              flex: 8,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fromData.username,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorThemes.black,
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.black.withOpacity(0.1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}