import 'package:flutter/material.dart';
import 'package:telegram/color.dart';
import 'package:telegram/model/user.dart';
import 'package:telegram/pages/chat_page.dart';
import 'package:telegram/provider/database.dart';

class ItemList extends StatelessWidget {
  final UserModel data;
  final String? currentUid;
  const ItemList({super.key, required this.data, required this.currentUid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ChatPage(
                user: data,
                params: Params(currentUid: currentUid!, fromUid: data.uid),
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
                    image: NetworkImage(data.icon),
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
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        data.username,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorThemes.black,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'come here',
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