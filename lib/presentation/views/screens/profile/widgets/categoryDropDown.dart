import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categorydropdown extends StatefulWidget {
  final String initialSelection;
  final String selectedCategory;

  const Categorydropdown({
    super.key,
    required this.selectedCategory,
    required this.initialSelection,
  });

  @override
  CategorydropdownState createState() => CategorydropdownState();
}

class CategorydropdownState extends State<Categorydropdown> {
  late String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialSelection.isNotEmpty
        ? widget.initialSelection
        : 'category';
  }

  // Method to get the selected Categorydropdown
  String getSelectedCategory() {
    return selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedCategory,
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
        labelText: 'Category',
        labelStyle: GoogleFonts.poppins(
          color: const Color.fromARGB(255, 103, 102, 103),
        ),
        filled: true,
        fillColor: const Color.fromARGB(92, 255, 207, 247),
      ),
      items: const [
        DropdownMenuItem(value: 'category', child: Text('Category')),
        DropdownMenuItem(value: 'photographer', child: Text('Photographer')),
        DropdownMenuItem(value: 'dj', child: Text('Dj')),
        DropdownMenuItem(value: 'chef', child: Text('Chef')),
        DropdownMenuItem(value: 'florist', child: Text('Florist')),
        DropdownMenuItem(value: 'renting', child: Text('Clothes renting')),
      ],
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
    );
  }
}
