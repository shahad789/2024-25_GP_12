// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  String? selectedGender;
  DateTime? selectedDate;

  final List<String> genders = ['ذكر', 'أنثى']; // "Male", "Female" in Arabic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl, // Set the entire screen to RTL
        child: Stack(
          children: [
            // Background gradient container
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff180A44),
                    Color(0xff281537),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Positioned Logo on the right side
            Positioned(
              top: 50, // Adjust position according to your layout
              right: 20, // Align the logo to the right
              child: Image.asset(
                'lib/assets/images/logow.png', // Path to your logo file
                width: 90, // Adjust logo size as needed
                height: 90,
              ),
            ),
            // Registration form container
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Welcome Text inside the white container
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                            right: 0.0,
                            bottom: 20.0,
                          ), // Set right padding to 0
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'أنشئ حسابك', // "Create your account" in Arabic
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff180A44),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign:
                                  TextAlign.right, // Align text to the right
                              maxLines: 2, // Allow up to 2 lines
                              overflow: TextOverflow
                                  .visible, // Ensure text is visible
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Full Name TextField
                        const TextField(
                          textAlign: TextAlign.right, // Align text to the right
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.check,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'الاسم الكامل', // "Full Name" in Arabic
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Email TextField
                        const TextField(
                          textAlign: TextAlign.right, // Align text to the right
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'البريد الإلكتروني', // "Email" in Arabic
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Phone Number TextField
                        const TextField(
                          textAlign: TextAlign.right, // Align text to the right
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'رقم الهاتف', // "Phone Number" in Arabic
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Gender Dropdown without border
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedGender,
                              hint: const Text(
                                'اختر الجنس', // "Select Gender" in Arabic
                                style: TextStyle(
                                  color: Color(0xff180A44),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              items: genders
                                  .map((gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text(gender),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none, // Remove the border
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color:
                                  const Color(0xff180A44), // Color of the line
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Date of Birth TextField
                        GestureDetector(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  selectedDate != null
                                      ? 'تاريخ الميلاد: ${selectedDate!.toLocal()}'
                                          .split(' ')[0]
                                      : 'تاريخ الميلاد', // "Date of Birth" in Arabic
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff180A44),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Password TextField
                        const TextField(
                          obscureText: true,
                          textAlign: TextAlign.right, // Align text to the right
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'كلمة المرور', // "Password" in Arabic
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Confirm Password TextField
                        const TextField(
                          obscureText: true,
                          textAlign: TextAlign.right, // Align text to the right
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'تأكيد كلمة المرور', // "Confirm Password" in Arabic
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Sign Up Button
                        GestureDetector(
                          onTap: () {
                            // Navigate to the home screen
                            Navigator.pushNamed(context, 'home');
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0xff180A44),
                                Color(0xff180A44),
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'إنشاء حساب', // "Sign Up" in Arabic
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign:
                                    TextAlign.center, // Center the button text
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login prompt
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "هل لديك حساب؟", // "Do you have an account?" in Arabic
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'login');
                                },
                                child: const Text(
                                  'تسجيل الدخول', // "Login" in Arabic
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff180A44),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30), // Space for bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
