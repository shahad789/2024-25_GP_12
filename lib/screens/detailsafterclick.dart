// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/screens/home_screen.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:daar/widgets/detailssmall.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsBro extends StatefulWidget {
  final String propertyId;

  const DetailsBro(this.propertyId, {super.key});

  @override
  State<DetailsBro> createState() => _DetailsBroState();
}

class _DetailsBroState extends State<DetailsBro> {
  int _currentImageIndex = 0; //since multiple images
  bool isLiked = false; // liked or no
  Map<String, dynamic>? propertyData;
  String? currentUserId;

//initially
  @override
  void initState() {
    super.initState();
    _fetchPropertyDetails();
    _incrementViewCount();
    _incrementUserViewHistory();
    _checkIfFavorite();
  }

  /////favorite
  // Fetch property details
  void _fetchPropertyDetails() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Property')
        .doc(widget.propertyId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        propertyData = docSnapshot.data();
      });
    }
  }

  // Check if property is in the user's favorite list
  void _checkIfFavorite() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUserId = userProvider.userDocId;

    if (currentUserId == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('user').doc(currentUserId);
    final userDoc = await userRef.get();

    if (!userDoc.exists || userDoc.data() == null) {
      // If user document does not exist, create it with an empty favorites list
      await userRef.set({'favorites': []});
      return;
    }

    List<String> favorites =
        List<String>.from(userDoc.data()?['favorites'] ?? []);

    setState(() {
      isLiked = favorites.contains(widget.propertyId);
    });
  }

  // Toggle favorite status
  void _toggleFavorite() async {
    if (currentUserId == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('user').doc(currentUserId);
    final userDoc = await userRef.get();

    List<String> favorites = [];

    if (userDoc.exists && userDoc.data() != null) {
      // Ensure 'favorites' exists and is a List<String>
      favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);
    }

    if (favorites.contains(widget.propertyId)) {
      favorites.remove(widget.propertyId);
    } else {
      favorites.add(widget.propertyId);
    }

    // Update Firestore with merged data
    await userRef.set({'favorites': favorites}, SetOptions(merge: true));

    setState(() {
      isLiked = favorites.contains(widget.propertyId);
    });
  }

  ///

//increment view
  void _incrementViewCount() async {
    try {
      // Get the current user's Firestore document ID from UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String? currentUserId = userProvider.userDocId;

      if (currentUserId == null) return; // If user ID is null, exit

      // Fetch the property document
      final propertyDoc = await FirebaseFirestore.instance
          .collection('Property')
          .doc(widget.propertyId)
          .get();

      if (propertyDoc.exists) {
        final propertyData = propertyDoc.data();

        // Ensure 'user' field exists and is a reference
        final DocumentReference? propertyOwnerRef = propertyData?['user'];

        if (propertyOwnerRef != null) {
          // Get the actual owner ID from Firestore reference
          final String propertyOwnerId = propertyOwnerRef.id;

          // Only increment if the current user is NOT the owner
          if (propertyOwnerId != currentUserId) {
            await FirebaseFirestore.instance
                .collection('Property')
                .doc(widget.propertyId)
                .update({
              'view': FieldValue.increment(1),
            });
          }
        }
      }
    } catch (e) {
      print('Failed to increment view count: $e');
    }
  }

  //for view timespan
  void _incrementUserViewHistory() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String? currentUserId = userProvider.userDocId;

      if (currentUserId == null) return;

      final userRef =
          FirebaseFirestore.instance.collection('user').doc(currentUserId);
      final userDoc = await userRef.get();

      List<dynamic> viewedProperties = [];

      if (userDoc.exists && userDoc.data()?['viewedProperties'] != null) {
        viewedProperties = List.from(userDoc.data()?['viewedProperties']);
      }

      int existingIndex = viewedProperties
          .indexWhere((p) => p['propertyId'] == widget.propertyId);

      if (existingIndex != -1) {
        viewedProperties[existingIndex]['numview'] += 1;
        viewedProperties[existingIndex]['timespan'] =
            DateTime.now().millisecondsSinceEpoch;
      } else {
        viewedProperties.add({
          'propertyId': widget.propertyId,
          'numview': 1,
          'timespan': DateTime.now().millisecondsSinceEpoch,
        });
      }

      if (viewedProperties.length > 10) {
        // Corrected sorting order
        viewedProperties.sort((a, b) {
          int viewCompare =
              a['numview'].compareTo(b['numview']); // Sort by least views first
          if (viewCompare != 0) return viewCompare;
          return a['timespan']
              .compareTo(b['timespan']); // If same views, oldest first
        });

        viewedProperties.removeAt(0);
      }

      if (userDoc.exists) {
        await userRef.update({'viewedProperties': viewedProperties});
      } else {
        await userRef.set({'viewedProperties': viewedProperties});
      }
    } catch (e) {
      print('Failed to update user view history: $e');
    }
  }

