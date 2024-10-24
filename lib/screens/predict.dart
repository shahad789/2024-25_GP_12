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

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  String? selectedCity;
  String? selectedNeighborhood;

  final List<String> cities = [
    'الرياض',
    'جدة',
    'الدمام',
    'الخبر',
    'أخرى',
  ];

  final List<String> neighborhoods = ['حي 1', 'حي 2', 'حي 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        toolbarHeight: 70.0,
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 8),
            const Expanded(
              child: Center(
                child: Text(
                  'تقدير العقار',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.white), // السهم لليمين
              onPressed: () {
                // الانتقال إلى الصفحة الرئيسية (home_screen.dart)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomeScreen()), // العودة إلى الصفحة الرئيسية
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
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
                _buildHelpBox(),
                const SizedBox(height: 30),
                _buildGrayBox(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpBox() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF180A44),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '  تقدير عقارك',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.lightbulb, color: Colors.yellow),
        ],
      ),
    );
  }

  Widget _buildGrayBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const SizedBox.shrink(),
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
