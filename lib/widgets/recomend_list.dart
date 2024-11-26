// ignore_for_file: camel_case_types, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:daar/widgets/house-cardrec.dart';
import 'package:daar/screens/home_screen.dart';
import 'package:daar/screens/detailsafterclick.dart';

// ignore: must_be_immutable
class recomendList extends StatefulWidget {
  //title recomend and itsms property recomnd
  recomendList(this.title, this.items, {super.key});
  String? title;
  final List<Property> items;

  @override
  State<recomendList> createState() => _recomendListState();
}

//interface of recomend list box
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
                scrollDirection: Axis.horizontal, //print horizental
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      ItemCard(widget.items[index], () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //send to details id
                            builder: (context) =>
                                DetailsBro(widget.items[index].id),
                          ),
                        );
                      }),
                      const SizedBox(width: 12.0),
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
