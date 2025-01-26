import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daar/usprovider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({Key? key}) : super(key: key);

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  List<QueryDocumentSnapshot> properties = []; // تخزين البيانات محليًا

  @override
  Widget build(BuildContext context) {
    final userDocId = Provider.of<UserProvider>(context).userDocId;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          centerTitle: true,
          title: const Text(
            'الاشعارات',
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
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF180A44),
                      Color(0xFF180A44),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 90.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Builder(
                  builder: (context) {
                    // Check if today is Friday
                    if (DateTime.now().weekday != DateTime.sunday) {
                      return const Center(
                        child: Text('لا توجد إشعارات لليوم.'),
                      );
                    }

                    // If it's Friday, proceed to display notifications
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Property')
                          .where('user',
                              isEqualTo: FirebaseFirestore.instance
                                  .doc('user/$userDocId'))
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('حدث خطأ أثناء تحميل البيانات.'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('لا توجد إشعارات.'));
                        } else {
                          properties = snapshot.data!.docs;
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 30.0),
                                  itemCount: properties.length,
                                  itemBuilder: (context, index) {
                                    final doc = properties[index];
                                    final propertyData =
                                        doc.data() as Map<String, dynamic>;

                                    final propertyDistrict =
                                        propertyData['District'] ?? 'الحي';
                                    final propertyCity = propertyData['city'] ??
                                        'المدينة غير محددة';
                                    final propertySize =
                                        propertyData['size'] ?? 'غير محدد';
                                    final propertyView =
                                        propertyData['view'] ?? 0;

                                    final title = 'مشاهدات عقارك';
                                    final message =
                                        'تمت مشاهدة عقارك في $propertyCity، حي $propertyDistrict، الذي حجمه $propertySize من قبل $propertyView شخص';

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        NotificationCard(
                                          title: title,
                                          message: message,
                                        ),
                                        const Divider(
                                            height: 20, color: Colors.grey),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}