import 'package:flutter/material.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';

class ClearApply extends StatelessWidget {
  final VoidCallback onClear; // Callback function for "Clear"
  final VoidCallback onApply; // Callback function for "Apply"

  const ClearApply({
    super.key,
    required this.onClear,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 40,
            width: 170,
            child: ElevatedButton(
              onPressed: onClear, // Call the onClear callback
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: AppColors.primary4,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            width: 170,
            child: ElevatedButton(
              onPressed: onApply, // Call the onApply callback
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
