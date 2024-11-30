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
  late String selectedCategory;

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
        widget.onCategorySelected(type); // update category in parent
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
