import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocationSelection extends StatefulWidget {
  final Function(Map<String, List<String>>) onLocationChanged;

  const LocationSelection({super.key, required this.onLocationChanged});

  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  Map<String, List<String>> wilayas = {}; // Holds Wilaya to Communes mapping
  String? selectedWilaya; // Currently selected Wilaya
  final Map<String, List<String>> selectedCommunes =
      {}; // Holds selected communes for each Wilaya

  @override
  void initState() {
    super.initState();
    _loadWilayaData();
  }

  Future<void> _loadWilayaData() async {
    final String jsonString =
        await rootBundle.loadString('assets/wilayas.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      wilayas = jsonData.map((key, value) {
        return MapEntry(key, List<String>.from(value));
      });
    });
  }

  // Function to toggle the selection of all communes
  void _toggleSelectAll(String wilaya) {
    setState(() {
      if (selectedCommunes[wilaya]?.length == wilayas[wilaya]?.length) {
        // If all communes are selected, deselect them
        selectedCommunes[wilaya]?.clear();
      } else {
        // If not all are selected, select all
        selectedCommunes[wilaya] = List.from(wilayas[wilaya]!);
      }
    });
    _updateSelectedLocations(); // Update the parent with the new selected locations
  }

  // Function to update the parent with selected locations (now a map)
  void _updateSelectedLocations() {
    // Remove any wilayas that have no communes selected
    selectedCommunes.removeWhere((key, value) => value.isEmpty);
    widget.onLocationChanged(
        selectedCommunes); // Notify parent with selected locations map
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: wilayas.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader until data is loaded
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  isExpanded: true,
                  value: null, // Ensure placeholder is always shown
                  hint: const Text('Add Wilaya'),
                  items: wilayas.keys.map((String wilaya) {
                    return DropdownMenuItem<String>(
                      value: wilaya,
                      child: Text(wilaya),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWilaya = value;
                      // Add selected Wilaya to the selectedCommunes map if not already present
                      if (!selectedCommunes.containsKey(value)) {
                        selectedCommunes[value!] = [];
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Communes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200, // Set a fixed height for the ListView
                  child: ListView(
                    children: selectedCommunes.entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key), // Wilaya name
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedCommunes
                                        .remove(entry.key); // Remove the Wilaya
                                  });
                                  _updateSelectedLocations(); // Update the parent with the change
                                },
                              ),
                            ],
                          ),
                          children: [
                            // "Select All" option
                            ListTile(
                              title: Text('Select All'),
                              trailing: Icon(
                                selectedCommunes[entry.key]?.length ==
                                        wilayas[entry.key]?.length
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: Colors.pink, // Set the color to pink
                              ),
                              onTap: () {
                                _toggleSelectAll(entry
                                    .key); // Toggle the selection of all communes
                              },
                            ),
                            // List of individual communes
                            ...wilayas[entry.key]!.map((commune) {
                              return CheckboxListTile(
                                title: Text(commune),
                                value: entry.value.contains(commune),
                                activeColor:
                                    Colors.pink, // Set checkbox color to pink
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      entry.value.add(
                                          commune); // Add commune to selected list
                                    } else {
                                      entry.value.remove(
                                          commune); // Remove commune from selected list
                                    }
                                  });
                                  _updateSelectedLocations(); // Update the parent with the change
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
