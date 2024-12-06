import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularVendors extends StatefulWidget {
  const PopularVendors({super.key});

  @override
  State<PopularVendors> createState() => _PopularVendorsState();
}

class _PopularVendorsState extends State<PopularVendors> {
  bool more = false;
  final List<Map<String, String>> vendors = [
    {
      'title': 'Disc jockey Dylia',
      'price': '23000 DA',
      'imagePath': 'assets/vendor3.jpg',
      'location': 'Algiers',
      'rating': '4.5',
      'path': 'dummypath'
    },
    {
      'title': 'Wedding photographer Maissa',
      'price': '20000 DA',
      'imagePath': 'assets/vendor2.jpg',
      'location': 'Algiers',
      'rating': '4.7',
      'path': 'dummypath'
    },
    {
      'title': 'Traiteur Aissa',
      'price': '33000 DA',
      'imagePath': 'assets/vendor1.jpg',
      'location': 'Algiers',
      'rating': '4.6',
      'path': 'dummypath'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular vendors',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(children: [
              _vendorCard('Disc jockey Dylia', '23000 DA', 'assets/vendor1.jpg',
                  'Algiers', 4.5, 'dummypath'),
              _vendorCard('Wedding photographer Maissa', '20000 DA',
                  'assets/vendor2.jpg', 'Algiers', 4.8, 'dummypath'),
              _vendorCard('Traiteur Aissa', '30000 DA', 'assets/vendor3.jpg',
                  'Algiers', 4.6, 'dummypath'),
              _vendorCard('Traiteur Aissa', '30000 DA', 'assets/vendor1.jpg',
                  'Algiers', 4.5, 'dummypath'),
            ]),
            Visibility(
                visible: more,
                child: Column(
                  children: [
                    for (int i = 0; i < vendors.length; i++)
                      _vendorCard(
                        vendors[i]['title']!,
                        vendors[i]['price']!,
                        vendors[i]['imagePath']!,
                        vendors[i]['location']!,
                        double.parse(vendors[i]['rating']!),
                        vendors[i]['path']!,
                      ),
                  ],
                )),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                if (more) {
                  setState(() {
                    more = false;
                  });
                } else {
                  setState(() {
                    more = true;
                  });
                }
              },
              child: Center(
                  child: Text((!more) ? "See more" : 'See less',
                      style: GoogleFonts.raleway(color: Colors.grey))),
            )
          ],
        ));
  }

  Widget _vendorCard(String name, String price, String imagePath,
      String location, double rating, String path) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, path);
      },
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(0, 246, 246, 246),
        margin: const EdgeInsets.only(bottom: 16),
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 30,
            ),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.raleway(),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    price,
                    style: GoogleFonts.raleway(
                        color: Color.fromARGB(255, 10, 142, 217),
                        fontWeight: FontWeight.w500),
                  ),
                ]),
            subtitle: Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 12),
                const Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: GoogleFonts.raleway(color: Colors.grey),
                ),
              ],
            )),
      ),
    );
  }
}
