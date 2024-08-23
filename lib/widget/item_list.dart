import 'package:flutter/material.dart';
import 'package:telegram/color.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: ColorThemes.background,
      child: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa4xjShh4ynJbrgYrW_aB4lhKSxeMzQ3cO_A&s'),
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
                      'Agum',
                      style: TextStyle(
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
                      style: TextStyle(
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
    );
  }
}