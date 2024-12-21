import 'package:flutter/material.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartButton extends StatefulWidget {
  const HeartButton({super.key});

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  bool isLiked = false;

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // This keeps the dialog's height small
              children: [
                const Text(
                  "You need to log in to like a vendor.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: AppColors.primary4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleLike() async {
    bool loggedIn = await _isLoggedIn();

    if (!loggedIn) {
      _showLoginDialog();
    } else {
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, right: 35.0),
      child: IconButton(
        onPressed: toggleLike,
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: AppColors.primary4,
          size: 32,
        ),
      ),
    );
  }
}
