import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback to notify parent widget
  final String selectedCategory; // Current selected category

  const SelectCategory({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  late String selectedCategory; // النوع المختار حاليًا

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF180A44), Color(0xFF180A44)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          categoryButton("شقه"),
          categoryButton("دور"),
          categoryButton("فيلا"),
        ],
      ),
    );
  }

  Widget categoryButton(String type) {
    bool isSelected = selectedCategory == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = type;
        });
        widget.onCategorySelected(type); // تحديث العنصر المختار في الأب
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              _getIconForType(type),
              color: isSelected ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'فيلا':
        return Icons.house;
      case 'دور':
        return Icons.home_work;
      case 'شقه':
        return Icons.apartment;
      default:
        return Icons.help_outline;
    }
  }
}

  // Widget categoryButton(IconData icon, String text, String category) {
  //   bool isSelected =
  //       selectedCategory == category; // Check if this category is selected

  //   return GestureDetector(
  //     onTap: () {
  //       onCategorySelected(
  //           category); // Notify the parent widget about the selected category
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.all(18.0),
  //       width: 100.0,
  //       height: 100.0,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           color: isSelected
  //               ? const Color.fromARGB(
  //                   255, 224, 217, 199) // Highlight border color
  //               : Colors.grey.shade300,
  //         ),
  //         color: isSelected
  //             ? const Color.fromARGB(255, 189, 185, 185)
  //                 .withOpacity(0.7) // Highlighted background color
  //             : Colors.white,
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             icon,
  //             size: 48,
  //             color: isSelected
  //                 ? const Color.fromARGB(
  //                     255, 58, 29, 78) // Icon color when selected
  //                 : Colors.grey.shade600,
  //           ),
  //           const SizedBox(height: 8.0),
  //           Text(
  //             text,
  //             style: TextStyle(
  //               color: isSelected
  //                   ? const Color.fromARGB(
  //                       255, 58, 29, 78) // Text color when selected
  //                   : Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }