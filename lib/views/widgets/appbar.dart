import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 35, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: 'Welcome, ',
              style: GoogleFonts.raleway(fontSize: 18, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Wafaa',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color.fromARGB(255, 247, 117, 156),
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'),
            radius: 20,
          ),
        ],
      ),
    );
  }
}
