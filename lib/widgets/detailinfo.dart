import 'package:flutter/material.dart';

Widget contactdet(String label, String value) {
  return Container(
    width: double.infinity, // kamel jehateen
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(210, 221, 216, 216),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 13, 6, 37),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone,
                color: Color(0xFF180A44),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Color.fromARGB(255, 13, 6, 37),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
