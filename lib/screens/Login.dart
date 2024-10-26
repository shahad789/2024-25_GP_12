import 'package:flutter/material.dart';
import 'Register.dart'; // Import the register screen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  late String email;
  late String password;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  static const Color primary = Color(0xFF180a44);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

// Moved LoginScreen outside LoginState
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formState = GlobalKey<FormState>();
  static const Color primary = Color(0xFF180a44);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        // Set the entire screen to RTL
        textDirection: TextDirection.rtl,
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
            // Login form container
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: formState,
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Start from the top
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // Align items to the right
                      children: [
                        // Welcome Text inside the white container
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                            right: 0.0,
                            bottom: 20.0,
                          ), // Set right padding to 0
                          child: Align(
                            // Wrap in Align to control positioning
                            alignment: Alignment
                                .centerRight, // Ensure alignment to the right
                            child: Text(
                              'مرحباً\nتسجيل الدخول!',
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
                        const SizedBox(
                            height: 20), // Add space before the text fields
                        // Email TextField
                        TextFormField(
                          controller: _emailController,
                          textAlign: TextAlign.right, // Align text to the right
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.check,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'البريد الإلكتروني',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                          // Add validation for email format if needed
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Password TextField
                        TextFormField(
                          controller: _passwordController,
                          obscureText:
                              true, // Make sure to obscure password input
                          textAlign: TextAlign.right, // Align text to the right
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'كلمة المرور',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                          ),
                          // Add validation for password if needed
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Forgot Password text
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context,
                                  'reset'); // Navigate to ResetPassword
                            },
                            child: const Text(
                              'هل نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xff180A44),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Sign In Button
                        GestureDetector(
                          onTap: () {
                            // Validate the form
                            if (formState.currentState!.validate()) {
                              // Navigate to the home screen on sign in
                              Navigator.pushNamed(context, 'home');
                            }
                          },
                          child: Container(
                            height: 40,
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
                                'تسجيل الدخول',
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
                        // Sign up prompt
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "ليس لديك حساب؟",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegScreen()),
                                  );
                                },
                                child: const Text(
                                  "إنشاء حساب",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
