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
  List<Map<String, String>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userDocId = userProvider.userDocId;

    if (userDocId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userDocId)
          .get();
      final favoritePropertyIds =
          List<String>.from(userDoc.data()?['favorites'] ?? []);

      if (favoritePropertyIds.isNotEmpty) {
        final favoriteSnapshot = await FirebaseFirestore.instance
            .collection('Property')
            .where(FieldPath.documentId, whereIn: favoritePropertyIds)
            .get();

        for (var doc in favoriteSnapshot.docs) {
          final propertyData = doc.data() as Map<String, dynamic>;
          if (propertyData['status'] == 'غير متوفر') {
            notifications.add({
              'title': 'عقارك المفضل غير متوفر الآن',
              'message':
                  'العقار في ${propertyData['city'] ?? 'المدينة غير محددة'}، حي ${propertyData['District'] ?? 'غير محدد'} لم يعد متاحًا.',
            });
            await FirebaseFirestore.instance
                .collection('Favorites')
                .doc(userDocId)
                .collection('userFavorites')
                .doc(doc.id)
                .delete();
          }
        }
      }

      final propertySnapshot = await FirebaseFirestore.instance
          .collection('Property')
          .where('user',
              isEqualTo: FirebaseFirestore.instance.doc('user/$userDocId'))
          .get();

      for (var doc in propertySnapshot.docs) {
        final propertyData = doc.data() as Map<String, dynamic>;
        final dateListed = (propertyData['Date_list'] as Timestamp?)?.toDate();
        if (dateListed != null) {
          final daysListed = DateTime.now().difference(dateListed).inDays;
          if (daysListed >= 30) {
            // Added condition here
            notifications.add({
              'title': 'حدث حالة عقارك',
              'message':
                  'تم إدراج عقارك في ${propertyData['city'] ?? 'المدينة غير محددة'}، حي ${propertyData['District'] ?? 'غير محدد'} منذ $daysListed يومًا. قم بتحديثه لجذب المشترين!',
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          centerTitle: true,
          title: const Text(
            'الإشعارات',
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF180A44), Color(0xFF180A44)]),
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
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : notifications.isEmpty
                        ? const Center(child: Text('لا توجد إشعارات.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 30.0),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  NotificationCard(
                                      title: notification['title']!,
                                      message: notification['message']!),
                                  if (index < notifications.length - 1)
                                    const Divider(
                                        height: 20, color: Colors.grey),
                                ],
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
      ),
    );
  }
}
