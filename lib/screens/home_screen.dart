import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/screens/Add1.dart';
import 'package:daar/screens/filterp.dart';
import 'package:daar/screens/notif.dart';
import 'package:daar/screens/predict.dart';
import 'package:daar/screens/profile_page.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:daar/widgets/recomend_list.dart';
import 'package:daar/widgets/vertical_recomend_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; //for navigation
  List<Property> allProperties = []; //all properties list
  List<Property> recommendedProperties = []; //recomend list
  List<Property> filteredProperties = []; //filtered list
  bool filtersApplied = false; //saved status of filter initially false
  Map<String, dynamic> currentFilters =
      {}; //to help with saved filter to go back to

//calling this initially
  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

//upon navigating to other page method
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
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
  }

  Future<void> _fetchProperties() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? currentUserId = userProvider.userDocId;

    if (currentUserId == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('user').doc(currentUserId);
    final userDoc = await userRef.get();

    List<dynamic> viewedProperties =
        userDoc.exists && userDoc.data()?['viewedProperties'] != null
            ? List.from(userDoc.data()?['viewedProperties'])
            : [];

    // Fetch all properties (excluding user's own)
    final allPropertiesSnapshot = await FirebaseFirestore.instance
        .collection('Property')
        .where('status', isEqualTo: 'متوفر')
        .orderBy('Date_list', descending: true)
        .limit(100) // Fetch extra for prioritization
        .get();

    List<Property> allFetchedProperties = allPropertiesSnapshot.docs
        .map((doc) => Property.fromFirestore(doc))
        .where((property) =>
            property.userId != currentUserId) // Exclude user's properties
        .toList();

    setState(() {
      allProperties = allFetchedProperties;
    });

    // If no history, return the 5 most recent properties
    if (viewedProperties.isEmpty) {
      setState(() {
        recommendedProperties = allFetchedProperties.take(5).toList();
      });
      return;
    }

    // Analyze user history
    List<String> propertyIds =
        viewedProperties.map((p) => p['propertyId'] as String).toList();

    List<Property> viewedPropertiesList = allFetchedProperties
        .where((property) => propertyIds.contains(property.id))
        .toList();

    Map<String, int> typeCounts = {};
    Map<String, int> cityCounts = {};

    for (var property in viewedPropertiesList) {
      String type = property.category;
      String city = property.city;

      // Increment category count
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;

      // Increment city count
      cityCounts[city] = (cityCounts[city] ?? 0) + 1;
    }

    if (typeCounts.isNotEmpty && cityCounts.isNotEmpty) {
      String mostViewedType =
          typeCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      String mostViewedCity =
          cityCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      List<Property> tempList = [];

      // ✅ **1st Priority: Match BOTH category & city**
      List<Property> matchBoth = allFetchedProperties
          .where((property) =>
              property.category == mostViewedType &&
              property.city == mostViewedCity)
          .toList();
      matchBoth.sort((a, b) => b.Date_list.compareTo(a.Date_list));
      tempList.addAll(matchBoth);

      // If more than 5, take only the most recent 5
      if (tempList.length > 5) {
        tempList = tempList.take(5).toList();
      }

      // ✅ **2nd Priority: Match only the city (if needed)**
      if (tempList.length < 5) {
        List<Property> matchCity = allFetchedProperties
            .where((property) =>
                property.city == mostViewedCity &&
                property.category != mostViewedType)
            .toList();
        matchCity.sort((a, b) => b.Date_list.compareTo(a.Date_list));

        tempList.addAll(matchCity);

        if (tempList.length > 5) {
          tempList = tempList.take(5).toList();
        }
      }

      // ✅ **3rd Priority: Match only the category (if needed)**
      if (tempList.length < 5) {
        List<Property> matchCategory = allFetchedProperties
            .where((property) =>
                property.category == mostViewedType &&
                property.city != mostViewedCity)
            .toList();
        matchCategory.sort((a, b) => b.Date_list.compareTo(a.Date_list));

        tempList.addAll(matchCategory);

        if (tempList.length > 5) {
          tempList = tempList.take(5).toList();
        }
      }

      // ✅ **4th Priority: Show most recent (if needed)**
      if (tempList.length < 5) {
        List<Property> recentProperties = allFetchedProperties
            .where((property) =>
                property.category != mostViewedType &&
                property.city != mostViewedCity)
            .toList();
        recentProperties.sort((a, b) => b.Date_list.compareTo(a.Date_list));

        tempList.addAll(recentProperties);

        if (tempList.length > 5) {
          tempList = tempList.take(5).toList();
        }
      }

      setState(() {
        recommendedProperties = tempList;
      });
    }
  }

  //for filter method show properties based on user requiermenets
  void _applyFilters(Map<String, dynamic> filters) {
    //make list based on what is filtered
    final filtered = allProperties.where((property) {
      //price
      if (filters['minPrice'] != null && property.price < filters['minPrice']) {
        return false;
      }
      if (filters['maxPrice'] != null && property.price > filters['maxPrice']) {
        return false;
      }
      //size
      if (filters['minSize'] != null && property.size < filters['minSize']) {
        return false;
      }
      if (filters['maxSize'] != null && property.size > filters['maxSize']) {
        return false;
      }
      //city, district
      if (filters['selectedCity'] != null &&
          property.city != filters['selectedCity']) {
        return false;
      }
      if (filters['selectedDistrict'] != null &&
          property.District != filters['selectedDistrict']) {
        return false;
      }

      //number of bedroom
      if (filters['selectedRoom'] != null) {
        if (filters['selectedRoom'] == 5) {
          if (property.numofbed < 5) {
            return false;
          }
        } else if (property.numofbed != filters['selectedRoom']) {
          return false;
        }
      }

      //number of bathroom
      if (filters['selectedBath'] != null) {
        if (filters['selectedBath'] == 5) {
          if (property.numofbath < 5) {
            return false;
          }
        } else if (property.numofbath != filters['selectedBath']) {
          return false;
        }
      }

      //number of livingroom
      if (filters['selectedLiving'] != null) {
        if (filters['selectedLiving'] == 5) {
          if (property.numoflivin < 5) {
            return false;
          }
        } else if (property.numoflivin != filters['selectedLiving']) {
          return false;
        }
      }

      //type
      if (filters['selectedCategory'] != null &&
          property.category != filters['selectedCategory']) {
        return false;
      }

      return true;
    }).toList();

    //state now is filtered
    setState(() {
      filteredProperties = filtered;
      filtersApplied = true;
    });
  }

  //when going to filter page send current filter in case user want to see or continue on it
  void _navigateToFilters() async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          selectedFilters: currentFilters, // Pass all selected filters
        ),
      ),
    );

    if (filters != null && filters.isNotEmpty) {
      setState(() {
        currentFilters = filters; // Update all filters
        _applyFilters(filters); // Apply them to properties
      });
    } else {
      setState(() {
        filtersApplied = false; // Clear filter state
        currentFilters = {}; // Reset all filters
      });
    }
  }

  //interface
  @override
  Widget build(BuildContext context) {
    //to help print user hello
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: const Color(0xFF180a44),
        toolbarHeight: 70.0,
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
            Image.asset(
              'assets/images/logow.png',
              height: 25.0,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ],
        ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 20.0),

              Text(
                'مرحباً، ${userProvider.userName ?? 'مستخدم'}',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Arial',
                ),
                textAlign: TextAlign.right,
              ),

              Transform.translate(
                offset: Offset(0, -44), // القيمة السالبة تعني رفع العنصر لأعلى
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none, //for red dot
                      children: [
                        IconButton(
                          onPressed: _navigateToFilters,
                          icon: const Icon(
                            Icons.filter_alt,
                            color: Color(0xFF180A44),
                          ),
                        ),
                        // show red dot if did
                        if (filtersApplied)
                          Positioned(
                            top: 9,
                            right: 9,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    255, 243, 95, 95), // اللون الأحمر للنقطة
                                shape: BoxShape.circle, // جعلها دائرة
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!filtersApplied)
                recomendList("التوصيات", recommendedProperties),

              const SizedBox(height: 20.0),

              // Display all properties when no filter is applied
              if (!filtersApplied)
                VerticalRecomendList("العقارات", allProperties),

              // Display filtered properties when filters are applied
              if (filtersApplied)
                VerticalRecomendList("العقارات", filteredProperties),

              // Show "no results" message only when filters are applied and result is empty
              if (filtersApplied && filteredProperties.isEmpty)
                const Center(
                  child: Text(
                    'لا توجد نتائج للتصفية المختارة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),

              const SizedBox(
                  height: 4000.0), // ترك مسافة إضافية أسفل المحتوى          ],
            ],
          ),
        ),
      ),

      //navigation down
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
              icon: Icon(CupertinoIcons.person), label: "الملف الشخصي"),
        ],
      ),
    );
  }
}

//information
class Property {
  final String id;
  final List<String> images;
  final String category;
  final String District;
  final String city;
  final double price;
  final int size;
  final int numofbath;
  final int numoflivin;
  final int numofbed;
  final Timestamp Date_list;
  final String userId;

  Property({
    required this.id,
    required this.images,
    required this.category,
    required this.District,
    required this.city,
    required this.price,
    required this.size,
    required this.numofbath,
    required this.numoflivin,
    required this.numofbed,
    required this.Date_list,
    required this.userId,
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
      numofbath: data['numOfBath'] ?? 0,
      numoflivin: data['numOfLivin'] ?? 0,
      numofbed: data['numOfBed'] ?? 0,
      Date_list: data['Date_list'] ?? Timestamp.now(),
      userId: (data['user'] as DocumentReference?)?.id ?? '',
    );
  }
}
