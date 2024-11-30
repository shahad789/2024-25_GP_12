import 'package:flutter/material.dart';

Widget districtDropDown(String? selectedDistrict, Function(String?) onChanged) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: DropdownButton<String>(
      isExpanded: true,
      hint: const Text(
        'اختر الحي',
        textAlign: TextAlign.right,
      ),
      value: selectedDistrict,
      items: const [
        DropdownMenuItem<String>(
          value: 'حي العليا',
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('حي العليا'),
          ),
        ),
        DropdownMenuItem<String>(
          value: 'حي الشفا',
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('حي الشفا'),
          ),
        ),
        DropdownMenuItem<String>(
          value: 'حي المطار',
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('حي المطار'),
          ),
        ),
      ],
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      dropdownColor: Colors.white,
      underline: Container(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
  );
}
