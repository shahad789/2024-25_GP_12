// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daar/widgets/select_category.dart';
import 'package:daar/widgets/roomsSelection.dart';
import 'package:daar/widgets/citydrop.dart';
import 'package:daar/widgets/districtdrop.dart';
import 'package:daar/screens/home_screen.dart';
import '../service/api_service.dart';

class FilterPage extends StatefulWidget {
  final Map<String, dynamic> selectedFilters;

  const FilterPage({Key? key, required this.selectedFilters}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedCategory; // الفئة التي تم اختيارها
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minSizeController = TextEditingController();
  final TextEditingController maxSizeController = TextEditingController();

  late int? selectedRoom;
  int? selectedBath;
  int? selectedLivin;
  String? selectedCity;
  String? selectedDistrict;
  double? minPrice;
  double? maxPrice;
  double? minSize;
  double? maxSize;

  List<String> cities = ['الرياض', 'جدة', 'الدمام', 'الخبر'];
  List<String> neighborhoods = [];

  Future<void> loadDistricts() async {
    if (selectedCity == null) return;

    try {
      List<String> districts = await ApiService.getDistricts(selectedCity!);
      setState(() {
        neighborhoods = districts;
      });
    } catch (e) {
      if (kDebugMode) {
        print("فشل تحميل الأحياء: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final filters = widget.selectedFilters;
    selectedCategory = filters['selectedCategory'];
    minPriceController.text = filters['minPrice']?.toString() ?? '';
    maxPriceController.text = filters['maxPrice']?.toString() ?? '';
    minSizeController.text = filters['minSize']?.toString() ?? '';
    maxSizeController.text = filters['maxSize']?.toString() ?? '';
    selectedRoom = filters['selectedRoom'];
    selectedBath = filters['selectedBath'];
    selectedLivin = filters['selectedLiving'];
    selectedCity = filters['selectedCity'];
    selectedDistrict = filters['selectedDistrict'];
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
          '  تصفيه',
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
      backgroundColor: const Color(0xFF180A44),
      body: SingleChildScrollView(
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 20.0),
              SelectCategory(
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                selectedCategory: selectedCategory ?? '',
              ),
              const SizedBox(height: 20.0),
              const Text(
                'نطاق السعر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الحد الأدنى (ر.س)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الحد الأقصى (ر.س)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              const Text(
                'عدد الغرف',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              roomsSelection(
                selectedRoom,
                (value) => setState(() => selectedRoom = value),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'عدد الحمامات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              roomsSelection(
                selectedBath,
                (value) => setState(() => selectedBath = value),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'عدد غرف المعيشة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              roomsSelection(
                selectedLivin,
                (value) => setState(() => selectedLivin = value),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'حجم العقار (متر مربع)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: minSizeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الحد الأدنى (م²)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxSizeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الحد الأقصى (م²)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'المدن',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedCity,
                hint: const Text('اختر المدينة'),
                items: cities
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    selectedDistrict = null;
                  });
                  loadDistricts();
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'الأحياء',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (neighborhoods.isNotEmpty)
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedDistrict,
                  hint: const Text('اختر الحي'),
                  items: neighborhoods
                      .map((district) => DropdownMenuItem(
                            value: district,
                            child: Text(district),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  },
                )
              else
                const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final filters = {
                        'minPrice': double.tryParse(minPriceController.text),
                        'maxPrice': double.tryParse(maxPriceController.text),
                        'minSize': double.tryParse(minSizeController.text),
                        'maxSize': double.tryParse(maxSizeController.text),
                        'selectedCategory': selectedCategory,
                        'selectedCity': selectedCity,
                        'selectedDistrict': selectedDistrict,
                        'selectedRoom': selectedRoom,
                        'selectedBath': selectedBath,
                        'selectedLiving': selectedLivin,
                      };
                      Navigator.pop(context, filters);
                    },
                    child: const Text('تصفية'),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // إعادة القيم إلى الأصلية
                        minPriceController.clear();
                        maxPriceController.clear();
                        minSizeController.clear();
                        maxSizeController.clear();
                        selectedRoom = null;
                        selectedBath = null;
                        selectedLivin = null;
                        selectedCity = null;
                        selectedDistrict = null;
                      });
                      // العودة إلى الصفحة الرئيسية مع إظهار المحتوى
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text('مسح'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    minSizeController.dispose();
    maxSizeController.dispose();
    super.dispose();
  }
}
