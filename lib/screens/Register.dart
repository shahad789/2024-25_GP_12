import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:daar/screens/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:daar/usprovider/UserProvider.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  String? selectedGender;
  DateTime? selectedDate;

  final List<String> genders = ['ذكر', 'أنثى']; // "Male", "Female" in Arabic
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final DOBController = TextEditingController();
  final genderController = TextEditingController();
  final auth = Authentication();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _emailError = '';
  String _passwordError = '';
  String? phoneError; // Added phone error variable

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    DOBController.dispose();
    genderController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(email);
  }

  bool _validatePassword(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasMinLength = password.length >= 8;
    return hasUppercase && hasLowercase && hasDigits && hasMinLength;
  }

  bool _validatePhone(String phone) {
    String pattern =
        r'^05\d{8}$'; // Ensures phone starts with 05 and is 10 digits
    return RegExp(pattern).hasMatch(phone);
  }

  void _onPhoneChanged(String phone) {
    setState(() {
      phoneError = _validatePhone(phone)
          ? null
          : 'يجب أن يبدأ رقم الهاتف بـ05 ويكون مكوناً من 10 أرقام';
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
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
            Positioned(
              top: 50,
              right: 20,
              child: Image.asset(
                'lib/assets/images/logow.png', // Path to your logo file
                width: 90,
                height: 90,
              ),
            ),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'أنشئ حسابك',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff180A44),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Full Name TextField
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'الاسم الكامل',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        TextField(
                          controller: fullNameController,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Email Label
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'البريد الإلكتروني',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        TextField(
                          controller: emailController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email, color: Colors.grey),
                            errorText: _emailError.isNotEmpty
                                ? 'البريد الإلكتروني غير صحيح, مثال: name@example.com'
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _emailError = _validateEmail(value)
                                  ? ''
                                  : 'البريد الإلكتروني غير صحيح';
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Phone Number Label
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'رقم الهاتف',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        TextField(
                          controller: phoneController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            errorText: phoneError,
                          ),
                          onChanged: _onPhoneChanged,
                        ),

                        const SizedBox(height: 15),

                        // Date of Birth Label
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'تاريخ الميلاد',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
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
                                DOBController.text =
                                    '${selectedDate!.toLocal()}'.split(' ')[0];
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: DOBController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Gender Label
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'الجنس',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          items: genders
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                              genderController.text =
                                  value ?? ''; // Update the controller
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Password Label
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'كلمة المرور',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            errorText: _passwordError.isNotEmpty
                                ? 'يجب أن تكون كلمة المرور 8 أحرف على الأقل\n وتحتوي على حرف كبير وحرف صغير ورقم'
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _passwordError = _validatePassword(value)
                                  ? ''
                                  : 'يجب أن تكون كلمة المرور 8 أحرف على الأقل\n وتحتوي على حرف كبير وحرف صغير ورقم';
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Confirm Password Label
                        const Padding(
                          padding: EdgeInsets.only(left: 250.0),
                          child: Row(
                            children: [
                              Text(
                                'تأكيد كلمة المرور',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Sign Up Button
                        GestureDetector(
                          onTap: signup,
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
                                'إنشاء حساب',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
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
                                "هل لديك حساب؟",
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
                                  'تسجيل الدخول',
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

  goToHome(BuildContext context) => Navigator.pushNamed(context, 'home');

  signup() async {
    // Check if all fields are filled
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        selectedDate == null ||
        selectedGender == null) {
      _showSnackBar(
          context, 'يرجى ملء جميع الحقول'); // "Please fill all fields"
      return;
    }

    // Validate email and password
    if (!_validateEmail(emailController.text)) {
      _showSnackBar(context, 'البريد الإلكتروني غير صحيح');
      return;
    }
    if (!_validatePassword(passwordController.text)) {
      _showSnackBar(context,
          'يجب أن تكون كلمة المرور 8 أحرف على الأقل\n وتحتوي على حرف كبير وحرف صغير ورقم');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar(context, 'كلمتا المرور غير متطابقتين');
      return;
    }

    // Validate phone number
    if (!_validatePhone(phoneController.text)) {
      _showSnackBar(context, 'رقم الهاتف غير صحيح');
      return;
    }

    try {
      // Attempt to create the user
      final user = await auth.creatUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        final userEmail = user.email;

        // Add user details to Firestore
        final userDoc =
            await FirebaseFirestore.instance.collection("user").add({
          "Name": fullNameController.text.trim(),
          "Email": userEmail,
          "Phone": phoneController.text.trim(),
          "Gender": selectedGender,
          "DateOfBirth": selectedDate.toString(),
        });

        // Save user data to UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(
          userDoc.id, // Document ID from Firestore
          fullNameController.text.trim(), // User's full name
          userEmail!, // User's email
        );

        // Navigate to the home screen
        goToHome(context);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase errors
      if (e.code == 'email-already-in-use') {
        _showSnackBar(context, 'البريد الإلكتروني مستخدم بالفعل.');
      } else if (e.code == 'invalid-email') {
        _showSnackBar(context, 'صيغة البريد الإلكتروني غير صحيحة.');
      } else if (e.code == 'weak-password') {
        _showSnackBar(context, 'كلمة المرور ضعيفة للغاية.');
      } else {
        _showSnackBar(context, 'فشل التسجيل. يرجى المحاولة مرة أخرى.');
      }
    } catch (e) {
      // Handle unexpected errors
      _showSnackBar(context, 'حدث خطأ غير متوقع. حاول مرة أخرى.');
    }
  }
}
