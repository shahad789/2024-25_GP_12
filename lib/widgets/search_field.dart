import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daar/screens/filterp.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintText: "ابحث",
        hintTextDirection: TextDirection.rtl,
        prefixIcon: IconButton(
          icon: const Icon(
            Icons.filter_alt_outlined,
            color: Color.fromARGB(255, 42, 19, 117),
          ),
          onPressed: () {
            // Nav
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilterPage()),
            );
          },
        ),
        suffixIcon: const Icon(
          CupertinoIcons.search,
          color: Color.fromARGB(255, 42, 19, 117),
        ),
      ),
    );
  }
}
