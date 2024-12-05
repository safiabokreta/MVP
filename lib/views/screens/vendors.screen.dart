import 'package:flutter/material.dart';
import 'package:zefeffete/views/widgets/bottomNavigationBar.dart';

class Vendors extends StatefulWidget {
  const Vendors({super.key});

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentRoute: '/vendors'),
    );
  }
}
