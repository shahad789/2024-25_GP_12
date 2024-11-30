import 'package:flutter/material.dart';

Widget roomsSelection(int? selectedValue, Function(int?) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    textDirection: TextDirection.rtl,
    children: List.generate(5, (index) {
      final label = index < 4 ? '${index + 1}' : '5+';
      return ChoiceChip(
        label: Text(label),
        selected: selectedValue == (index == 4 ? 5 : index + 1),
        onSelected: (isSelected) {
          onChanged(isSelected
              ? (index == 4 ? 5 : index + 1)
              : null); // if not choosen it will send null
        },
        selectedColor: const Color.fromARGB(210, 189, 185, 185),
        backgroundColor: const Color.fromARGB(210, 221, 216, 216),
      );
    }),
  );
}
