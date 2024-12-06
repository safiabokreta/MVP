import 'package:flutter/material.dart';
import 'package:zefeffete/views/widgets/bottomNavigationBar.dart';

class GuestsList extends StatefulWidget {
  const GuestsList({super.key});

  @override
  State<GuestsList> createState() => _GuestsListState();
}

class _GuestsListState extends State<GuestsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentRoute: '/guestsList'),
    );
  }
}
