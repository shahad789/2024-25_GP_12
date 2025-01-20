import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/screens/edite.dart';
import 'package:daar/screens/owen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatefulWidget {
  final Property item;
  final Function()? onTap;

  ItemCard(this.item, this.onTap, {super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final priceFormatted =
        NumberFormat('#,##0', 'en_US').format(widget.item.price);
    final dateFormatted =
        DateFormat('yyyy-MM-dd').format(widget.item.dateList.toDate());

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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Image
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

              // Type and Size
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.item.size} م²',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

              // Room Info
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

              // Location
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.item.city} حي ${widget.item.District}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 128, 127, 127),
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 42, 19, 117),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Price
              Text(
                '$priceFormatted ريال سعودي',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),

              // Status
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color:
                      widget.item.status == "متوفر" ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.item.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Date Listed
              Text(
                'تاريخ الاعلان: $dateFormatted',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8.0),

              // Views
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.visibility,
                      color: Colors.black54, size: 20.0),
                  const SizedBox(width: 5.0),
                  Text(
                    '${widget.item.view}',
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Edit and Delete Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Delete Button
                  TextButton(
                    onPressed: () => _confirmDelete(context),
                    child: const Text(
                      'حذف',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  // Edit Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PropertyDetailsPage(propertyId: widget.item.id),
                        ),
                      );
                    },
                    child: const Text(
                      'تعديل',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
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

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد الحذف"),
          content: const Text("هل أنت متأكد من حذف هذا العقار؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('Property')
            .doc(widget.item.id)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف العقار بنجاح')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء الحذف')),
        );
      }
    }
  }
}
