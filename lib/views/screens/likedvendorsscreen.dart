import 'package:flutter/material.dart';
import 'package:zefeffete/views/widgets/bottomNavigationBar.dart';

class LikedVendors extends StatefulWidget {
  const LikedVendors({super.key});

  @override
  State<LikedVendors> createState() => _LikedVendorsState();
}

class _LikedVendorsState extends State<LikedVendors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentRoute: '/likedVendors'),
    );
  }
}
