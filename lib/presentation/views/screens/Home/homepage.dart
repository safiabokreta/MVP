import 'package:flutter/material.dart';
import 'package:zefeffete/data/datasources/sharaedprefs/sharedprefsmanager.dart';
import 'package:zefeffete/presentation/controllers/profile_controller.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/likesplot.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/reviewschart.dart';
import 'package:zefeffete/presentation/views/widgets/bottomNavigationBar.dart';
import 'package:zefeffete/presentation/views/widgets/appbar.dart';
import 'package:zefeffete/presentation/views/widgets/countDown.dart';
import 'package:zefeffete/presentation/views/widgets/bestVenues.dart';
import 'package:zefeffete/presentation/views/widgets/popularVendors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> currentUserEmail;
  late Future<String?> currentUserRole;
  late Future<String?> currentUsername;
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    currentUserEmail = SharedPreferencesManager().getEmail();
    currentUserRole = SharedPreferencesManager().getRole();
    currentUsername = SharedPreferencesManager().getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        flexibleSpace: const Appbar(),
      ),
      body: FutureBuilder<String?>(
        future: currentUserRole, // Fetch the role
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Role not found'));
          }

          String role = snapshot.data!;

          // Check if the role is 'wedding_owner' or 'vendor'
          if (role == 'wedding_owner') {
            // Display everything for wedding_owner
            return SingleChildScrollView(
              child: Column(
                children: const [
                  CountDown(),
                  SizedBox(height: 30),
                  BestVenues(),
                  PopularVendors(),
                ],
              ),
            );
          } else if (role == 'vendor') {
            // Display only vendor content for 'vendor'
            return SingleChildScrollView(
              child: Column(
                children: const [
                  LikesPlot(),
                  ReviewsChart(),
                  PopularVendors(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Invalid role'));
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/home'),
    );
  }
}
