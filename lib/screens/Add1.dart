import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/screens/home_screen.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../service/api_service.dart';

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
  String? selectedPropertyType;
  bool showEstimation = false;
  double? predictedPrice;
  List<File> selectedImages = [];

  final List<String> cities = ['الرياض', 'جدة', 'الدمام', 'الخبر'];
  List<String> neighborhoods = [];
  final List<String> propertyTypes = ['شقة', 'فيلا', 'دور'];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController streetWidthController = TextEditingController();
  final TextEditingController locationLinkController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _livingController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  File? selectedImage;

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
                _buildInputField(context, 'مساحة الأرض (متر مربع)',
                    Icons.landscape, _areaController),
                const SizedBox(height: 30),
                _buildInputField(
                    context, 'عدد الغرف', Icons.bed, _roomsController),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد دورات المياه', Icons.bathtub,
                    _bathroomsController),
                const SizedBox(height: 30),
                _buildInputField(context, 'عدد غرف الجلوس', Icons.event_seat,
                    _livingController),
                const SizedBox(height: 30),
                _buildStreetWidthField(),
                const SizedBox(height: 30),
                _buildYearPickerField(context, 'سنة البناء',
                    Icons.calendar_today, dateController),
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
                _buildDirectionsDropdown(),
                const SizedBox(height: 30),
                _buildImagePicker(),
                const SizedBox(height: 10),
                _buildImagePreview(),
                const SizedBox(height: 30),
                _buildBoxField(
                  context,
                  'تفاصيل',
                  Icons.comment,
                  detailsController,
                  isLarge: true,
                ),
                const SizedBox(height: 30),
                _buildHelpAndPriceRow(context),
                const SizedBox(height: 30),
                if (showEstimation) _buildCurrencyInput(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addProperty,
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

  //////////////////////////////
  Future<void> _addProperty() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userDocId = userProvider.userDocId;

    // Validate required fields
    if (selectedCity == null ||
        selectedNeighborhood == null ||
        selectedPropertyType == null ||
        _areaController.text.isEmpty ||
        _roomsController.text.isEmpty ||
        _bathroomsController.text.isEmpty ||
        _livingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة.')),
      );
      return;
    }

    // Parse numeric inputs
    final area = int.tryParse(_areaController.text);
    final rooms = int.tryParse(_roomsController.text);
    final bathrooms = int.tryParse(_bathroomsController.text);
    final livingRooms = int.tryParse(_livingController.text);
    final streetWidth = int.tryParse(streetWidthController.text);

    if (area == null ||
        rooms == null ||
        bathrooms == null ||
        livingRooms == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال قيم صحيحة.')),
      );
      return;
    }

    // Default values for optional fields
    final direction = selectedDirections.isNotEmpty
        ? selectedDirections.join(', ')
        : 'غير معروف'; // "Not known" in Arabic
    final details = detailsController.text.isNotEmpty
        ? detailsController.text
        : 'لا يوجد تفاصيل'; // "No details" in Arabic
    final currentDate = Timestamp.now(); // Firestore-compatible timestamp

    // Upload Multiple Images
    List<String> images = [];
    try {
      for (File image in selectedImages) {
        final fileName = path.basename(image.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('property_images/$userDocId/$fileName');
        await ref.putFile(image);

        // Get the download URL
        final imageUrl = await ref.getDownloadURL();
        images.add(imageUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل الصور.')),
      );
      return;
    }

    // Add default image if no images are selected
    if (images.isEmpty) {
      images.add(
        'https://firebasestorage.googleapis.com/v0/b/daar-4ee4f.appspot.com/o/noimage.png?alt=media',
      );
    }

    // Construct property data
    final propertyData = {
      'city': selectedCity,
      'District': selectedNeighborhood,
      'category': selectedPropertyType,
      'size': area,
      'numOfBed': rooms,
      'numOfBath': bathrooms,
      'numOfLivin': livingRooms,
      'streetWidth': streetWidth ?? 'غير معروف',
      'Direction': direction,
      'details': details,
      'price': int.tryParse(priceController.text) ?? 0,
      'year':
          dateController.text.isNotEmpty ? dateController.text : 'غير معروف',
      'images': images, // Array of image URLs
      'Date_list': currentDate,
      'user': FirebaseFirestore.instance
          .doc('/user/$userDocId'), // Firestore reference
      'status': 'متوفر', // "Available" in Arabic
      'view': 0, // Default view count
    };

    try {
      // Add property to Firestore
      await FirebaseFirestore.instance.collection('Property').add(propertyData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة العقار بنجاح.')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إضافة العقار. حاول مرة أخرى.')),
      );
    }
  }

  ////interface looks

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
              // _buildVerticalDivider(),
              _buildPropertyTypeButton('دور', Icons.stairs_rounded),
              // _buildVerticalDivider(),
              _buildPropertyTypeButton('فيلا', Icons.villa_rounded)
            ],
          ),
        ),
      ],
    );
  }

//PROPERTY TYPES DESIGN
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

//text field with customizable label, icon, and size, used for entering text in a form.
  Widget _buildBoxField(BuildContext context, String label, IconData icon,
      TextEditingController? controller,
      {bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            maxLines: isLarge ? 3 : 1,
            textAlign: TextAlign.right,
            // textDirection: TextDirection.rtl,
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
            controller: controller,
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
      onTap: predictPrice,
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
      TextEditingController? controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        label: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF180A44)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      keyboardType: TextInputType.number,
    );
  }

// Function to build a dropdown menu with a label and a list of items, updating the state when a value is selected.
  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    // Ensure the selected value is part of the items list
    String? dropdownValue =
        (items.contains(selectedNeighborhood)) ? selectedNeighborhood : null;

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
        DropdownButtonFormField<String>(
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
              textAlign: TextAlign.right,
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
                  textAlign: TextAlign.right,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (label == 'المدينة') {
                selectedCity = value;
              } else {
                selectedNeighborhood = value;
              }
            });
            onChanged(value);
          },
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF180A44)),
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
            // textDirection: TextDirection.rtl,
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
            keyboardType: TextInputType.number,
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

// Allow multiple image selection
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        // Convert selected images to File objects and add them to the list
        selectedImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.only(left: 255.0), // Keep text aligned to the right
          child: Text(
            'إرفاق الصور',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          // Center the button horizontally
          child: ElevatedButton.icon(
            onPressed: _pickImages,
            icon: const Icon(Icons.add_a_photo, color: Colors.white),
            label: const Text(
              'اختر الصور',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF180A44),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

// Display Selected Images
  Widget _buildImagePreview() {
    // Check if there are no selected images
    if (selectedImages.isEmpty) {
      return const Text(
        'لم يتم تحديد صور بعد.',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      );
    }

    // Show selected images
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: selectedImages.map((image) {
        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: -10,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () {
                  setState(() {
                    selectedImages.remove(image);
                  });
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  //FOR PRICEEE
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

  //year
  Widget _buildYearPickerField(BuildContext context, String label,
      IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      readOnly: true, // Prevent manual input
      onTap: () => _selectYear(context, controller), // Open year picker
      decoration: InputDecoration(
        label: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF180A44)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }

  void _selectYear(BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("اختر سنة البناء",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: YearPicker(
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate: DateTime.now(),
                  selectedDate: DateTime.now(),
                  onChanged: (DateTime picked) {
                    controller.text =
                        picked.year.toString(); // Save only the year
                    Navigator.pop(context); // Close the modal
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
