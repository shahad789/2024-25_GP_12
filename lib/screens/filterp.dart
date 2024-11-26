import 'package:flutter/material.dart';
import 'package:daar/widgets/select_category.dart';
import 'package:daar/widgets/roomsSelection.dart';
import 'package:daar/screens/home_screen.dart';
import '../service/api_service.dart';

class FilterPage extends StatefulWidget {
  final Map<String, dynamic> selectedFilters;

  const FilterPage({Key? key, required this.selectedFilters}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Define controllers for text fields
  String? selectedCategory; // الفئة التي تم اختيارها
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minSizeController = TextEditingController();
  final TextEditingController maxSizeController = TextEditingController();

  // Tracking what was selected
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
  List<String> neighborhoods = []; // سيتم تحميل الأحياء بناءً على المدينة

  // دالة لتحميل الأحياء من الـ API
  Future<void> loadDistricts() async {
    if (selectedCity == null) return;

    try {
      List<String> districts = await ApiService.getDistricts(selectedCity!);
      setState(() {
        neighborhoods = districts;
        // إذا كان الحي المختار موجود في الأحياء الجديدة، قم بتعيينه.
        if (districts.contains(selectedDistrict)) {
          selectedDistrict = selectedDistrict;
        } else {
          selectedDistrict = null; // إعادة تعيين الحي إذا لم يكن موجودًا
        }
      });
    } catch (e) {
      print("فشل تحميل الأحياء: $e");
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
    loadDistricts(); // تأكد من استدعاء loadDistricts هنا
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                            errorText: isMinPriceError ? '' : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: minPriceController.text.isNotEmpty
                                    ? const Color.fromARGB(
                                        255, 0, 0, 0) // غامق عند التركيز
                                    : Colors.black, // لون الحافة العادية
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black, // لون الحافة العادية
                              ),
                            ),
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
                            errorText: isMaxPriceError ? ' ' : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: maxPriceController.text.isNotEmpty
                                    ? const Color.fromARGB(
                                        255, 0, 0, 0) // غامق عند التركيز
                                    : Colors.black, // لون الحافة العادية
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black, // لون الحافة العادية
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _validatePriceRange();
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isMinPriceError || isMaxPriceError)
                    Transform.translate(
                      offset: Offset(0, -5),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          'يجب أن يكون الحد الأقصى أكبر من الحد الأدني',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 183, 28, 17),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
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
                'عدد دورات المياة',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                            errorText: isMinSizeError ? '' : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: minSizeController.text.isNotEmpty
                                    ? const Color.fromARGB(
                                        255, 0, 0, 0) // غامق عند التركيز
                                    : Colors.black, // لون الحافة العادية
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black, // لون الحافة العادية
                              ),
                            ),
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
                            errorText: isMaxSizeError ? ' ' : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: maxSizeController.text.isNotEmpty
                                    ? const Color.fromARGB(
                                        255, 0, 0, 0) // غامق عند التركيز
                                    : Colors.black, // لون الحافة العادية
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black, // لون الحافة العادية
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _validateSizeRange();
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isMinSizeError || isMaxSizeError)
                    Transform.translate(
                      offset: Offset(0, -5),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          'يجب أن يكون الحد الأقصى أكبر من الحد الأدني',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 183, 28, 17),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
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
// City Dropdown
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
                    selectedDistrict = null; // Reset district
                    neighborhoods = []; // Clear neighborhoods
                  });
                  loadDistricts(); // Load neighborhoods for the selected city
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'الأحياء',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
// District Dropdown
              DropdownButton<String>(
                isExpanded: true,
                value: (selectedDistrict != null &&
                        neighborhoods.contains(selectedDistrict))
                    ? selectedDistrict
                    : null,
                hint: const Text('اختر الحي'),
                items: neighborhoods
                    .toSet() // Ensure there are no duplicates in neighborhoods
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
              ),
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
                      child: const Text(
                        'تصفية',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // لون النص باللون الأبيض
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF180A44), // لون الزر
                        minimumSize: const Size(
                            150, 45), // تغيير الحجم إلى عرض 200 وارتفاع 50
                      )),
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
                      child: const Text(
                        'مسح',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(
                              255, 35, 12, 87), // لون النص باللون الأبيض
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // لون الزر
                        minimumSize: const Size(
                            150, 45), // تغيير الحجم إلى عرض 200 وارتفاع 50
                      )),
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
}
