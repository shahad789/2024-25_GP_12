import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<StatefulWidget> createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return const ResetPasswordScreen();
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Email validation using regex
  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(email);
  }

  // Function to handle when the email field is changed
  void _onEmailChanged(String email) {
    setState(() {
      emailError = _validateEmail(email)
          ? null
          : 'البريد الإلكتروني غير صحيح، مثال: name@example.com';
    });
  }

  // Function to reset the password
  Future<void> passwordReset() async {
    // Check if the email field is empty or invalid before attempting reset
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        emailError = 'يجب إدخال البريد الإلكتروني';
      });
      return;
    }

    if (!_validateEmail(_emailController.text.trim())) {
      setState(() {
        emailError = 'البريد الإلكتروني غير صحيح';
      });
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      // Show success dialog when email is sent
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("تم ارسال رابط إعادة التعيين إلى بريدك الإلكتروني"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Error handling for specific Firebase error codes
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage =
            'البريد الإلكتروني غير مسجل. الرجاء التأكد والمحاولة مرة أخرى.';
      } else {
        errorMessage = e.message ?? "حدث خطأ. حاول مرة أخرى";
      }

      // Show error dialog based on FirebaseAuthException
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(errorMessage),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl, // RTL for Arabic support
        child: Stack(
          children: [
            // Background gradient
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
            // Positioned Logo
            Positioned(
              top: 50,
              right: 20,
              child: Image.asset(
                'lib/assets/images/logow.png',
                width: 90,
                height: 90,
              ),
            ),
            // Reset form container
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
                child: SingleChildScrollView(
                  // Added scrollable view
                  physics:
                      const BouncingScrollPhysics(), // Optional smooth scrolling
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Reset Password text
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'إعادة تعيين\nكلمة المرور',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff180A44),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Email TextField
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
                        TextFormField(
                          controller: _emailController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.email, color: Colors.grey),
                            errorText: emailError,
                          ),
                          onChanged: _onEmailChanged,
                        ),
                        const SizedBox(height: 40),

                        // Reset Button
                        GestureDetector(
                          onTap: passwordReset,
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff180A44),
                                  Color(0xff180A44),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'إعادة تعيين كلمة المرور',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Back to Login prompt
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Go back to login
                            },
                            child: const Text(
                              'العودة إلى تسجيل الدخول',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
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
