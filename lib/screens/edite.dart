// ignore_for_file: file_names

import 'package:daar/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

// إعداد التطبيق وضبط واجهة المستخدم، مع تخصيص شريط الحالة وجعل الصفحة الرئيسية هي صفحة تفاصيل العقار
void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

// التطبيق الرئيسي  MaterialApp لتحديد الإعدادات العامة وصفحة البداية
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

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  String? selectedCity = 'أخرى';
  String? selectedNeighborhood = 'حي العتيبية';
  String? selectedRegion = 'مكة المكرمة';
  final TextEditingController dateController =
      TextEditingController(text: '2021');
  final TextEditingController priceController =
      TextEditingController(text: '900000');
  final TextEditingController streetWidthController =
      TextEditingController(text: '20 م');
  final TextEditingController landAreaController =
      TextEditingController(text: '500 م²');
  final TextEditingController roomsController =
      TextEditingController(text: '4');
  final TextEditingController bathroomsController =
      TextEditingController(text: '2');
  final TextEditingController livingRoomsController =
      TextEditingController(text: '1');
  File? selectedImage;

  final List<String> cities = ['أخرى', 'جدة', 'الدمام', 'الخبر'];
  final List<String> neighborhoods = ['حي العتيبية', 'حي 2', 'حي 3'];
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
  final List<String> selectedDirections = ['شمال', 'شرق'];

  String selectedPropertyType = 'شقة'; // تحديد الشقة كنوع العقار المختار
  bool isForSale = true; // القيمة الافتراضية
  bool showValueMessage = false; // لتحديد ما إذا كان النص المخفي يجب أن يظهر

  @override
  void dispose() {
    dateController.dispose();
    priceController.dispose();
    streetWidthController.dispose();
    landAreaController.dispose();
    roomsController.dispose();
    bathroomsController.dispose();
    livingRoomsController.dispose();
    super.dispose();
  }

  // الواجهة تحتوي على الاتجاهات شرق- غرب- جنوب-شمال
  Widget _buildDirectionsDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 0.4),
          child: Text(
            'الواجهه',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.right,
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
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

// تعرض هذه الدالة صورة معاينة من مجلد الـ assets مع حواف دائرية وتنسيق مناسب، وتعرض أيقونة خطأ في حالة عدم تمكنها من تحميل الصورة.
  Widget _buildImagePreview() {
    String imagePath = 'assets/images/x.jpg';

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 176,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        toolbarHeight: 70.0,
        title: const Text(
          'تعديل العقار',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
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
                _buildPropertyType(),
                const SizedBox(height: 20),
                _buildInputField(
                    context, 'مساحة الأرض (متر مربع)', Icons.landscape,
                    controller: landAreaController),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد الغرف', Icons.bed,
                    controller: roomsController),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد دورات المياة', Icons.bathtub,
                    controller: bathroomsController),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد غرف الجلوس', Icons.event_seat,
                    controller: livingRoomsController),
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
                _buildAvailabilityOptions(), // إضافة خيارات التوافر
                const SizedBox(height: 30),
                _buildImagePreview(),
                const SizedBox(height: 30),
                _buildBoxField(context, 'تفاصيل', Icons.comment, isLarge: true),
                const SizedBox(height: 30),
                _buildHelpAndPriceRow(context),
                const SizedBox(height: 30),

                // عرض النص المخفي عند الضغط
                if (showValueMessage) ...[
                  Row(
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
                  ),
                  const SizedBox(height: 20),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // إضافة وظيفة اعلان العقار
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
                        child: const Text('إعلان العقار',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(
                        height:
                            85), // المسافة بعد الزر، يمكنك تعديلها حسب الحاجة
                  ],
                ),
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
          alignment: Alignment.topLeft, // تغيير المحاذاة إلى اليسار
          child: Padding(
            padding: EdgeInsets.only(left: 20.0), // تعديل الحشوة إلى اليسار
            child: Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 13),
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
              _buildPropertyTypeButton('شقة', Icons.apartment_rounded),
              _buildVerticalDivider(),
              _buildPropertyTypeButton('دور', Icons.stairs_rounded),
              _buildVerticalDivider(),
              _buildPropertyTypeButton('فيلا', Icons.villa_rounded)
            ],
          ),
        ),
      ],
    );
  }

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

