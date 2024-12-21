import 'package:flutter/material.dart';
import 'PhotographersPage.dart';
import 'CaterersPage.dart';
import 'DJsPage.dart';
import 'FloristsPage.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';
import 'package:zefeffete/presentation/views/widgets/bottomNavigationBar.dart';

class VendorsPage extends StatelessWidget {
  final bool useCustomFilter;
  final double? minPrice;
  final double? maxPrice;
  final String? gender;
  final String? rating;
  final Map<String, List<String>>? locations;

  const VendorsPage({
    super.key,
    this.useCustomFilter = false,
    this.minPrice,
    this.maxPrice,
    this.gender,
    this.rating,
    this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Vendors",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: AppColors.primary4,
            indicatorColor: AppColors.primary4,
            indicatorWeight: 3.0,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: "Photographers"),
              Tab(text: "Caterers"),
              Tab(text: "DJs"),
              Tab(text: "Florists"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PhotographersPage(
              useCustomFilter: useCustomFilter,
              minPrice: minPrice,
              maxPrice: maxPrice,
              gender: gender,
              rating: rating,
              locations: locations,
            ),
            CaterersPage(),
            DJsPage(),
            FloristsPage(),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(
          currentRoute: '/vendors',
        ),
      ),
    );
  }
}
