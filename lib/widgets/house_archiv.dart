// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:daar/models/item_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ItemCard extends StatefulWidget {
  ItemCard(this.item, this.onTap, {super.key});
  final Item item;
  final Function()? onTap;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Method to format the number with commas for readability
  String formatNumber(double? number) {
    if (number == null) return '0';
    return number.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }

  @override
  Widget build(BuildContext context) {
    // Format the price using the custom method
    final priceFormatted = formatNumber(widget.item.price);

    return Directionality(
      textDirection: TextDirection.rtl, // جعل اتجاه النص من اليمين إلى اليسار
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
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: widget.item.imagePaths != null &&
                              widget.item.imagePaths!.isNotEmpty
                          ? AssetImage(widget.item.imagePaths!.first)
                          : const AssetImage('assets/images/Logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item.category ?? 'غير متوفر',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.item.size ?? '0'} م²',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
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
                          widget.item.numofbed ?? '0',
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
                          widget.item.numofbath ?? '0',
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
                          widget.item.numoflivin ?? '0',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 42, 19, 117),
                    ),
                    Text(
                      '${widget.item.city ?? 'غير متوفر'} حي ${widget.item.district ?? 'غير متوفر'}',
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
                Text(
                  '$priceFormatted ريال سعودي',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        // Add your edit logic here
                      },
                      child: const Text(
                        'إلغاء الأرشفة',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        // Add your delete logic here
                      },
                      child: const Text(
                        'حذف',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
