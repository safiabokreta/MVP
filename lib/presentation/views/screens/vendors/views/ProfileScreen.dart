import 'package:flutter/material.dart';
import 'package:zefeffete/domain/entities/vendor.dart'; // Assuming VendorModel is the entity used here
import '../widgets/ProfileImage.dart';
import '../widgets/ProfileDetails.dart';
import '../widgets/LeaveReviewButton.dart';
import '../widgets/ReviewsWidget.dart';
import '../widgets/VendorDetailsMain.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller_1.dart'; // Import the VendorController

class ProfileScreen extends StatelessWidget {
  final String vendorEmail;
  final VendorController vendorController;

  const ProfileScreen({
    required this.vendorEmail,
    required this.vendorController,
    super.key,
  });

  Future<Vendor> _loadVendorData() async {
    try {
      return await vendorController.getVendorByEmail(vendorEmail);
    } catch (error) {
      throw Exception('Failed to load vendor data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<Vendor>(
        future: _loadVendorData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final vendorData = snapshot.data!;

            // Get the ratings data from the vendor object
            final averageRating = vendorData.averageRating ?? 0.0;
            final totalReviews = vendorData.totalReviews ?? 0;
            final starPercentages =
                vendorData.starPercentages ?? [0, 0, 0, 0, 0];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileImage(
                    imageUrl:
                        vendorData.profilePicture ?? 'default_image_url_here',
                  ),
                  const SizedBox(height: 16),
                  ProfileDetails(
                    name: vendorData.username ?? 'Unknown',
                    phone: vendorData.phoneNumber ?? 'Not provided',
                    location: '${vendorData.city}, ${vendorData.wilaya}',
                  ),
                  LeaveReviewButton(
                    vendorEmail: vendorEmail,
                  ),
                  ReviewsWidget(
                    averageRating:
                        averageRating, // Actual average rating from vendor data
                    totalReviews:
                        totalReviews, // Actual total reviews from vendor data
                    starPercentages: starPercentages.reversed
                        .toList(), // Actual star percentages from vendor data
                  ),
                  VendorDetailsMain(vendorData: vendorData),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
