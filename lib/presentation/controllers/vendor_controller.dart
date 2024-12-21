import 'dart:convert';

import 'package:zefeffete/domain/usecases/vendors/vendor_usecases.dart';
import 'package:zefeffete/domain/entities/vendor.dart';

class VendorController {
  final VendorUseCases _useCases;

  VendorController(this._useCases);

  Future<void> addVendor(Vendor vendor) async {
    // Coordinate with use case to add a vendor
    await _useCases.insertVendor(vendor);
  }

  Future<void> activateVendor(String email, Vendor vendor) async {
    print("Vendor: Attempt at saving into vendor");

    await _useCases.activateVendor(email, vendor);
  }

  Future<Vendor?> getVendorByEmail(String email) async {
    // Coordinate with use case to fetch a vendor by email
    return await _useCases.getVendorByEmail(email);
  }

  Future<void> deleteVendor(String email) async {
    // Coordinate with use case to delete a vendor
    await _useCases.deleteVendor(email);
  }

  Future<void> saveVendorImages(String vendorEmail, String imageUrls) async {
    try {
      await _useCases.saveimage(vendorEmail, imageUrls);
      print("Images saved successfully!");
    } catch (e) {
      print("Error saving images: $e");
    }
  }

  Future<List<String>> fetchImages(String vendorEmail) async {
    try {
      final images = await _useCases.fetchImages(vendorEmail);
      print("Fetched images: $images"); // Debugging line
      return images ?? []; // Return an empty list if null
    } catch (e) {
      print("Error fetching images: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> updateVendorImages(
      String vendorEmail, List<String> newImages) async {
    List<String> existingImages = await fetchImages(vendorEmail);

    final imagesToAdd =
        newImages.where((image) => !existingImages.contains(image)).toList();

    // Perform batch addition
    for (String image in imagesToAdd) {
      await saveVendorImages(vendorEmail, image);
    }
  }

  Future<void> deleteVendorimage(
      String vendorEmail, List<String> imagesToDelete) async {
    try {
      for (String image in imagesToDelete) {
        await _useCases.deleteImage(vendorEmail, image);
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  Future<void> updateVendorAbout(String email, String about) async {
    await _useCases.updateVendorAbout(email, about);
  }

  Future<void> updateVendorCategory(String email, String category) async {
    await _useCases.updateVendorCategory(email, category);
  }

  Future<void> updateVendorGender(String email, String gender) async {
    await _useCases.updateVendorGender(email, gender);
  }

  Future<void> updateVendorWilaya(String email, String wilaya) async {
    await _useCases.updateVendorWilaya(email, wilaya);
  }

  Future<void> updateVendorCity(String email, String city) async {
    await _useCases.updateVendorCity(email, city);
  }

  Future<void> updateVendorPriceMax(String email, double price) async {
    await _useCases.updateVendorPriceMax(email, price);
  }

  Future<void> updateVendorPriceMin(String email, double price) async {
    await _useCases.updateVendorPriceMin(email, price);
  }

  Future<void> updateVendorPricingDetails(
      String email, String pricedetail) async {
    await _useCases.updateVendorPricingDetails(email, pricedetail);
  }

  Future<bool?> getVendorIsActivated(String email) async {
    return await _useCases.getVendorIsActivated(email);
  }

  Future<bool> setVendorIsActivated(String email, bool isActivated) async {
    return await _useCases.setVendorIsActivated(email, isActivated);
  }
}
