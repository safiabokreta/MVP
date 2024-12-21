import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Wilayadropdown extends StatefulWidget {
  final String initialSelection;
  final String selectedWilaya;

   const Wilayadropdown({
    super.key,
    required this.selectedWilaya,
    required this.initialSelection,
  });

  @override
  WilayadropdownState createState() => WilayadropdownState();
}

class WilayadropdownState extends State<Wilayadropdown> {
  String selectedWilaya = '';

  @override
  void initState() {
    super.initState();
    selectedWilaya = widget.initialSelection.isNotEmpty ? widget.initialSelection : 'wilaya';
  }

  // Method to get the selected wilaya
  String getSelectedWilaya() {
    return selectedWilaya;
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
                                labelText: 'Wilaya',
                                labelStyle: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 103, 102, 103),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(92, 255, 207, 247),
                              ),
      value: selectedWilaya,
      items: const [
        DropdownMenuItem(value: 'wilaya', child: Text('Wilaya', style: TextStyle(color:
                                      Color.fromARGB(255, 103, 102, 103),))),
        DropdownMenuItem(value: 'algiers', child: Text('Algiers')),
        DropdownMenuItem(value: 'oran', child: Text('Oran')),
        DropdownMenuItem(value: 'constantine', child: Text('Constantine')),
        DropdownMenuItem(value: 'setif', child: Text('Setif')),
        DropdownMenuItem(value: 'bejaia', child: Text('Bejaia')),
        DropdownMenuItem(value: 'jijel', child: Text('Jijel')),
        DropdownMenuItem(value: 'mostaganem', child: Text('Mostaganem')),
        DropdownMenuItem(value: 'annaba', child: Text('Annaba')),
        DropdownMenuItem(value: 'batna', child: Text('Batna')),


      ],
      onChanged: (value) {
        setState(() {
          selectedWilaya = value!;
        });
      },
    );
  }
}
