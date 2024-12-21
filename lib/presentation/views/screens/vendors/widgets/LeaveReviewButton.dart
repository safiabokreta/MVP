import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';
import 'LeaveReview.dart';

class LeaveReviewButton extends StatelessWidget {
  final String vendorEmail;

  const LeaveReviewButton({super.key, required this.vendorEmail});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to be logged in to leave a review.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.primary4),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ElevatedButton(
          onPressed: () async {
            if (await _isLoggedIn()) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return LeaveReview(email: vendorEmail);
                },
              );
            } else {
              _showLoginDialog(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDE6EB),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Leave a review',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
