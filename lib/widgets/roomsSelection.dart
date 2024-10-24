// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget roomsSelection(int? selectedValue, Function(int?) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(5, (index) {
      final reverseIndex =
          5 - index; // To start from left to right (for Arabic)
      final label = reverseIndex < 5 ? '$reverseIndex' : '5+';

      return ChoiceChip(
        label: Text(label),
        selected: selectedValue == reverseIndex,
        onSelected: (isSelected) {
          onChanged(isSelected ? reverseIndex : null);
        },
        selectedColor: const Color.fromARGB(210, 189, 185, 185),
        backgroundColor: const Color.fromARGB(210, 221, 216, 216),
      );
    }),
  );
}