//سنة البناء
  Widget _buildYearBuiltField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.calendar_today, color: Color(0xFF180A44)),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              TextField(
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
                    ],
                  ),
                ),
              ),
              const Positioned(
                right: 60, // تحديد الموقع الأيمن
                top: 0, // تحديد الموقع العلوي
                child: Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red, // لون النجمة
                    fontSize: 10, // حجم الخط
                    fontWeight: FontWeight.bold, // سمك الخط
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showValueMessage =
              !showValueMessage; // تغيير حالة ظهور النص عند الضغط
        });
      },
      child: Column(
        // استخدام Column لإضافة مساحة فوق الـ Container
        children: [
          const SizedBox(height: 10), // المسافة التي تريد إضافتها
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF180A44),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Row(
              children: [
                Text(
                  'هل تحتاج مساعدة لتقييم عقارك؟',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.lightbulb, color: Colors.yellow),
              ],
            ),
          ),
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
                  const Text('*', style: TextStyle(color: Colors.red)),
                  Text(
                    label,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

// المنطقه والمدينه والحي
  Widget _buildDropdownField(
    String label,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // محاذاة النص إلى اليمين
          children: [
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
            const SizedBox(width: 4),
            Text(
              "اختر $label",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF180A44),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // مسافة بين النص والقائمة المنسدلة
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            DropdownButton<String>(
              isExpanded: true,
              hint: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "", // النص فارغ الآن
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
          ],
        ),
        const SizedBox(height: 5),
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
                mainAxisAlignment:
                    MainAxisAlignment.end, // الإبقاء على تنسيق النص في اليمين
                children: [
                  Text(
                    'عرض الشارع (متر)',
                    style: TextStyle(
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
              labelText: label, // استخدام labelText بدلاً من label
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // تحديد لون الحدود
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.black), // لون الحدود عند التمكين
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        Color.fromARGB(255, 0, 0, 0)), // لون الحدود عند التركيز
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF180A44)),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
            controller: TextEditingController(
              text:
                  '.فيلا راقية في حي الريان مساحتها 500 متر مربع تحتوي على 4 غرف وحمامين وغرفة جلوس',
            ),
          ),
        ),
      ],
    );
  }

// دالة لبناء صف المساعدة والسعر
  Widget _buildHelpAndPriceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHelpBox(), // زر المساعدة
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            children: [
              // حقل إدخال السعر
              _buildPriceFieldWithStar(
                context,
                'السعر',
                null,
                controller: priceController,
              ),
              // النجمة الحمراء فوق حقل السعر
              const Positioned(
                left: 5,
                top: 0,
                child: Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// دالة لبناء حقل إدخال السعر مع النجمة
  Widget _buildPriceFieldWithStar(
    BuildContext context,
    String label,
    IconData? icon, {
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right, // محاذاة النص إلى اليمين
      textDirection: TextDirection.rtl, // اتجاه النص من اليمين إلى اليسار
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixText: ' ر.س ', // إضافة النص "ر.س" على اليسار
        prefixStyle:
            const TextStyle(fontSize: 12, color: Colors.grey), // تنسيق النص
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildAvailabilityOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isForSale,
              onChanged: (value) {
                setState(() {
                  isForSale = value!;
                });
              },
            ),
            const Text('متاح للبيع'), // خيار "متاح للبيع"
          ],
        ),
        Row(
          children: [
            Radio<bool>(
              value: false,
              groupValue: isForSale,
              onChanged: (value) {
                setState(() {
                  isForSale = value!;
                });
              },
            ),
            const Text('غير متاح للبيع'), // خيار "غير متاح للبيع"
          ],
        ),
      ],
    );
  }
}
