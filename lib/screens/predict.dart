// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart'; // تأكد من استيراد صفحة home_screen.dart

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const predictpage());
}

class predictpage extends StatelessWidget {
  const predictpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: const PropertyDetailsPage(),
    );
  }
}

class PropertyDetailsPage extends StatefulWidget {
  const PropertyDetailsPage({super.key});

  @override
  createState() => _PropertyDetailsPageState();
}

// إضافة المدينة والحي
class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  String? selectedCity;
  String? selectedNeighborhood;
  String? selectedPropertyType; // المتغير لتخزين نوع العقار المحدد
  bool showEstimation = false; // متغير للتحكم في عرض صندوق القيمة

  final List<String> cities = [
    'الرياض',
    'جدة',
    'الدمام',
    'الخبر',
    'أخرى',
  ];

  final List<String> neighborhoods = ['حي 1', 'حي 2', 'حي 3'];

  final List<String> propertyTypes = ['دور', 'فيلا', 'شقة']; // أنواع العقارات

  // تقدير العقار
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        toolbarHeight: 70.0,
        title: const Text(
          '  تقدير العقار',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              // العودة إلى الصفحة الرئيسية
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF180A44),
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildPropertyType(), // إضافة واجهة اختيار نوع العقار
                const SizedBox(height: 20),

                // إضافة الخط الفاصل هنا
                const Divider(
                  color: Colors.white, // لون الخط
                  thickness: 2, // سمك الخط
                  height: 40, // المسافة حول الخط
                ),

                const SizedBox(height: 30),
                _buildInputField(
                    context, 'مساحة الأرض (متر مربع)', Icons.landscape),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد الغرف', Icons.bed),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد دورات المياه', Icons.bathtub),
                const SizedBox(height: 30),
                _buildDropdownField('المدينة', cities, (value) {
                  setState(() {
                    selectedCity = value;
                  });
                }),
                const SizedBox(height: 30),
                _buildDropdownField('الحي', neighborhoods, (value) {
                  setState(() {
                    selectedNeighborhood = value;
                  });
                }),
                const SizedBox(height: 30),
                _buildHelpBox(), // الزر موجود هنا
                const SizedBox(height: 30),
                if (showEstimation)
                  _buildCurrencyInput(), // يظهر إذا كانت الحالة true
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة لبناء واجهة اختيار نوع العقار
  Widget _buildPropertyType() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF180A44),
                Color(0xFF180A44),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPropertyTypeButton('دور', Icons.house),
              _buildVerticalDivider(),
              _buildPropertyTypeButton('فيلا', Icons.villa),
              _buildVerticalDivider(),
              _buildPropertyTypeButton('شقة', Icons.apartment),
            ],
          ),
        ),
      ],
    );
  }

  // دالة لإنشاء زر نوع العقار
  Widget _buildPropertyTypeButton(String label, IconData icon) {
    bool isSelected = selectedPropertyType == label; // تحقق إذا كان الزر محددًا
    return GestureDetector(
      onTap: () {
        setState(() {
          // تحديث الحالة عند الضغط
          selectedPropertyType = label; // تعيين النوع المحدد
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey
              : Colors.transparent, // تغيير لون الخلفية عند التحديد
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected
                    ? Colors.black
                    : Colors.white), // لون الأيقونة عند التحديد
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Colors.white, // لون النص عند التحديد
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإنشاء فاصل عمودي (Divider)
  Widget _buildVerticalDivider() {
    return const VerticalDivider(
      color: Colors.white, // لون الفاصل
      thickness: 2, // سمك الفاصل
      width: 20, // المسافة حول الفاصل
    );
  }

  // تقدير عقارك
  Widget _buildHelpBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showEstimation = !showEstimation; // تغيير حالة العرض عند الضغط
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF180A44),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // تغيير المحاذاة إلى المركز
          children: [
            Text(
              'تقدير عقارك',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.lightbulb, color: Colors.yellow),
          ],
        ),
      ),
    );
  }

  // صندوق قيمة التقدير التي ستظهر
  Widget _buildCurrencyInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF180A44),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 130,
            height: 33,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 13),
                  child: const Text(
                    'ر.س',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                    onSubmitted: (value) {
                      // يمكنك إضافة أي منطق هنا عند إدخال القيمة
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 7),
          child: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'بناء على العقارات المشابهة\n',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                TextSpan(
                  text: ': قيمة عقارك سوف تكون في حدود',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF180A44)),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // قائمة منسدلة لاختيار العنصر
  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Align(
              alignment: Alignment.centerRight,
              child: Text(
                label,
                textAlign: TextAlign.right,
              ),
            ),
            value: label == 'المدينة' ? selectedCity : selectedNeighborhood,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF180A44)),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(item),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            underline: Container(
              height: 1,
              color: const Color(0xFF180A44),
            ),
          ),
        ),
      ],
    );
  }
}
