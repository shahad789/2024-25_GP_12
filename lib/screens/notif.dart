import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:daar/usprovider/UserProvider.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({Key? key}) : super(key: key);

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  List<QueryDocumentSnapshot> properties = [];

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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Property')
                      .where('user',
                          isEqualTo:
                              FirebaseFirestore.instance.doc('user/$userDocId'))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      print('Error fetching data: ${snapshot.error}');
                      return const Center(
                        child: Text('حدث خطأ أثناء تحميل البيانات.'),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      print('No notifications found for user: $userDocId');
                      return const Center(child: Text('لا توجد إشعارات.'));
                    } else {
                      properties = snapshot.data!.docs;

                      // Debugging log for properties
                      print('Properties retrieved for user: $userDocId');
                      for (var doc in properties) {
                        final data = doc.data() as Map<String, dynamic>;
                        print('Property ID: ${doc.id}');
                        print('Raw Date_list: ${data['Date_list']}');
                        print('Views: ${data['view']}');
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 30.0),
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final doc = properties[index];
                          final propertyData =
                              doc.data() as Map<String, dynamic>;

                          final propertyDistrict =
                              propertyData['District'] ?? 'الحي';
                          final propertyCity =
                              propertyData['city'] ?? 'المدينة غير محددة';
                          final propertySize =
                              propertyData['size'] ?? 'غير محدد';
                          final propertyView = propertyData['view'] ?? 0;

                          // Handling date_list field
                          final dateListed = propertyData['Date_list'] != null
                              ? (propertyData['Date_list'] as Timestamp)
                                  .toDate()
                              : null;

                          final notifications = <NotificationCard>[];

                          // Add notification for views
                          if (propertyView > 0) {
                            print(
                                'Property ${doc.id} has $propertyView views.');
                            final viewNotificationMessage =
                                'تمت مشاهدة عقارك في $propertyCity، حي $propertyDistrict، الذي حجمه $propertySize من قبل $propertyView شخص';
                            notifications.add(
                              NotificationCard(
                                title: 'مشاهدات عقارك',
                                message: viewNotificationMessage,
                              ),
                            );
                          } else {
                            print('Property ${doc.id} has no views.');
                          }

                          // Add notification for date
                          if (dateListed != null) {
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(dateListed);
                            final daysListed =
                                DateTime.now().difference(dateListed).inDays;

                            print(
                                'Property ${doc.id} has been listed for $daysListed days since $formattedDate.');
                            final dateNotificationMessage =
                                'تم إدراج عقارك في $propertyCity، حي $propertyDistrict منذ $daysListed يومًا. هل لديك تحديثات للعقار مثل تعديل السعر أو التفاصيل؟ قم بتحديث إعلانك الآن لجذب المزيد من المشترين!';
                            notifications.add(
                              NotificationCard(
                                title: 'حدث حاله عقارك',
                                message: dateNotificationMessage,
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ...notifications,
                              const Divider(
                                height: 20,
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                      );
                    }
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
