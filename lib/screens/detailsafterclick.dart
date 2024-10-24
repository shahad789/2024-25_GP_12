// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:daar/models/item_model.dart';
import 'package:daar/widgets/detailssmall.dart';
import 'package:daar/widgets/detailinfo.dart';
import 'package:intl/intl.dart';
import 'package:daar/screens/home_screen.dart';

class DetailsBro extends StatefulWidget {
  final Item item;

  const DetailsBro(this.item, {super.key});

  @override
  State<DetailsBro> createState() => _DetailsBroState();
}

class _DetailsBroState extends State<DetailsBro> {
  int _currentImageIndex = 0;
  bool isLiked = false; // liked or no

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final priceFormatted =
        NumberFormat('#,##0', 'en_US').format(widget.item.price);
    return Scaffold(
        ///////////////////bedaya////////////////////////////////////////////
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
                // العودة إلى الصفحة الرئيسية
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
/////////////////////////////////////////////////////////////////25er

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
            // padding: const EdgeInsets.all(20.0),

            //////////////////////////////////////////////////////////
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.34, //check girls if u want bigger size
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: widget.item.imagePaths!.length, //toolha
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            widget.item.imagePaths![index],
                            fit: BoxFit.cover,
                            width: double.infinity, //23dad kteer
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        left: MediaQuery.of(context).size.width / 2 -
                            20, //makan dots
                        child: DotsIndicator(
                          dotsCount: widget.item.imagePaths!.length,
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

                /////////////////////////////////////////////////end of pictures
                const SizedBox(height: 16),
                //infofoo2
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _toggleLike, // Handle tap to toggle like status
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Space between the icon and text
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${widget.item.category} في ${widget.item.city} في حي ${widget.item.district}',
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
/////////////////////////////////////////////////////////////////end first
/////////////////////////////////////////////////////////////////boxes w kalam jowa
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: boxdetail(
                                '  غرف النوم', '${widget.item.numofbed}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: boxdetail(
                                ' دورات المياه', '${widget.item.numofbath}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: boxdetail(
                                ' غرف الجلوس', '${widget.item.numoflivin}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                boxdetail('المساحة', '${widget.item.size} م²'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: boxdetail('الجهة', '${widget.item.direct}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: boxdetail(
                                'عرض الشارع', '${widget.item.street} م'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: boxdetail(
                                'تاريخ الاعلان', '${widget.item.adDate}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                boxdetail('سنة البناء', '${widget.item.year}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
///////////////////////////////////////////////////////////////////////////////////////////////////
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
                      Text(
                        widget.item.details!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 13, 6, 37),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
//////////////////////////////////////////////////////////////////////////////////////////tafaseel
                const SizedBox(height: 20),
                contactdet('طريقة التواصل', '${widget.item.contact}'),

//////////////////////////////////////////////////////////////////////////////////////////////////start of price
                const SizedBox(height: 20),

                //price sheklo w atba3
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
                        '$priceFormatted  ',
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
        ));
  }

  //////////////////////////////////////////////////////
}
