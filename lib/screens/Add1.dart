import 'dart:io';

import 'package:daar/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// Main application setup with MaterialApp and PropertyDetailsPage as the initial screen
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

//Selecting city, district, region, and directions
class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  String? selectedCity;
  String? selectedNeighborhood;
  String? selectedRegion;
  String? selectedPropertyType;
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

  //the directions include: East, West, South, North.
  final List<String> directions = ['شمال', 'جنوب', 'شرق', 'غرب'];
  final List<String> selectedDirections = [];
  Widget _buildDirectionsDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 288.0),
          child: Row(
            children: [
              Text(
                'الواجهة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
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

  //Variable to control the display of property estimation
  bool showEstimation = false;

  //Property details
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
                _buildInputField(context, 'سنة  البناء', Icons.calendar_today),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          //add Property button
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

// property type selection
  Widget _buildPropertyType() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 12),
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
    bool isSelected = selectedPropertyType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropertyType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const VerticalDivider(
      color: Colors.white,
      thickness: 2,
      width: 20,
    );
  }

// Function to display estimation details if the condition is enabled
  Widget _buildEstimationDetails() {
    if (!showEstimation) {
      return const SizedBox.shrink();
    }

//Price input field with estimated property value range
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
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
                        onSubmitted: (value) {},
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
      ],
    );
  }

//text field with customizable label, icon, and size, used for entering text in a form.
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
              labelText: label,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF180A44)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            ),
            controller: TextEditingController(),
          ),
        ),
      ],
    );
  }

//Help button for property evaluation, field for entering the required price, and property details.
  Widget _buildHelpAndPriceRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHelpButton(),
            Expanded(
              child: Stack(
                children: [
                  _buildPriceFieldWithStar(
                    context,
                    'السعر',
                    null,
                    controller: priceController,
                  ),
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
        ),
        _buildEstimationDetails(),
      ],
    );
  }

//Creates a price input field
  Widget _buildPriceFieldWithStar(
    BuildContext context,
    String label,
    IconData? icon, {
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: ' ر.س ',
        prefixStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

//Function to create a help button to toggle estimation state
  Widget _buildHelpButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showEstimation = !showEstimation;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF180A44),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          children: [
            Text(
              'هل تحتاج مساعدة لتقييم عقارك؟',
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
                  const Text('*',
                      style: TextStyle(color: Colors.red, fontSize: 14)),
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

// Creates a labeled dropdown list with selection handling.
  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            DropdownButton<String>(
              isExpanded: true,
              hint: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "",
                  textAlign: TextAlign.right,
                ),
              ),
              value: label == 'المنطقة'
                  ? selectedRegion
                  : label == 'المدينة'
                      ? selectedCity
                      : selectedNeighborhood,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF180A44)),
              items: items.toSet().toList().map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(item),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (label == 'المنطقة') {
                    selectedRegion = value;
                  } else if (label == 'المدينة') {
                    selectedCity = value;
                  } else if (label == 'الحي') {
                    selectedNeighborhood = value;
                  }
                });
              },
              underline: Container(
                height: 1,
                color: const Color(0xFF180A44),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Input field for street width with label and icon.
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

//This method is used to clean up and release resources used by the controllers
  @override
  void dispose() {
    dateController.dispose();
    priceController.dispose();
    streetWidthController.dispose();
    locationLinkController.dispose();
    super.dispose();
  }

//// These functions allow selecting an image from the gallery, saving its path, and displaying a preview in the UI.
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Widget _buildImagePicker() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: 'إرفاق صورة',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.attach_file, color: Color(0xFF180A44)),
                onPressed: _pickImage,
                padding: EdgeInsets.zero,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 68, horizontal: 10),
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
        child: selectedImage != null
            ? Image.file(
                selectedImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              )
            : const Center(child: Text('لا توجد صورة محددة')),
      ),
    );
  }
}
