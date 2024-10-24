// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:daar/widgets/select_category.dart';
import 'package:daar/widgets/roomsSelection.dart';
import 'package:daar/widgets/citydrop.dart';
import 'package:daar/widgets/districtdrop.dart';
import 'package:daar/screens/home_screen.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  //tracking what was selected :(
  int? selectedRoom;
  int? selectedBath;
  int? selectedlivin;
  String? selectedCity;
  String? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////start hag app bar//////////////////////////////////////
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
              // العودة إلى الصفحة الرئيسية
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ],
      ),

      ///////////////////////////////////////////////end hag app bar///////////////////////////////////////////////////////////
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
          /////body hena yebda

          padding: const EdgeInsets.all(20.0),

          child: Column(
            //COLUMN
            crossAxisAlignment: CrossAxisAlignment
                .end, // 3ashan yebda men left cuz its an arabic application
            children: [
              const SizedBox(height: 20.0),
              const SelectCategory(), // the widget i did for selecting type of category

              // start of making price filter
              const SizedBox(
                  height:
                      20.0), // masafa ben el shayeen 20 3ashan consistency l2n this is what am using
              const Text(
                'نطاق السعر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // my boxes
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأدنى (ر.س)', // Min
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأقصى (ر.س)', // Max
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              ///////////////////////////////////////////////////////////////////////the end of price
              ///////////////////////////////////////////////////////////////////////begin of number of rooms
              // Room selection
              const SizedBox(height: 30.0),
              const Text(
                'عدد الغرف',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              roomsSelection(
                selectedRoom,
                (value) => setState(() => selectedRoom = value),
              ),

              // Bathroom selection
              const SizedBox(height: 20.0),
              const Text(
                'عدد الحمامات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              roomsSelection(
                selectedBath,
                (value) => setState(() => selectedBath = value),
              ),

              // Living room selection
              const SizedBox(height: 20.0),
              const Text(
                'عدد غرف المعيشة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              roomsSelection(
                selectedlivin,
                (value) => setState(() => selectedlivin = value),
              ),
              //////////////////////////////////////////////////////////////////end of bath, living, bed
              ///////////////////////////////////////////////////////////////start of size
              const SizedBox(height: 30.0),
              const Text(
                ' حجم العقار (متر مربع)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // my boxes
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأدنى (م²)', // Min
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأقصى (م²)', // Max
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              ///////////////////////////////////////////////////////////////end of size
              ///////////////////////////////////////////////////////////////start of filter
              const SizedBox(height: 20.0),
              const Text(
                'المدن',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              cityDropdown(selectedCity, (String? value) {
                setState(() {
                  selectedCity = value; // here we keep it so we show esh 25tar
                });
              }),
/////////////////////////////////////////////////////////////end city
////////////////////////////////////////////////////////////end district
              const SizedBox(height: 20.0),
              const Text(
                'الأحياء',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              districtDropDown(selectedDistrict, (String? value) {
                setState(() {
                  selectedDistrict = value; // nafs fekra
                });
              }),

              //////////////////////////////////////////////////////////////button here
              const SizedBox(height: 20.0), // Spacing before the next section
              // Centered filter button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    /////inshallah code
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color.fromARGB(210, 189, 185, 185),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('تصفية'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////end of size
}
