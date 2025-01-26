import 'package:daar/screens/fav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatefulWidget {
  const ItemCard(this.item, this.onTap, {super.key});
  final Property item;
  final Function()? onTap;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isFavorite = true;

  String formatNumber(double? number) {
    if (number == null) return '0';
    return number.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final priceFormatted =
        NumberFormat('#,##0', 'en_US').format(widget.item.price);

    return Container(
      child: Container(
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
                //images
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

                    //size
                    Row(
                      children: [
                        Text(
                          '${widget.item.size} م²',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                //number of bed, bath, living
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildIconText(Icons.event_seat, widget.item.numOfLiving),
                    const SizedBox(width: 16.0),
                    _buildIconText(Icons.bathtub, widget.item.numOfBath),
                    const SizedBox(width: 16.0),
                    _buildIconText(Icons.bed, widget.item.numOfBed),
                  ],
                ),
                const SizedBox(height: 8.0),

                //city district
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 42, 19, 117),
                    ),
                    Text(
                      '${widget.item.city} حي ${widget.item.district}',
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
                Text(
                  '$priceFormatted ريال سعودي',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, int count) {
    return Row(
      children: [
        const SizedBox(width: 4.0),
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        Icon(icon, size: 19.0, color: const Color.fromARGB(255, 42, 19, 117)),
      ],
    );
  }
}
