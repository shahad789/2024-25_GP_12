import 'package:flutter/material.dart';

Widget roomsSelection(int? selectedValue, Function(int?) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    textDirection: TextDirection.rtl, // لتحديد اتجاه النص من اليمين لليسار
    children: List.generate(5, (index) {
      // الجيل من 5 فقط بدلاً من 6
      final label =
          index < 4 ? '${index + 1}' : '5+'; // قم بتحديد "5+" في النهاية

      return ChoiceChip(
        label: Text(label),
        selected: selectedValue ==
            (index == 4 ? 5 : index + 1), // إذا كان الخيار هو 5+ نعتبره 5
        onSelected: (isSelected) {
          onChanged(isSelected
              ? (index == 4
                  ? 5
                  : index + 1) // إذا تم اختيار "5+"، يتم إرساله كـ 5
              : null); // إذا تم إلغاء التحديد، نمرر null
        },
        selectedColor: const Color.fromARGB(210, 189, 185, 185),
        backgroundColor: const Color.fromARGB(210, 221, 216, 216),
      );
    }),
  );
}
