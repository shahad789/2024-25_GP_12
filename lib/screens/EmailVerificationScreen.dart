import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daar/screens/home_screen.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  // Method to check the email verification status
  void verifyEmailStatus(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Refresh user to get updated email verification status
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
        // Navigate to the home screen if email is verified
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        _showSnackBar(context, 'تم التحقق من البريد الإلكتروني بنجاح.');
      } else {
        _showSnackBar(context, 'البريد الإلكتروني لم يتم التحقق منه بعد.');
      }
    } else {
      _showSnackBar(context, 'حدث خطأ أثناء التحقق من البريد الإلكتروني.');
    }
  }

  // Method to resend the verification email
  void resendVerificationEmail(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.sendEmailVerification();
        _showSnackBar(
            context, 'تم إرسال رابط التحقق مرة أخرى إلى بريدك الإلكتروني.');
      } catch (e) {
        _showSnackBar(context, 'حدث خطأ أثناء إعادة إرسال رابط التحقق.');
      }
    } else {
      _showSnackBar(context, 'لا يوجد مستخدم مسجل حالياً.');
    }
  }

  // Utility method to show a snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // Background gradient
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff180A44), Color(0xff281537)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Logo at the top
            Positioned(
              top: 50,
              right: 20,
              child: Image.asset(
                'lib/assets/images/logow.png',
                width: 90,
                height: 90,
              ),
            ),
            // White container for the content
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'تأكيد البريد الإلكتروني',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff180A44),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'لقد أرسلنا رابطًا لتأكيد البريد الإلكتروني إلى عنوان بريدك الإلكتروني. يرجى التحقق من بريدك وتأكيد الحساب.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          backgroundColor:
                              const Color(0xff180A44), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () => verifyEmailStatus(context),
                        child: const Text(
                          'التحقق من حالة البريد الإلكتروني',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          backgroundColor:
                              const Color(0xff180A44), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () => resendVerificationEmail(context),
                        child: const Text(
                          'إعادة إرسال الرابط',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              const Color(0xff180A44), // Link color
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'العودة إلى تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
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
