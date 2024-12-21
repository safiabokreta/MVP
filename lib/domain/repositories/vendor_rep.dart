import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/data/models/vendor_model.dart';

abstract class VendorRepository {
  Future<List<Vendor>> getVendorsByCategory(String category);
  Future<Vendor> getVendorDetailsByEmail(String email);
  Future<void> likeVendor(String vendorId);
  Future<void> unlikeVendor(String vendorId);
  Future<bool> isVendorLiked(String vendorId);
  Future<List<Vendor>> getFilteredVendors({
    required String category,
    double? minPrice,
    double? maxPrice,
    String? gender,
    double? minRating,
    Map<String, List<String>>? selectedLocations,
  });

  Future<void> insertVendor(VendorModel vendorModel);
  Future<VendorModel?> getVendorByEmail(String email);
  Future<void> updateVendor(VendorModel vendorModel);
  Future<void> deleteVendor(String email);
  Future<void> updateVendorAbout(String email, String about);
  Future<void> updateVendorCategory(String email, String category);
  Future<void> updateVendorGender(String email, String gender);
  Future<void> updateVendorWilaya(String email, String wilaya);
  Future<void> updateVendorCity(String email, String city);
  Future<void> updateVendorPriceMax(String email, double price);
  Future<void> updateVendorPriceMin(String email, double price);
  Future<void> updateVendorPricingDetails(String email, String pricedetail);
  Future<bool?> getVendorIsActivated(String email);
  Future<bool> setVendorIsActivated(String email, bool isActivated);
  Future<void> activateVendor(String email, VendorModel vendor);
  Future<void> saveImage(String vendorEmail, String imageUrl);
  Future<List<String>> fetchImages(String vendorEmail);
  Future<void> removeImages(String vendorEmail, String imageUrl);
}
