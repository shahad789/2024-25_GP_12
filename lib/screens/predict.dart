// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../service/api_service.dart';
import 'home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const PredictPage());
}

class PredictPage extends StatelessWidget {
  const PredictPage({super.key});

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
  String? selectedPropertyType;
  bool showEstimation = false;
  double? predictedPrice;

  final List<String> cities = ['الرياض', 'جدة', 'الدمام', 'الخبر'];
  List<String> neighborhoods = [];
  final List<String> propertyTypes = ['شقة', 'فيلا', 'دور'];

  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();

  Future<void> loadDistricts() async {
    if (selectedCity == null) return;

    try {
      neighborhoods = await ApiService.getDistricts(selectedCity!);
      neighborhoods = neighborhoods.toSet().toList(); // Remove duplicate values
      setState(() {
        // Reset selectedNeighborhood if it is not in the updated list
        if (!neighborhoods.contains(selectedNeighborhood)) {
          selectedNeighborhood = null;
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل الأحياء. حاول مرة أخرى.')),
      );
    }
  }

  Future<void> predictPrice() async {
    final area = double.tryParse(_areaController.text);
    final rooms = int.tryParse(_roomsController.text);
    final bathrooms = int.tryParse(_bathroomsController.text);

    if (selectedCity == null ||
        selectedNeighborhood == null ||
        selectedPropertyType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول ببيانات صحيحة.')),
      );
      return;
    }
    if (area == null || rooms == null || bathrooms == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال قيم صحيحة.')),
      );
      return;
    }

    try {
      predictedPrice = await ApiService.predictPrice(
        city: selectedCity!,
        district: selectedNeighborhood!,
        propertyType: selectedPropertyType!,
        area: area,
        rooms: rooms,
        bathrooms: bathrooms,
      );

      setState(() {
        showEstimation = true;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('فشل في تقدير السعر. حاول مرة أخرى لاحقًا.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        title:
            const Text('تقدير العقار', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF180A44),
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildPropertyType(),
                const SizedBox(height: 30),
                _buildInputField(
                    'مساحة الأرض (متر مربع)', Icons.landscape, _areaController),
                const SizedBox(height: 30),
                _buildInputField('عدد الغرف', Icons.bed, _roomsController),
                const SizedBox(height: 30),
                _buildInputField(
                    'عدد دورات المياه', Icons.bathtub, _bathroomsController),
                const SizedBox(height: 30),
                _buildDropdownField('المدينة', cities, (value) {
                  setState(() {
                    selectedCity = value;
                    loadDistricts();
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
                if (showEstimation) _buildCurrencyInput(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyType() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF180A44), Color(0xFF180A44)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPropertyTypeButton('شقة', Icons.apartment_rounded),
          _buildPropertyTypeButton('دور', Icons.stairs_rounded),
          _buildPropertyTypeButton('فيلا', Icons.villa_rounded),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeButton(String type, IconData icon) {
    bool isSelected = selectedPropertyType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropertyType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        label: Align(
          alignment: Alignment.centerRight, // Align the label to the right
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF180A44)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    // Ensure the selected value is part of the items list
    String? dropdownValue =
        (items.contains(selectedNeighborhood)) ? selectedNeighborhood : null;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      isExpanded: true,
      hint: Align(
        alignment: Alignment.centerRight,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right, // Use TextAlign.right instead
        ),
      ),
      value: label == 'المدينة' ? selectedCity : dropdownValue,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              item,
              textAlign: TextAlign.right, // Use TextAlign.right instead
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedNeighborhood = value;
        });
        onChanged(value);
      },
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF180A44)),
    );
  }

  Widget _buildHelpBox() {
    return GestureDetector(
      onTap: predictPrice,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xFF180A44),
            borderRadius: BorderRadius.circular(8)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('تقدير عقارك', style: TextStyle(color: Colors.white)),
            Icon(Icons.lightbulb, color: Colors.yellow)
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInput() {
    final formattedPrice = predictedPrice != null
        ? NumberFormat("#,##0.00", "en_US").format(predictedPrice)
        : '0.00';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Box for displaying the predicted price
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
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'ر.س',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    formattedPrice,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Text explanation of the predicted price
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
}
