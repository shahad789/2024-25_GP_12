import 'package:flutter/material.dart';
import 'package:daar/screens/authentication.dart';

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
  final auth = Authentication();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _emailError = '';
  String _passwordError = '';

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                        TextField(
                          controller: fullNameController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.check,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              'الاسم الكامل',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Email TextField with real-time validation
                        TextField(
                          controller: emailController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              'البريد الإلكتروني',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                            errorText: _emailError.isNotEmpty
                                ? 'البريد الإلكتروني غير صحيح, مثال: name@example.com' // Show the example when there's an error
                                : null,
                            helperText: null, // Remove the helper text
                            helperStyle: const TextStyle(
                                color: Colors
                                    .red), // You can keep this for styling, but since helperText is null, this won't show.
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Validate the email syntax
                              _emailError = _validateEmail(value)
                                  ? ''
                                  : 'البريد الإلكتروني غير صحيح'; // Keep the original error message
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Phone Number TextField
                        TextField(
                          controller: phoneController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              'رقم الهاتف',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Date of Birth Field
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
                                hintText: selectedDate != null
                                    ? '${selectedDate!.toLocal()}'.split(' ')[
                                        0] // Display selected date in format 'YYYY-MM-DD'
                                    : 'تاريخ الميلاد', // "Date of Birth" placeholder in Arabic
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff180A44),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password TextField with validation and visibility toggle
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
                            label: const Text(
                              'كلمة المرور',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                            errorText: _passwordError.isNotEmpty
                                ? _passwordError
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _passwordError = _validatePassword(value)
                                  ? ''
                                  : 'يجب أن تحتوي كلمة المرور على أحرف كبيرة وصغيرة وأرقام وألا تقل عن 8 أحرف'; // Password requirements in Arabic
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Confirm Password TextField with visibility toggle
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
                            label: const Text(
                              'تأكيد كلمة المرور',
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
                            if (_validateEmail(emailController.text) &&
                                _validatePassword(passwordController.text)) {
                              signup();
                            } else {
                              String errorMsg =
                                  'تحقق من صحة البريد الإلكتروني وكلمة المرور'; // "Check the email and password validity"
                              _showSnackBar(context, errorMsg);
                            }
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
    if (_validateEmail(emailController.text) &&
        _validatePassword(passwordController.text)) {
      final user = await auth.creatUserWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (user != null) {
        goToHome(context);
      }
    }
  }
}
