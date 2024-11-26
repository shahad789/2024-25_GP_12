import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // comma of readibility package 3ashan price
import 'package:daar/screens/home_screen.dart';

// ignore: must_be_immutable
class ItemCard extends StatefulWidget {
  ItemCard(this.item, this.onTap, {super.key});
  Property item;
  Function()? onTap;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final priceFormatted = NumberFormat('#,##0', 'en_US')
        .format(widget.item.price); //this for comma 3ashan readability

    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: const Color(0x00fcf9f8),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //image
              Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                    image: NetworkImage(widget.item.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              //type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item.category,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.item.size} م²',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              //rooms
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.bed,
                        size: 19.0,
                        color: Color.fromARGB(255, 42, 19, 117),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "${widget.item.numofbed.toString()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.bathtub,
                        size: 19.0,
                        color: Color.fromARGB(255, 42, 19, 117),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "${widget.item.numofbath.toString()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_seat,
                        size: 19.0,
                        color: Color.fromARGB(255, 42, 19, 117),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "${widget.item.numoflivin.toString()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              //location
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 42, 19, 117),
                  ),
                  Text(
                    '${widget.item.city} حي ${widget.item.District}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 128, 127, 127),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              //price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$priceFormatted ريال سعودي',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
