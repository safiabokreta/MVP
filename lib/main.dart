import 'package:flutter/material.dart';
import 'package:zefeffete/views/screens/guestslistscreen.dart';
import 'package:zefeffete/views/screens/homepage.dart';
import 'package:zefeffete/views/screens/likedvendorsscreen.dart';
import 'package:zefeffete/views/screens/profilescreen.dart';
import 'package:zefeffete/views/screens/vendors.screen.dart';
import 'package:zefeffete/views/screens/venuesscreen.dart';
import 'package:zefeffete/views/screens/onboardingPages.dart';
import 'package:zefeffete/views/screens/homepage0.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPages(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/venues': (context) => Venues(),
        '/likedVendors': (context) => LikedVendors(),
        '/guestsList': (context) => GuestsList(),
        '/vendors': (context) => Vendors(),
        '/profile': (context) => Profile(),
      },
    );
  }
}
