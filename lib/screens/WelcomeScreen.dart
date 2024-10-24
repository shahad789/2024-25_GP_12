// ignore_for_file: file_names, use_super_parameters

import 'package:flutter/material.dart';
import 'Register.dart';
import 'Login.dart'; // Ensure this file and class exist

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'lib/assets/images/start.png', // Change to your desired background image
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover, // Cover the entire screen
          ),
          // Semi-transparent overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xFF180a44).withOpacity(
                0.8), // Increased opacity for a more prominent color
          ),
          // Centered content on top
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 50.0), // Adjust padding if needed
                  child: Image(
                    image: AssetImage('lib/assets/images/logow.png'),
                    height: 150, // Set your desired height here
                    width: 150, // Set your desired width here
                  ),
                ),
                const Text(
                  'مرحبا بك في دار', // Welcome text in Arabic
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // Center text
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Container(
                    height: 53,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Center(
                      child: Text(
                        'تسجيل الدخول', // "Sign In" in Arabic
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegScreen()),
                    );
                  },
                  child: Container(
                    height: 53,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Center(
                      child: Text(
                        'التسجيل', // "Sign Up" in Arabic
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
