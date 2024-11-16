import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/Login.dart';
import 'screens/Register.dart';
import 'screens/reset.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:daar/usprovider/UserProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDAb5ffsF8vIqRlGYwv-7Nl-XSn6A7OBQ0",
            authDomain: "daar-4ee4f.firebaseapp.com",
            projectId: "daar-4ee4f",
            storageBucket: "daar-4ee4f.appspot.com",
            messagingSenderId: "916519282950",
            appId: "1:916519282950:web:11ca937284b25166935687"));
  } else {
    await Firebase.initializeApp();
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const Color primary = Color(0xFF180A44);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(), // Set WelcomeScreen as the home page
      routes: {
        "welcome": (context) => const WelcomeScreen(),
        "login": (context) => const LoginScreen(),
        "register": (context) => const RegScreen(),
        "reset": (context) => const ResetPassword(), // Add reset password route
        "home": (context) => const HomeScreen(), // Add HomeScreen route
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primary,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: primary,
        ),
      ),
    );
  }
}
