// ignore_for_file: camel_case_types, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:daar/widgets/house-cardrec.dart';
import 'package:daar/screens/home_screen.dart';
import 'package:daar/screens/detailsafterclick.dart';

/// Widget of recomend list box nafso

// ignore: must_be_immutable
class recomendList extends StatefulWidget {
  recomendList(this.title, this.items, {super.key});
  String? title;
  final List<Property> items;

  @override
  State<recomendList> createState() => _recomendListState();
}

class _recomendListState extends State<recomendList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          SizedBox(
            height: 340.0,
            width: double.infinity,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // عرض العناصر بشكل أفقي
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ItemCard(widget.items[index], () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //  builder: (context) => DetailsBro(items[index]),
                            builder: (context) =>
                                DetailsBro(widget.items[index].id),
                          ),
                        );
                      }),
                      const SizedBox(width: 12.0), // مسافة بين العناصر
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
              // Button on the left
              /* TextButton(
                onPressed: () {},
                child: const Text(
                  "عرض الجميع",
                  style: TextStyle(
                      color: Color(0xFF180A44)), // Custom color for "See All"
                ),
              ),*/
              // Title on the right