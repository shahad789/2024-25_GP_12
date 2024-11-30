import 'package:flutter/material.dart';

Widget cityDropdown(String? selectedCity, Function(String?) onChanged) {
  return Directionality(
    textDirection: TextDirection.rtl, // direction start right
    child: DropdownButton<String>(
      isExpanded: true,
      hint: const Text(
        'اختر المدينة',
        textAlign: TextAlign.right,
      ),
      value: selectedCity, // when selected show what we saved up
      items: const [
        // this will change later with database cuz we take from somewhere
        DropdownMenuItem<String>(
          value: 'الرياض',
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('الرياض'),
          ),
        ),
        DropdownMenuItem<String>(
          value: 'جدة',
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('جدة'),
          ),
        ),
        DropdownMenuItem<String>(
          value: 'الدمام',
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('الدمام'),
          ),
        ),
      ],
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down), // so left arabic
      iconSize: 24,
      dropdownColor: Colors.white,
      underline: Container(), // remove line cuz ugly
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
  );
}
