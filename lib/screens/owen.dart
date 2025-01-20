import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:daar/widgets/vertical_recomend_list2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwenScreen extends StatefulWidget {
  const OwenScreen({Key? key}) : super(key: key);

  @override
  State<OwenScreen> createState() => _OwenScreenState();
}

class _OwenScreenState extends State<OwenScreen> {
  List<Property> userProperties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProperties();
  }

  Future<void> _fetchUserProperties() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userDocId = userProvider.userDocId;

    if (userDocId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Property')
          .where('user',
              isEqualTo: FirebaseFirestore.instance.doc('user/$userDocId'))
          .get();

      final properties =
          snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();

      setState(() {
        userProperties = properties;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching user properties: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          centerTitle: true,
          title: const Text(
            'عقاراتي',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF180A44),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20.0),
                      userProperties.isNotEmpty
                          ? VerticalRecomendList(
                              "",
                              userProperties,
                            )
                          : const Center(
                              child: Text(
                                'لا توجد عقارات مسجلة لك.',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class Property {
  final String id;
  final List<String> images;
  final String category;
  final String District;
  final String city;
  final double price;
  final int size;
  final int numOfBath;
  final int numOfLiving;
  final int numOfBed;
  final Timestamp dateList;
  final String status;
  final int view;

  Property({
    required this.id,
    required this.images,
    required this.category,
    required this.District,
    required this.city,
    required this.price,
    required this.size,
    required this.numOfBath,
    required this.numOfLiving,
    required this.numOfBed,
    required this.dateList,
    required this.status,
    required this.view,
  });

  factory Property.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      id: doc.id,
      images: (data['images'] != null && (data['images'] as List).isNotEmpty)
          ? List<String>.from(data['images'])
          : ['assets/images/noimg.png'],
      category: data['category'] ?? '',
      District: data['District'] ?? '',
      city: data['city'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      size: data['size'] ?? 0,
      numOfBath: data['numOfBath'] ?? 0,
      numOfLiving: data['numOfLivin'] ?? 0,
      numOfBed: data['numOfBed'] ?? 0,
      dateList: data['Date_list'] ?? Timestamp.now(),
      status: data['status'] ?? '',
      view: data['view'] ?? 0,
    );
  }
}
