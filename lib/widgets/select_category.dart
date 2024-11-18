import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  final Function(String)? onCategorySelected; // تم تغيير نوع الفئة لتكون String

  const SelectCategory({super.key, this.onCategorySelected});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  String? selectedCategory; // لتتبع الفئة المختارة

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.2,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        children: [
          categoryButton(Icons.villa_rounded, "فيلا", "فيلا"),
          categoryButton(Icons.apartment_rounded, "شقه", "شقه"),
          categoryButton(Icons.stairs_rounded, "دور", "دور"),
        ],
      ),
    );
  }

  Widget categoryButton(IconData icon, String text, String category) {
    bool isSelected =
        selectedCategory == category; // تحقق من إذا كان الزر مختاراً

    return Container(
      margin: const EdgeInsets.all(18.0),
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 224, 217, 199)
                : Colors.grey.shade100),
        color: isSelected
            ? const Color.fromARGB(210, 189, 185, 185).withOpacity(0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedCategory = category; // تحديث الفئة المختارة
          });
          if (widget.onCategorySelected != null) {
            widget.onCategorySelected!(
                category); // إشعار الويدجت الأب بالفئة المختارة
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: const Color.fromARGB(255, 58, 29, 78),
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 117, 117, 117)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
