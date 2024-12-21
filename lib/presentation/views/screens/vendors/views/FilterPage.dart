import 'package:flutter/material.dart';
import 'package:zefeffete/presentation/views/screens/vendors/views/Vendors.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/ClearApply.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/GenderSelection.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/LocationSelection.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/PriceInputs.dart';
import 'package:zefeffete/presentation/views/screens/vendors/widgets/ReviewRatings.dart';

class FilterPage extends StatefulWidget {
  final String category;

  const FilterPage({
    super.key,
    required this.category,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double? _minPrice;
  double? _maxPrice;
  String? _selectedGender = 'All';
  String? _selectedRating = '4.5 and above';
  Map<String, List<String>> _selectedLocations = {};

  void _onClear() {
    setState(() {
      _minPrice = null;
      _maxPrice = null;
      _selectedGender = null;
      _selectedRating = null;
      _selectedLocations.clear();
    });
  }

  void _onApply() {
    print("Category: ${widget.category}");
    print("Price: $_minPrice - $_maxPrice");
    print("Gender: $_selectedGender");
    print("Rating: $_selectedRating");
    print("Locations: $_selectedLocations");

    if (widget.category == 'photographers') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VendorsPage(
            useCustomFilter: true,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            gender: _selectedGender,
            rating: _selectedRating,
            locations: _selectedLocations,
          ),
        ),
      );
    } else {
      // TODO: HANDLE OTHER PAGES
    }
  }

  void _onLocationChanged(Map<String, List<String>> selectedLocations) {
    setState(() {
      _selectedLocations = selectedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text('Filter Options', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                PriceInputs(
                  onPriceChanged: (minPrice, maxPrice) {
                    setState(() {
                      _minPrice = minPrice;
                      _maxPrice = maxPrice;
                    });
                  },
                ),
                const SizedBox(height: 20),
                GenderSelection(
                  onGenderChanged: (selectedGender) {
                    setState(() {
                      _selectedGender = selectedGender;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ReviewRatings(
                  onRatingChanged: (selectedRating) {
                    setState(() {
                      _selectedRating = selectedRating;
                    });
                  },
                ),
                const SizedBox(height: 20),
                LocationSelection(onLocationChanged: _onLocationChanged),
                const SizedBox(height: 15),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: ClearApply(
                onClear: _onClear,
                onApply: _onApply,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
