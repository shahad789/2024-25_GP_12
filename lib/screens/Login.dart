import 'package:flutter/material.dart';
import 'Register.dart';
import 'reset.dart';
import 'package:daar/screens/authentication.dart';
import 'package:provider/provider.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = Authentication();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formState = GlobalKey<FormState>();
  static const Color primary = Color(0xFF180a44);

  String? emailError;
  String? passwordError;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(email);
  }

  bool _validatePassword(String password) {
    String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$';
    return RegExp(pattern).hasMatch(password);
  }

  void _onEmailChanged(String email) {
    setState(() {
      emailError = _validateEmail(email)
          ? null
          : 'البريد الإلكتروني غير صحيح، مثال: name@example.com';
    });
  }

  void _onPasswordChanged(String password) {
    setState(() {
      passwordError = _validatePassword(password)
          ? null
          : 'يجب أن تكون كلمة المرور 8 أحرف على الأقل\n وتحتوي على حرف كبير وحرف صغير ورقم';
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
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
                  colors: [Color(0xff180A44), Color(0xff281537)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: Image.asset(
                'lib/assets/images/logow.png',
                width: 90,
                height: 90,
              ),
            ),
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
                  child: Form(
                    key: formState,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'مرحباً\nتسجيل الدخول!',
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

                          // Email TextField with real-time validation and required field check

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
                              suffixIcon: Icon(Icons.email, color: Colors.grey),
                              errorText: emailError,
                            ),
                            onChanged: _onEmailChanged,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يجب إدخال البريد الإلكتروني';
                              }
                              return emailError;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password TextField with real-time validation and syntax check
                          const Padding(
                            padding: EdgeInsets.only(left: 280.0),
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
                          TextFormField(
                            controller: _passwordController,
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
                                onPressed: _togglePasswordVisibility,
                              ),
                              errorText: passwordError,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يجب إدخال كلمة المرور';
                              } else if (!_validatePassword(value)) {
                                return passwordError;
                              }
                              return null;
                            },
                            onChanged: _onPasswordChanged,
                          ),

                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResetPassword(),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: const Text(
                                "هل نسيت كلمة المرور؟",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          GestureDetector(
                            onTap: login,
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
                    ), //end
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  login() async {
    if (formState.currentState!.validate() &&
        emailError == null &&
        passwordError == null) {
      final user = await auth.loginUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (user != null) {
        if (!user.emailVerified) {
          // Notify the user to verify their email
          _showSnackBar(
              context, 'يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول');
          return;
        }

        final userEmail = user.email;

        // Fetch user document ID based on email
        final querySnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('Email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs.first;
          final userDocId = userDoc.id;
          final userName = userDoc['Name'];

          // Save user data to UserProvider
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(userDocId, userName, userEmail!);

          // Navigate to HomeScreen
          Navigator.pushNamed(context, 'home');
        } else {
          _showSnackBar(context, 'لم يتم العثور على بيانات المستخدم');
        }
      } else {
        _showSnackBar(context, 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
    }
  }
}
