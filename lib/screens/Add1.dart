// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:daar/screens/home_screen.dart'; // استيراد الصفحة الرئيسية

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

//اختيار المدينه- حي-المنطقه -الاتجاهات
class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  String? selectedCity;
  String? selectedNeighborhood;
  String? selectedRegion;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController streetWidthController = TextEditingController();
  final TextEditingController locationLinkController = TextEditingController();
  File? selectedImage;

  final List<String> cities = [
    'الرياض',
    'جدة',
    'الدمام',
    'الخبر',
    'أخرى',
  ];

  final List<String> neighborhoods = ['حي 1', 'حي 2', 'حي 3'];
  final List<String> regions = [
    'مكة المكرمة',
    'المدينة المنورة',
    'القصيم',
    'المنطقة الشرقية',
    'عسير',
    'تبــوك',
    'حائل',
    'الحدود الشمالية',
    'جازان',
    'نجران',
    'الباحة',
    'الجـوف',
  ];

  final List<String> directions = ['شمال', 'جنوب', 'شرق', 'غرب'];
  final List<String> selectedDirections = [];

  @override
  void dispose() {
    dateController.dispose();
    priceController.dispose();
    streetWidthController.dispose();
    locationLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

// الواجهه تحتوي  على الاتجاهات شرق- غرب- جنوب-شمال
  Widget _buildDirectionsDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 280.0),
          child: Row(
            children: [
              Text(
                'الواجهة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8.0,
          children: directions.map((direction) {
            return ChoiceChip(
              label: Text(
                direction,
                style: const TextStyle(color: Colors.black),
              ),
              selected: selectedDirections.contains(direction),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedDirections.add(direction);
                  } else {
                    selectedDirections.remove(direction);
                  }
                });
              },
              selectedColor: const Color.fromARGB(255, 225, 225, 225),
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Text(
          'الاتجاهات المحددة: ${selectedDirections.join(', ')}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

//تفاصيل العقار
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        toolbarHeight: 70.0,
        title: const Text(
          'تفاصيل العقار',
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
            //المعلومات الظاهره في الفورم
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildPropertyType(),
                const SizedBox(height: 20),
                _buildInputField(
                    context, 'مساحة الأرض (متر مربع)', Icons.landscape),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد الغرف', Icons.bed),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد دورات المياه', Icons.bathtub),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد غرف الجلوس', Icons.event_seat),
                const SizedBox(height: 30),
                _buildStreetWidthField(),
                const SizedBox(height: 30),
                _buildYearBuiltField(context),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                _buildDropdownField('المنطقة', regions, (value) {
                  setState(() {
                    selectedRegion = value;
                  });
                }),
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
                _buildDirectionsDropdown(),
                const SizedBox(height: 30),
                _buildImagePicker(),
                const SizedBox(height: 10),
                _buildImagePreview(),
                const SizedBox(height: 30),
                _buildBoxField(context, 'تفاصيل', Icons.comment, isLarge: true),
                const SizedBox(height: 30),
                _buildHelpAndPriceRow(context),
                const SizedBox(height: 30),
                // الجملة النصية الجديدة قبل زر الإضافة
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // توزيع العناصر بين الجانبين
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF180A44),
                          width: 3, // سمك الحواف
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // جعل الحواف مربعة
                      ),
                      child: SizedBox(
                        width: 130, // تقليل الحجم
                        height: 33, // تقليل الحجم
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // محاذاة المحتوى إلى اليسار
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top:
                                      13), // تعديل المسافة بين النص وحقل الإدخال
                              child: const Text(
                                'ر.س', // النص الذي تريد إضافته
                                style: TextStyle(
                                  fontSize: 13, // حجم الخط
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // تغيير اللون حسب الحاجة
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // مسافة صغيرة بين "ر.س" و TextField
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign
                                    .left, // محاذاة النص داخل الحقل إلى اليسار
                                decoration: const InputDecoration(
                                  border:
                                      InputBorder.none, // إزالة الحدود الداخلية
                                  hintText: '', // نص تلميحي
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
                    // نص "بناء على العقارات المشابهة"
                    Container(
                      margin: const EdgeInsets.only(
                          top: 7), // تعديل المسافة للأعلى أو الأسفل
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'بناء على العقارات المشابهة\n', // إضافة سطر جديد
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            TextSpan(
                              text: ':قيمة عقارك سوف تكون في حدود',
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
                ),

                const SizedBox(height: 30), // مسافة بين العناصر

// تحريك زر الإضافة للأسفل
                const SizedBox(height: 20), // زيادة المسافة قبل الزر

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // إضافة وظيفة إضافة العقار
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF180A44),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Text('إضافة العقار',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

//سنة البناء
  Widget _buildYearBuiltField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.calendar_today, color: Color(0xFF180A44)),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: dateController,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('سنة البناء',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

// المتغير لتخزين نوع العقار المحدد
  String? selectedPropertyType; // يبدأ بدون تحديد

// دالة لبناء واجهة اختيار نوع العقار
  Widget _buildPropertyType() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
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
      color: Colors.white,
      thickness: 2,
      width: 20,
    );
  }

//التقدير (هل تحتاج مساعده للتقييم )
  Widget _buildHelpBox() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF180A44),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Row(
        children: [
          Text(
            'هل تحتاج مساعدة لتقييم عقارك؟',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.lightbulb, color: Colors.yellow),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData? icon,
      {TextEditingController? controller}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, color: const Color(0xFF180A44)),
        if (icon != null) const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
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
                  const SizedBox(width: 8),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

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
            value: label == 'المنطقة'
                ? selectedRegion
                : label == 'المدينة'
                    ? selectedCity
                    : selectedNeighborhood,
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
        const SizedBox(width: 8),
        const Text('*', style: TextStyle(color: Colors.red)),
      ],
    );
  }

//عرض الشارع
  Widget _buildStreetWidthField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.streetview, color: Color(0xFF180A44)),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: streetWidthController,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('عرض الشارع (متر)',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

//ارفاق صوره
  Widget _buildImagePicker() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('    إرفاق صورة ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
              border: const OutlineInputBorder(),
              prefixIcon: IconButton(
                icon: const Icon(Icons.attach_file, color: Color(0xFF180A44)),
                onPressed: _pickImage,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (selectedImage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: (kIsWeb)
            ? Image.network(
                selectedImage!.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              )
            : Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildBoxField(BuildContext context, String label, IconData icon,
      {bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            maxLines: isLarge ? 3 : 1,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              border: const OutlineInputBorder(),
              prefixIcon: Icon(icon, color: const Color(0xFF180A44)),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        ),
      ],
    );
  }

//السعر
  Widget _buildHelpAndPriceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHelpBox(),
        const SizedBox(width: 8),
        Expanded(
          child: _buildInputField(context, 'السعر', null,
              controller: priceController), // إزالة الأيقونة
        ),
      ],
    );
  }
}
