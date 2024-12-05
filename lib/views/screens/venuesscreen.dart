import 'package:flutter/material.dart';
import 'package:zefeffete/views/widgets/bottomNavigationBar.dart';

class Venues extends StatefulWidget {
  const Venues({super.key});

  @override
  State<Venues> createState() => _VenuesState();
}

class _VenuesState extends State<Venues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentRoute: '/venues'),
    );
  }
}
