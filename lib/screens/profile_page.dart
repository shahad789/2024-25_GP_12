import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:daar/screens/edit_profile.dart'; // استيراد صفحة EditPage
import 'package:daar/screens/owen.dart'; // استيراد صفحة OwenScreen
import 'package:daar/screens/notif.dart'; // استيراد صفحة notif.dart
import 'package:daar/screens/fav.dart'; // استيراد صفحة fav.dart
import 'package:daar/screens/WelcomeScreen.dart'; // استيراد صفحة WelcomeScreen
import 'package:daar/screens/Add1.dart';
import 'package:daar/screens/predict.dart';
import 'package:daar/screens/home_screen.dart'; // استيراد الصفحة الرئيسية
import 'package:daar/screens/authentication.dart';
import 'package:provider/provider.dart';
import 'package:daar/usprovider/UserProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3; // الفهرس الافتراضي للصفحة الحالية

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        toolbarHeight: 60.0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotifPage()),
                );
              },
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/Logo.png',
                height: 25.0,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF180A44),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  '${userProvider.userName ?? '....تحميل '}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                ButtonSection(),
                SizedBox(height: 240),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF180A44),
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "الصفحة الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "التنبؤ"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add), label: "إضافة عقار"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person), label: "الحساب الشخصي"),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // تحديث الفهرس الحالي
    });

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PredictPage()),
      );
    }
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Authentication();
    return Column(
      children: [
        // زر عقاراتي
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OwenScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF180A44),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 265.0),
                  child: const Text(
                    'عقاراتي',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.home, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        // زر المفضلة
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF180A44),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 265.0),
                  child: const Text(
                    'المفضلة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        // زر إعدادات الحساب
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF180A44),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 220.0),
                  child: const Text(
                    'إعدادات الحساب',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.settings, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        // زر تسجيل خروج
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await auth.signout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );

              // أضف هنا وظيفة تسجيل الخروج إذا لزم الأمر
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF180A44),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 227.0),
                  child: GestureDetector(
                    onTap: () async {
                      await auth.signout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                      );
                    },
                    child: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child:
                      Icon(Icons.logout, color: Color.fromARGB(255, 254, 2, 2)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
