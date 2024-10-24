// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:daar/screens/pass.dart'; // استيراد صفحة fav.dart

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // إزالة السهم الافتراضي
          elevation: 0.0,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          centerTitle: true, // لجعل العنوان في المنتصف
          title: const Text(
            'إعدادات الحساب', // العنوان هنا
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
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF180A44),
                      Color(0xFF180A44),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 90.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildInputField(context, 'شوق الدوسري', Icons.person),
                      const SizedBox(height: 10),
                      _buildInputField(context, '0582880115', Icons.phone),
                      const SizedBox(height: 10),
                      _buildInputField(
                          context, 'example@example.com', Icons.email),
                      const SizedBox(height: 10),
                      _buildInputField(context, 'أنثى', Icons.transgender),
                      const SizedBox(height: 10),
                      _buildInputField(context, '01/01/2000', Icons.cake),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // وظيفة حفظ التعديلات
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF180A44),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('حفظ'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // توجيه المستخدم إلى صفحة إعادة تعيين كلمة المرور
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PassPage()), // استبدل PassPage باسم الصفحتك
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('إعادة تعيين كلمة المرور'),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Icon(icon,
                color: Colors.grey, size: 20), // الأيقونة تبقى في الجهة اليسرى
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight, // لضبط النص إلى اليمين
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey, // لون الخط تحت الحقل
          thickness: 1, // سمك الخط
        ),
      ],
    );
  }
}
