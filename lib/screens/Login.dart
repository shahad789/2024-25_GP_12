import 'package:flutter/material.dart';
import 'Register.dart';
import 'package:daar/screens/authentication.dart';
import 'package:get/get.dart';

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
                        // Email TextField with real-time validation and syntax check
                        TextFormField(
                          controller: _emailController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              emailError == null ? Icons.check : Icons.error,
                              color: emailError == null
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            label: const Text(
                              'البريد الإلكتروني',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                            errorText: emailError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب إدخال البريد الإلكتروني';
                            } else if (!_validateEmail(value)) {
                              return 'البريد الإلكتروني غير صحيح، مثال: name@example.com';
                            }
                            return null;
                          },
                          onChanged: _onEmailChanged,
                        ),

                        const SizedBox(height: 20),

// Password TextField with real-time validation and syntax check
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
                            label: const Text(
                              'كلمة المرور',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff180A44),
                              ),
                            ),
                            errorText: passwordError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب إدخال كلمة المرور';
                            } else if (!_validatePassword(value)) {
                              return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل\n وتحتوي على حرف كبير وحرف صغير ورقم';
                            }
                            return null;
                          },
                          onChanged: _onPasswordChanged,
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
        print("user logged in");
        Navigator.pushNamed(context, 'home');
      } else {
        // Show error message in Arabic
        _showSnackBar(context,
            'البريد الإلكتروني أو كلمة المرور غير صحيحة'); // "Email or password is incorrect"
      }
    }
  }
}
