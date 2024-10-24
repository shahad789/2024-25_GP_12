// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:daar/widgets/vertical_recomend_list2.dart';
import 'package:daar/models/item_model.dart'; // تأكد من صحة هذا المسار

class OwenScreen extends StatelessWidget {
  const OwenScreen({Key? key}) : super(key: key);

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
          centerTitle: true, // لجعل العنوان في المنتصف
          title: const Text(
            'عقاراتي', // العنوان هنا
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context); // العودة للصفحة السابقة
              },
              icon: const Icon(
                Icons.arrow_forward, // سهم الرجوع لليمين
                color: Colors.white,
              ),
            ),
          ],
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
