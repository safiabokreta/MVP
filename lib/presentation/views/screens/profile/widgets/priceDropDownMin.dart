import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MinRangedropdown extends StatefulWidget {
  final String initialSelection;
  final String selectedRange;

  const MinRangedropdown({
    super.key,
    required this.selectedRange,
    required this.initialSelection,
  });

  @override
  MinRangedropdownState createState() => MinRangedropdownState();
}

class MinRangedropdownState extends State<MinRangedropdown> {
  late String selectedMinPrice = '';

  final Map<double, String> displayMap = {
    0.0: '0.0',
    2500.0: '[0-5000]',
    7500.0: '[5000-10000]',
    12500.0: '[10000-15000]',
    17500.0: '[15000-20000]',
    22500.0: '[20000-25000]',
    27500.0: '[25000-30000]',
  };

  final Map<String, double> valueMap = {
    '0.0' : 0.0,
    '[0-5000]': 2500.0,
    '[5000-10000]': 7500.0,
    '[10000-15000]': 12500.0,
    '[15000-20000]': 17500.0,
    '[20000-25000]': 22500.0,
    '[25000-30000]': 27500.0,
  };

  @override
  void initState() {
    super.initState();
    selectedMinPrice =
        widget.initialSelection.isNotEmpty ? widget.initialSelection : '0.0';
  }

  double getSelectedRangeAsReal() {
    return valueMap[selectedMinPrice] ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedMinPrice,
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
        labelText: 'Min Price',
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
          selectedMinPrice = value!;
        });
      },
    );
  }
}
