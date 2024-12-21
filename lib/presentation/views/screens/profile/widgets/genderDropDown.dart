import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Genderdropdown extends StatefulWidget {
  final String initialSelection;
  final String selectedGender;

   const Genderdropdown({
    super.key,
    required this.selectedGender,
    required this.initialSelection,
  });

  @override
  GenderdropdownState createState() => GenderdropdownState();
}

class GenderdropdownState extends State<Genderdropdown> {
  late String selectedGender = '';

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialSelection.isNotEmpty ? widget.initialSelection : 'gender';
  }

  // Method to get the selected Genderdropdown
  String getSelectedGender() {
    return selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
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
                                labelText: 'Gender',
                                labelStyle: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 103, 102, 103),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(92, 255, 207, 247),
                              ),
      value: selectedGender,
      items: const [
        DropdownMenuItem(value: 'gender', child: Text('Gender', style: TextStyle(color:
                                      Color.fromARGB(255, 103, 102, 103),))),
        DropdownMenuItem(value: 'male', child: Text('Male')),
        DropdownMenuItem(value: 'female', child: Text('Female')),
      ],
      onChanged: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
    );
  }
}
