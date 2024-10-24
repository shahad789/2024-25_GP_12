import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  int? selectedCategoryIndex; // to know esh 25tart

  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.2,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        children: [
          categoryButton(Icons.villa_rounded, "فيلا", 0),
          categoryButton(Icons.apartment_rounded, "شقه", 1),
          categoryButton(Icons.stairs_rounded, "دور", 2),
        ],
      ),
    );
  }

  Widget categoryButton(IconData icon, String text, int index) {
    bool isSelected = selectedCategoryIndex == index; //esh select

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
            selectedCategoryIndex = index;
          });
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
