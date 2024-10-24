class Item {
  // Properties of the item
  List<String>? imagePaths; // List of image paths
  String? category;
  String? district;
  double? price;
  String? size;
  String? numofbed;
  String? numofbath;
  String? numoflivin;
  String? details;
  String? city;
  String? year;
  String? contact;
  String? direct;
  String? street;
  String? adDate; // تاريخ الإعلان
  int? views; // عدد المشاهدات
  String? location;

  // Constructor to initialize all properties
  Item(
    this.category,
    this.city,
    this.district,
    this.numofbath,
    this.numofbed,
    this.price,
    this.imagePaths,
    this.contact,
    this.details,
    this.numoflivin,
    this.size,
    this.year,
    this.direct,
    this.street,
    this.adDate, // تاريخ الإعلان
    this.views, // عدد المشاهدات
    this.location,
  );

  static List<Item> recomend = [
    Item(
      "فيلا",
      "الرياض",
      "الياسمين",
      "3",
      "5",
      1908765,
      [
        "assets/images/vill.png",
        "assets/images/vill2.png",
        "assets/images/vill3.png",
      ],
      "050446789",
      "فيلا راقية في حي الياسمين، مساحتها 800 متر مربع، تحتوي على 3 حمامات و 5 غرف نوم.",
      "2",
      "800",
      "2022",
      "شرق",
      "60",
      "34/34/34", // تاريخ الإعلان
      120, // عدد المشاهدات
      "Alnhakeel Mall, Riyadh, Saudi Arabia",
    ),
    Item(
      "فيلا",
      "الرياض",
      "الملقا",
      "4",
      "6",
      2500000,
      [
        "assets/images/vill2.png",
        "assets/images/vill5.png",
        "assets/images/vill6.png",
      ],
      "050489076",
      "فيلا فاخرة في حي الملقا، مساحتها 900 متر مربع، تحتوي على 4 حمامات و 6 غرف نوم.",
      "3",
      "900",
      "2023",
      "غرب",
      "20",
      "5/5/5", // تاريخ الإعلان
      200, // عدد المشاهدات
      "Shara Mall, Riyadh, Saudi Arabia",
    ),
    Item(
      "شقة",
      "الرياض",
      "السليمانية",
      "2",
      "3",
      850000,
      [
        "assets/images/apart.png",
        "assets/images/apart2.png",
        "assets/images/apart3.png",
      ],
      "0501234567",
      "شقة رائعة في حي السليمانية، تحتوي على 2 حمامات و 3 غرف نوم.",
      "1",
      "180",
      "2020",
      "شمال",
      "67",
      "6/8/9", // تاريخ الإعلان
      90, // عدد المشاهدات
      "Al Olaya District, Riyadh, Saudi Arabia",
    ),
  ];

  static List<Item> normal = [
    Item(
      "شقة",
      "الرياض",
      "الملقا",
      "2",
      "3",
      850000,
      [
        "assets/images/apart2.png",
      ],
      "0501234567",
      "شقة رائعة في حي الملقا، تحتوي على 2 حمامات و 3 غرف نوم.",
      "1",
      "180",
      "2020",
      "جنوب",
      "20",
      "4/5/7", // تاريخ الإعلان
      50, // عدد المشاهدات
      "Riyadh, Saudi Arabia",
    ),
    Item(
      "شقة",
      "الرياض",
      "العليا",
      "1",
      "2",
      750000,
      ["assets/images/Logo.png"],
      "0509876543",
      "شقة مريحة في حي العليا، تحتوي على 1 حمام و 2 غرف نوم.",
      "1",
      "150",
      "2022",
      "شرق",
      "100",
      "7/6/2", // تاريخ الإعلان
      85, // عدد المشاهدات
      "Riyadh, Saudi Arabia",
    ),
    Item(
      "شقة",
      "الرياض",
      "الملقا",
      "1",
      "2",
      600000,
      [
        "assets/images/apart.png",
        "assets/images/apart5.png",
        "assets/images/apart6.png",
      ],
      "0507654321",
      "شقة مميزة في حي الملقا، تحتوي على 1 حمام و 2 غرف نوم.",
      "1",
      "120",
      "2021",
      "شرق",
      "70",
      "5/4/3", // تاريخ الإعلان
      70, // عدد المشاهدات
      "Riyadh, Saudi Arabia",
    ),
  ];
}
