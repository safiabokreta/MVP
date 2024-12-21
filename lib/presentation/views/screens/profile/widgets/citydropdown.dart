import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CityDropDown extends StatefulWidget {
  final String initialSelectioncity;
  final String selectedCity;

   const CityDropDown({
    super.key,
    required this.selectedCity,
    required this.initialSelectioncity,
  });

  @override
  CityDropDownState createState() => CityDropDownState();
}

class CityDropDownState extends State<CityDropDown> {
  String selectedCity = '';

  @override
  void initState() {
    super.initState();
    selectedCity = widget.initialSelectioncity.isNotEmpty ? widget.initialSelectioncity : 'city';
  }

  // Method to get the selected City
  String getSelectedCity() {
    return selectedCity;
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
                                labelText: 'City',
                                labelStyle: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 103, 102, 103),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(92, 255, 207, 247),
                              ),
                              value: selectedCity,
                              items: const [
                                DropdownMenuItem(value: 'city', child: Text('City', style: TextStyle(color:
                                                              Color.fromARGB(255, 103, 102, 103),))),
                                DropdownMenuItem(value: 'algiers', child: Text('Algiers')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedCity = value!;
                                });
      },
    );
  }
}
