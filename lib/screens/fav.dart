import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/screens/profile_page.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:daar/widgets/vertical_fav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  List<Property> favoriteProperties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteProperties();
  }

  Future<void> _fetchFavoriteProperties() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userDocId = userProvider.userDocId;

    if (userDocId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Fetch user's favorite property IDs
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userDocId)
          .get();

      final favoritePropertyIds =
          List<String>.from(userDoc.data()?['favorites'] ?? []);

      if (favoritePropertyIds.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Fetch properties that match the favorite IDs
      final snapshot = await FirebaseFirestore.instance
          .collection('Property')
          .where(FieldPath.documentId, whereIn: favoritePropertyIds)
          .get();

      final properties =
          snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();

      setState(() {
        favoriteProperties = properties;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching favorite properties: $e');
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
            'المفضلة',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
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
            height: favoriteProperties.length <= 1
                ? MediaQuery.of(context).size.height
                : null, // Set height to full screen if there is 0 or 1 favorite
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : favoriteProperties.isNotEmpty
                    ? VerticalRecomendList("", favoriteProperties)
                    : const Center(
                        child: Text(
                          'لا توجد عناصر مفضلة.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
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
  final String district;
  final String city;
  final double price;
  final int size;
  final int numOfBath;
  final int numOfLiving;
  final int numOfBed;
  final Timestamp dateList;
  final String status;
  final int view;
  final Timestamp? dateOfBirth; // New field

  Property({
    required this.id,
    required this.images,
    required this.category,
    required this.district,
    required this.city,
    required this.price,
    required this.size,
    required this.numOfBath,
    required this.numOfLiving,
    required this.numOfBed,
    required this.dateList,
    required this.status,
    required this.view,
    this.dateOfBirth,
  });

  factory Property.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      id: doc.id,
      images: (data['images'] != null && (data['images'] as List).isNotEmpty)
          ? List<String>.from(data['images'])
          : ['assets/images/noimg.png'],
      category: data['category'] ?? '',
      district: data['District'] ?? '',
      city: data['city'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      size: data['size'] ?? 0,
      numOfBath: data['numOfBath'] ?? 0,
      numOfLiving: data['numOfLivin'] ?? 0,
      numOfBed: data['numOfBed'] ?? 0,
      dateList: data['Date_list'] ?? Timestamp.now(),
      status: data['status'] ?? '',
      view: data['view'] ?? 0,
      dateOfBirth: data['DateOfBirth'], // Nullable field
    );
  }
}
