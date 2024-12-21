import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zefeffete/presentation/views/widgets/bottomNavigationBar.dart';
import 'package:zefeffete/presentation/views/widgets/bestVenues.dart';
import 'package:zefeffete/presentation/views/widgets/popularVendors.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/homeStyle.dart';

class HomeScreen0 extends StatefulWidget {
  const HomeScreen0({super.key});

  @override
  State<HomeScreen0> createState() => _HomeScreen0State();
}

class _HomeScreen0State extends State<HomeScreen0> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            expandedHeight: 70.0,
            automaticallyImplyLeading: false, // Remove the back icon
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: RichText(
                text: TextSpan(
                  text: 'Welcome to',
                  style: GoogleFonts.lobster(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  children: [
                    TextSpan(
                      text: ' Zefeffête',
                      style: GoogleFonts.lobster(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 255, 0, 102),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Discover the finest wedding ',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'venues',
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 0, 102),
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'vendors',
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 0, 102),
                              ),
                            ),
                            TextSpan(
                              text: ' to make your special day ',
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'unforgettable!',
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 0, 102),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const BestVenues(),
                const PopularVendors(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/home'),
    );
  }
}
