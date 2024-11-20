import 'package:flutter/material.dart';
import 'package:daar/widgets/select_category.dart';
import 'package:daar/widgets/roomsSelection.dart';
import 'package:daar/screens/home_screen.dart';
import '../service/api_service.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Define controllers for text fields
  String? selectedCategory;
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minSizeController = TextEditingController();
  final TextEditingController maxSizeController = TextEditingController();

  // Tracking selected items
  int? selectedRoom;
  int? selectedBath;
  int? selectedLivin;
  String? selectedCity;
  String? selectedDistrict;

  bool isMinPriceError = false;
  bool isMaxPriceError = false;
  bool isMinSizeError = false;
  bool isMaxSizeError = false;

  List<String> cities = ['الرياض', 'جدة', 'الدمام', 'الخبر'];
  List<String> neighborhoods = [];

  // Load districts from API
  Future<void> loadDistricts() async {
    if (selectedCity == null) return;

    setState(() {
      neighborhoods = []; // Reset neighborhoods before loading
    });

    try {
      List<String> districts = await ApiService.getDistricts(selectedCity!);
      setState(() {
        neighborhoods = districts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل الأحياء')),
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
          'تصفية',
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
              SelectCategory(onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              }),
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
                      decoration: InputDecoration(
                        labelText: 'الحد الأدنى (ر.س)',
                        border: const OutlineInputBorder(),
                        errorText: isMinPriceError
                            ? 'الحد الأدنى يجب أن يكون أقل'
                            : null,
                      ),
                      onChanged: (value) {
                        _validatePriceRange();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأقصى (ر.س)',
                        border: const OutlineInputBorder(),
                        errorText: isMaxPriceError
                            ? 'الحد الأقصى يجب أن يكون أكبر'
                            : null,
                      ),
                      onChanged: (value) {
                        _validatePriceRange();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              _buildRoomSelector('عدد الغرف', selectedRoom,
                  (value) => setState(() => selectedRoom = value)),
              _buildRoomSelector('عدد دورات المياة', selectedBath,
                  (value) => setState(() => selectedBath = value)),
              _buildRoomSelector('عدد غرف المعيشة', selectedLivin,
                  (value) => setState(() => selectedLivin = value)),
              const SizedBox(height: 30.0),
              const Text(
                'مساحة العقار (م²)',
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
                      decoration: InputDecoration(
                        labelText: 'الحد الأدنى (م²)',
                        border: const OutlineInputBorder(),
                        errorText: isMinSizeError
                            ? 'الحد الأدنى يجب أن يكون أقل'
                            : null,
                      ),
                      onChanged: (value) {
                        _validateSizeRange();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxSizeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأقصى (م²)',
                        border: const OutlineInputBorder(),
                        errorText: isMaxSizeError
                            ? 'الحد الأقصى يجب أن يكون أكبر'
                            : null,
                      ),
                      onChanged: (value) {
                        _validateSizeRange();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildDropdown('المدن', cities, selectedCity, (value) {
                setState(() {
                  selectedCity = value;
                  selectedDistrict = null;
                  neighborhoods = [];
                });
                loadDistricts();
              }),
              _buildDropdown(
                'الأحياء',
                neighborhoods,
                selectedDistrict,
                (value) => setState(() => selectedDistrict = value),
              ),
              const SizedBox(height: 20.0),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomSelector(
      String label, int? value, ValueChanged<int?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        roomsSelection(value, onChanged),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text('اختر $label'),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _validatePriceRange();
              _validateSizeRange();

              if (isMinPriceError ||
                  isMaxPriceError ||
                  isMinSizeError ||
                  isMaxSizeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى التحقق من القيم المدخلة')),
                );
                return;
              }

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
            child: const Text(
              'تصفية',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, // لون النص باللون الأبيض
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF180A44), // لون الزر
              minimumSize:
                  const Size(150, 45), // تغيير الحجم إلى عرض 200 وارتفاع 50
            )),
        const SizedBox(width: 20.0),
        ElevatedButton(
            onPressed: () {
              setState(() {
                minPriceController.clear();
                maxPriceController.clear();
                minSizeController.clear();
                maxSizeController.clear();
                selectedRoom = null;
                selectedBath = null;
                selectedLivin = null;
                selectedCity = null;
                selectedDistrict = null;
                isMinPriceError = false;
                isMaxPriceError = false;
                isMinSizeError = false;
                isMaxSizeError = false;
              });
            },
            child: const Text(
              'مسح',
              style: TextStyle(
                fontSize: 18,
                color: const Color(0xFF180A44), // لون النص باللون الأبيض
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 255, 255, 255), // لون الزر
              minimumSize:
                  const Size(150, 45), // تغيير الحجم إلى عرض 200 وارتفاع 50
            )),
      ],
    );
  }

  void _validatePriceRange() {
    setState(() {
      isMinPriceError = double.tryParse(minPriceController.text) != null &&
          double.tryParse(maxPriceController.text) != null &&
          double.tryParse(minPriceController.text)! >=
              double.tryParse(maxPriceController.text)!;

      isMaxPriceError = double.tryParse(minPriceController.text) != null &&
          double.tryParse(maxPriceController.text) != null &&
          double.tryParse(minPriceController.text)! >=
              double.tryParse(maxPriceController.text)!;
    });
  }

  void _validateSizeRange() {
    setState(() {
      isMinSizeError = double.tryParse(minSizeController.text) != null &&
          double.tryParse(maxSizeController.text) != null &&
          double.tryParse(minSizeController.text)! >=
              double.tryParse(maxSizeController.text)!;

      isMaxSizeError = double.tryParse(minSizeController.text) != null &&
          double.tryParse(maxSizeController.text) != null &&
          double.tryParse(minSizeController.text)! >=
              double.tryParse(maxSizeController.text)!;
    });
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
