// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:daar/widgets/vertical_archiv.dart';
import 'package:daar/models/item_model.dart'; // تأكد من صحة هذا المسار

class Archiv extends StatelessWidget {
  const Archiv({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // السماح بالرجوع
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // إزالة السهم الافتراضي
          elevation: 0.0,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          title: const Center(
            child: Text(
              'الأرشيف', // العنوان هنا
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/Logo.png', // تأكد من صحة مسار الصورة
                height: 25.0,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); // العودة للصفحة السابقة
            },
            icon: const Icon(
              Icons.arrow_back, // سهم الرجوع
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF180A44), // لون الخلفية لـ Scaffold
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20.0), // إضافة مساحة علوية
                VerticalRecomendList("", Item.normal), // حذف كلمة "العقارات"
                // يمكنك إضافة المزيد من المحتوى هنا
              ],
            ),
          ),
        ),
      ),
    );
  }
}
