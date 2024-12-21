import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaxRangedropdown extends StatefulWidget {
  final String initialSelection;
  final String selectedRange;

  const MaxRangedropdown({
    super.key,
    required this.selectedRange,
    required this.initialSelection,
  });

  @override
  MaxRangedropdownState createState() => MaxRangedropdownState();
}

class MaxRangedropdownState extends State<MaxRangedropdown> {
  late String selectedMaxPrice = '';

  // Display map with the display values and their corresponding numeric ranges
  final Map<double, String> displayMap = {
    0.0: '0.0',
    5000.0: '[0-5000]',
    10000.0: '[5000-10000]',
    15000.0: '[10000-15000]',
    20000.0: '[15000-20000]',
    25000.0: '[20000-25000]',
    30000.0: '[25000-30000]',
    35000.0: '[ > 30000]',
  };

  // Value map for selecting the range based on numeric value
  final Map<String, double> valueMap = {
    '0.0': 0.0,
    '[0-5000]': 5000.0,
    '[5000-10000]': 10000.0,
    '[10000-15000]': 15000.0,
    '[15000-20000]': 20000.0,
    '[20000-25000]': 25000.0,
    '[25000-30000]': 30000.0,
    '[ > 30000]': 35000.0,
  };

  @override
  void initState() {
    super.initState();
    selectedMaxPrice =
        widget.initialSelection.isNotEmpty ? widget.initialSelection : '0.0';
  }

  double getSelectedRangeAsReal() {
    return valueMap[selectedMaxPrice] ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedMaxPrice,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 181, 88, 139),
            width: 2.0,
          ),
        ),
        labelText: 'Max Price',
        labelStyle: GoogleFonts.poppins(
          color: const Color.fromARGB(255, 103, 102, 103),
        ),
        filled: true,
        fillColor: const Color.fromARGB(92, 255, 207, 247),
      ),
      items: displayMap.entries
          .map((entry) => DropdownMenuItem<String>(
                value: entry.value,
                child: Text(entry.value),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedMaxPrice = value!;
        });
      },
    );
  }
}
