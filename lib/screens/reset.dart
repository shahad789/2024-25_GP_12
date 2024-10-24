import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<StatefulWidget> createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  late String email;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return const ResetPasswordScreen();
  }
}

// Moved ResetPasswordScreen outside ResetPasswordState
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
                'images/logo_white.png',
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Reset Password text
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                        ),
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
                      const TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.email,
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
                      ),
                      const SizedBox(height: 40),
                      // Reset Button
                      GestureDetector(
                        onTap: () {
                          // Handle reset password action here
                        },
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
          ],
        ),
      ),
    );
  }
}
