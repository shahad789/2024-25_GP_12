import 'package:flutter/material.dart';

class PassPage extends StatelessWidget {
  const PassPage({super.key});

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
            'إعادة تعيين كلمة المرور', // العنوان هنا
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
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // محاذاة النص إلى اليمين
                    children: [
                      _buildPasswordField('كلمة المرور الحالية'),
                      const SizedBox(height: 2),
                      _buildPasswordField('كلمة المرور'),
                      const SizedBox(height: 2),
                      _buildPasswordField('تأكيد كلمة المرور'),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // منطق إعادة تعيين كلمة المرور هنا
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF180A44),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('إعادة تعيين كلمة المرور'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // منطق "هل نسيت كلمة المرور؟" هنا
                          },
                          child: const Text(
                            'هل نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: Color(0xFF180A44),
                              fontSize: 16,
                            ),
                          ),
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

  Widget _buildPasswordField(String labelText) {
    return Directionality(
      textDirection: TextDirection.rtl, // تعيين اتجاه النص إلى اليمين
      child: TextFormField(
        obscureText: true, // إخفاء النص
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: const UnderlineInputBorder(), // المدخل بخط سفلي فقط
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // تخصيص لون الخط
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 8.0), // التحكم في مكان الأيقونة
            child: Icon(
              Icons.visibility_off, // أيقونة العيون المغلقة
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
