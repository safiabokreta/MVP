import 'package:flutter/material.dart';
import 'package:zefeffete/domain/entities/vendor.dart'; // Assuming this is the correct path
import 'PhotosGrid.dart';

class VendorDetailsMain extends StatelessWidget {
  final Vendor vendorData; // Now using Vendor entity

  const VendorDetailsMain({required this.vendorData, super.key});

  @override
  Widget build(BuildContext context) {
    return VendorDetails(vendor: vendorData); // Passing Vendor entity
  }
}

class VendorDetails extends StatelessWidget {
  final Vendor vendor; // Now using Vendor entity

  const VendorDetails({required this.vendor, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this vendor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            vendor.about ??
                'No description available', // Use vendor's about field
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pricing Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            vendor.pricingDetails ??
                'No pricing details available', // Simple text field
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            'Photos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Using vendor's image URLs
          PhotosGrid(
              images:
                  vendor.images ?? []), // If images is null, pass empty list
        ],
      ),
    );
  }
}
