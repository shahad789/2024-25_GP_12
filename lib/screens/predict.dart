// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      List<String> districts = await ApiService.getDistricts(selectedCity!);
      neighborhoods = districts.map((e) => e.trim()).toSet().toList();
      selectedNeighborhood = null;
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load districts. Please try again.')),
      );
    }
  }

  String mapPropertyTypeToEnglish(String propertyType) {
    switch (propertyType) {
      case 'شقة':
        return 'apartment';
      case 'فيلا':
        return 'villa';
      case 'دور':
        return 'floor';
      default:
        return 'apartment';
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
        const SnackBar(
            content:
                Text('يرجى إدخال قيم صحيحة للمساحة وعدد الغرف ودورات المياه.')),
      );
      return;
    }
    try {
      final englishPropertyType =
          mapPropertyTypeToEnglish(selectedPropertyType!);
      predictedPrice = await ApiService.predictPrice(
        city: selectedCity!,
        district: selectedNeighborhood!,
        propertyType: englishPropertyType,
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
            content: Text('Failed to predict price. Please try again later.')),
      );
    }
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
          '  تقدير العقار',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
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
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildPropertyTypeButtons(),
                const SizedBox(height: 60),
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
                GestureDetector(
                  onTap: predictPrice,
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
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.lightbulb, color: Colors.yellow),
                      ],
                    ),
                  ),
                ),
                if (showEstimation)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'السعر المتوقع: ${predictedPrice?.toStringAsFixed(2)} ر.س',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeButtons() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF180A44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(propertyTypes.length * 2 - 1, (index) {
          if (index.isOdd) {
            return _buildVerticalDivider();
          } else {
            final type = propertyTypes[index ~/ 2];
            bool isSelected = selectedPropertyType == type;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPropertyType = type;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 4,
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFF180A44),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForPropertyType(type),
                      color:
                          isSelected ? const Color(0xFF180A44) : Colors.white,
                      size: 24,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      type,
                      style: TextStyle(
                        color:
                            isSelected ? const Color(0xFF180A44) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const SizedBox(
      height: 55,
      child: VerticalDivider(
        color: Colors.white,
        thickness: 1.5,
        width: 20,
      ),
    );
  }

  IconData _getIconForPropertyType(String type) {
    switch (type) {
      case 'شقة':
        return Icons.apartment;
      case 'فيلا':
        return Icons.house;
      case 'دور':
        return Icons.home_work;
      default:
        return Icons.home;
    }
  }

  Widget _buildInputField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text(label),
      value: label == 'المدينة' ? selectedCity : selectedNeighborhood,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
