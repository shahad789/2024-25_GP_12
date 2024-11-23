import 'package:flutter/material.dart';

class SelectCategory extends StatelessWidget {
  final Function(String) onCategorySelected; // Callback to notify parent widget
  final String selectedCategory; // Current selected category

  const SelectCategory({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

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
          categoryButton(Icons.stairs_rounded, "دور", "دور"),
          categoryButton(Icons.apartment_rounded, "شقه", "شقه"),
        ],
      ),
    );
  }

  Widget categoryButton(IconData icon, String text, String category) {
    bool isSelected =
        selectedCategory == category; // Check if this category is selected

    return GestureDetector(
      onTap: () {
        onCategorySelected(
            category); // Notify the parent widget about the selected category
      },
      child: Container(
        margin: const EdgeInsets.all(18.0),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(
                    255, 224, 217, 199) // Highlight border color
                : Colors.grey.shade300,
          ),
          color: isSelected
              ? const Color.fromARGB(255, 189, 185, 185)
                  .withOpacity(0.7) // Highlighted background color
              : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected
                  ? const Color.fromARGB(
                      255, 58, 29, 78) // Icon color when selected
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(
                        255, 58, 29, 78) // Text color when selected
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
