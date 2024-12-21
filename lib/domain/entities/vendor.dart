import 'package:zefeffete/data/models/vendor_model.dart';

class Vendor {
  final String email;
  final String? username;
  final String? phoneNumber;
  final String? city;
  final String? wilaya;
  final String? gender;
  final String? about;
  final double? priceMin;
  final double? priceMax;
  final String? pricingDetails;
  final String? profilePicture;
  final List<String>? images;
  final bool activated;
  final String? category;
  final double? averageRating;
  final int? totalReviews;
  final List<int>? starPercentages;

  Vendor(
      {required this.email,
      this.username,
      this.phoneNumber,
      this.city,
      this.wilaya,
      this.gender,
      this.about,
      this.profilePicture,
      this.images,
      required this.priceMin,
      required this.priceMax,
      required this.pricingDetails,
      this.activated = false,
      this.averageRating,
      this.totalReviews,
      this.starPercentages,
      this.category});

  VendorModel toModel() {
    return VendorModel(
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      city: city,
      wilaya: wilaya,
      gender: gender,
      about: about,
      priceMin: priceMin,
      priceMax: priceMax,
      pricingDetails: pricingDetails,
      activated: activated,
      profilePicture: profilePicture,
      images: images,
      averageRating: averageRating,
      totalReviews: totalReviews,
      starPercentages: starPercentages,
      category: category,
    );
  }
}
