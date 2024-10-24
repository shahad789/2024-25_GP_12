// ignore_for_file: avoid_unnecessary_containers

import 'package:daar/models/item_model.dart';
import 'package:daar/widgets/house_card.dart';
import 'package:flutter/material.dart';
import 'package:daar/screens/detailsafterclick.dart';

/// Widget of vertical listed property normal ones
class VerticalRecomendList extends StatelessWidget {
  const VerticalRecomendList(this.title, this.items, {super.key});

  final String? title;
  final List<Item> items;

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
            physics:
                const NeverScrollableScrollPhysics(), //control the scroll behavior of list viewthis code diable it
            shrinkWrap:
                true, //take space need or expand to fill it 3ashan if false it try to expand to fit max available height hata lw items shwy
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    ItemCard(items[index], () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsBro(items[index]),
                        ),
                      );
                    }),
                    const SizedBox(height: 12.0),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
