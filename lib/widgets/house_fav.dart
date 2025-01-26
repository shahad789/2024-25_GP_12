import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/screens/fav.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  Future<void> _toggleFavorite(String? currentUserId) async {
    if (currentUserId == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('user').doc(currentUserId);
    final userDoc = await userRef.get();

    List<String> favorites = [];

    if (userDoc.exists && userDoc.data() != null) {
      // Ensure 'favorites' exists and is a List<String>
      favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);
    }

    if (favorites.contains(widget.item.id)) {
      favorites.remove(widget.item.id);
    } else {
      favorites.add(widget.item.id);
    }

    // Update Firestore with merged data
    await userRef.set({'favorites': favorites}, SetOptions(merge: true));

    setState(() {
      isFavorite = favorites.contains(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access user ID from UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = userProvider.userDocId;

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

                //type, size, and favorite icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Size and Favorite Icon on the left
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(currentUserId),
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

                    // Category on the right
                    Text(
                      widget.item.category,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.item.city} حي ${widget.item.district}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 128, 127, 127),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 42, 19, 117),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                //price
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'ريال سعودي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        priceFormatted,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                        ),
                      ),
                      // Add space between the number and the text
                    ],
                  ),
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
