// vertical_recommend_list.dart
// ignore_for_file: avoid_unnecessary_containers

import 'package:daar/screens/detailsafterclick.dart';
import 'package:daar/screens/owen.dart';
import 'package:daar/widgets/house_card2.dart';
import 'package:flutter/material.dart';

class VerticalRecomendList extends StatelessWidget {
  const VerticalRecomendList(this.title, this.items, {super.key});

  final String? title;
  final List<Property> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 12.0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap:
                true, // Allow ListView to take height based on its children
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ItemCard(items[index], () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsBro(items[index].id),
                        //give details id of specific item to show
                      ),
                    );
                  }),
                  const SizedBox(height: 12.0),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
