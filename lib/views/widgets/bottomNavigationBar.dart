import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;
  const BottomNavBar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color.fromARGB(204, 248, 235, 242),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(context,
              icon: Icons.home, label: "Home", route: '/home'),
          _buildNavItem(context,
              icon: Icons.location_on, label: "Venues", route: '/venues'),
          _buildNavItem(context,
              icon: Icons.favorite_border,
              label: "liked vendors",
              route: '/likedVendors'),
          _buildNavItem(context,
              icon: Icons.group, label: "Guests", route: '/guestsList'),
          _buildNavItem(context,
              icon: Icons.menu, label: "Vendors", route: '/vendors'),
          _buildNavItem(context,
              icon: Icons.person, label: "Profile", route: '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon, required String label, required String route}) {
    final isSelected = currentRoute == route;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Navigator.pushNamed(context, route);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(153, 247, 117, 156)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Color.fromARGB(255, 158, 4, 86)
                  : Color.fromARGB(255, 247, 117, 156),
              size: 20,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: TextStyle(
                      color: Color.fromARGB(255, 158, 4, 86),
                      //fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