//interface
  @override
  Widget build(BuildContext context) {
    // Only format price if propertyData is loaded
    final priceFormatted = propertyData != null
        ? NumberFormat('#,##0', 'en_US').format(propertyData!['price'])
        : '';

    if (propertyData == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          title: const Text(
            '  تفاصيل',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),

        body: const Center(
            child: CircularProgressIndicator()), // Loading indicator
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: const Color(0xFF180A44),
        toolbarHeight: 70.0,
        title: const Text(
          '  تفاصيل',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
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
          padding: const EdgeInsets.only(top: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display property images
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.34,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: (propertyData!['images'] as List).length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          propertyData!['images'][index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: MediaQuery.of(context).size.width / 2 - 20,
                      child: DotsIndicator(
                        dotsCount: (propertyData!['images'] as List).length,
                        position: _currentImageIndex.toDouble(),
                        decorator: const DotsDecorator(
                          activeColor: Color.fromARGB(210, 152, 151, 151),
                          size: Size.square(8.0),
                          activeSize: Size.square(12.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Details section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),

                    //location
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${propertyData!['category']} في ${propertyData!['city']} في حي ${propertyData!['District']}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 13, 6, 37),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info boxes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    //1
                    Row(
                      children: [
                        Expanded(
                          child: boxdetail(
                              '  غرف النوم', '${propertyData!['numOfBed']}'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: boxdetail(
                              'المساحة', '${propertyData!['size']} م²'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //2
                    Row(
                      children: [
                        Expanded(
                          child: boxdetail(
                              ' غرف الجلوس', '${propertyData!['numOfLivin']}'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: boxdetail(
                              ' دورات المياه', '${propertyData!['numOfBath']}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //3
                    Row(
                      children: [
                        Expanded(
                          child: boxdetail(
                              'الجهة', '${propertyData!['Direction']}'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: boxdetail('عرض الشارع',
                              '${propertyData!['streetWidth']} م'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //4
                    Row(
                      children: [
                        Expanded(
                          child: boxdetail(
                            'تاريخ الاعلان',
                            DateFormat('yyyy-MM-dd').format(
                              (propertyData!['Date_list'] as Timestamp)
                                  .toDate(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: boxdetail(
                              'سنة البناء', '${propertyData!['year']}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Property Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'تفاصيل',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 13, 6, 37),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        propertyData!['details']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 13, 6, 37),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contact Details
              FutureBuilder<DocumentSnapshot>(
                future: (propertyData!['user'] as DocumentReference)
                    .get(), // Fetch the user document
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loading spinner to load
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Text(
                        'فشل في تحميل بيانات المستخدم.'); // errors
                  }

                  // Extract user document and cast its data to Map<String, dynamic>
                  final userDocument = snapshot.data!;
                  final userData = userDocument.data() as Map<String, dynamic>;

                  // Retrieve and convert the Phone field from string to number becuase in database string
                  final phoneString = userData['Phone'] ??
                      '0'; // Default if "Phone" field is missing

                  // Format the phone number to add +966 for Saudi Arabia
                  final phoneNumber =
                      '+966${phoneString.replaceFirst('0', '')}'; // Remove leading zero and add +966
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      // Ensure that the whole column is centered
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the content vertically
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Center the content horizontally
                        children: [
                          // Add 'طريقة التواصل' text above the phone number
                          const Text(
                            'طريقة التواصل',
                            style: TextStyle(
                              fontSize: 20, // Font size for the title
                              color: Color.fromARGB(255, 13, 6, 37),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign:
                                TextAlign.center, // Align text in the center
                          ),

                          const SizedBox(
                              height:
                                  8), // Add space between title and phone number

                          // Display the phone number with the same font size as the price
                          Text(
                            'رقم الهاتف: $phoneNumber',
                            style: const TextStyle(
                              fontSize: 22, // Same font size as price
                              color: Color.fromARGB(255, 13, 6, 37),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign:
                                TextAlign.center, // Align text in the center
                          ),

                          const SizedBox(
                              height:
                                  8), // Add some space between text and icon

                          // WhatsApp Icon Button with larger size
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              size: 30, // Increase the icon size
                            ),
                            onPressed: () {
                              final Uri whatsappUrl =
                                  Uri.parse('https://wa.me/$phoneNumber');
                              launchUrl(whatsappUrl,
                                  mode: LaunchMode.externalApplication);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Price Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'ريال سعودي ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Text(
                      priceFormatted,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
