import 'package:zefeffete/data/datasources/vendor_ds.dart';
import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/domain/repositories/vendor_rep.dart';
import 'package:zefeffete/data/models/vendor_model.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorDataSource vendorDataSource;

  VendorRepositoryImpl(this.vendorDataSource);

  @override
  Future<List<Vendor>> getVendorsByCategory(String category) async {
    final vendorModels = await vendorDataSource.getVendorsByCategory(category);
    return vendorModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Vendor> getVendorDetailsByEmail(String email) async {
    return await vendorDataSource.getVendorDetailsByEmail(email);
  }

  @override
  Future<void> likeVendor(String vendorEmail) async {
    await vendorDataSource.likeVendor(vendorEmail);
  }

  @override
  Future<void> unlikeVendor(String vendorEmail) async {
    await vendorDataSource.unlikeVendor(vendorEmail);
  }

  @override
  Future<bool> isVendorLiked(String vendorEmail) async {
    return await vendorDataSource.isVendorLiked(vendorEmail);
  }

  @override
  Future<List<Vendor>> getFilteredVendors({
    required String category,
    double? minPrice,
    double? maxPrice,
    String? gender,
    double? minRating,
    Map<String, List<String>>? selectedLocations,
  }) async {
    final vendorModels = await vendorDataSource.getFilteredVendors(
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      gender: gender,
      minRating: minRating,
      selectedLocations: selectedLocations,
    );
    return vendorModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> insertVendor(VendorModel vendorModel) async {
    print("vendor Repository: Adding vendor  data...");
    await vendorDataSource.insertVendor(vendorModel);
  }

  Future<void> activateVendor(String email, VendorModel vendor) async {
    try {
      print("Account repo: Inserting account into repo...");
      await vendorDataSource.activateVendor(email, vendor);
      print("Account repo: Account inserted successfully.");
    } catch (e) {
      print("Error in repo: ${e.toString()}");
      throw Exception("Registration failed: ${e.toString()}");
    }
    // Coordinate with use case to add a vendor
  }

  Future<void> saveImage(String vendorEmail, String imageUrl) async {
    await vendorDataSource.insertImage(vendorEmail, imageUrl);
  }

  @override
  Future<List<String>> fetchImages(String vendorEmail) async {
    return await vendorDataSource.getImagesByVendorEmail(vendorEmail);
  }

  Future<void> removeImages(String vendorEmail, String imageUrl) async {
    await vendorDataSource.deleteImagesByVendorEmail(vendorEmail, imageUrl);
  }

  @override
  Future<VendorModel?> getVendorByEmail(String email) async {
    return await vendorDataSource.getVendorByEmail(email);
    // Placeholder for logic to fetch a vendor by email
  }

  @override
  Future<void> updateVendorAbout(String email, String about) async {
    await vendorDataSource.updateVendorAbout(email, about);
  }

  @override
  Future<void> updateVendorCategory(String email, String category) async {
    await vendorDataSource.updateVendorCategory(email, category);
  }

  @override
  Future<void> updateVendorGender(String email, String gender) async {
    await vendorDataSource.updateVendorGender(email, gender);
  }

  @override
  Future<void> updateVendorWilaya(String email, String wilaya) async {
    await vendorDataSource.updateVendorWilaya(email, wilaya);
  }

  @override
  Future<void> updateVendorCity(String email, String city) async {
    await vendorDataSource.updateVendorCity(email, city);
  }

  @override
  Future<void> updateVendorPriceMax(String email, double price) async {
    await vendorDataSource.updateVendorPriceMax(email, price);
  }

  @override
  Future<void> updateVendorPriceMin(String email, double price) async {
    await vendorDataSource.updateVendorPriceMin(email, price);
  }

  @override
  Future<void> updateVendorPricingDetails(
      String email, String pricedetail) async {
    await vendorDataSource.updateVendorPricingDetails(email, pricedetail);
  }

  @override
  Future<bool> setVendorIsActivated(String email, bool isActivated) async {
    return await vendorDataSource.setVendorIsActivated(email, isActivated);
  }

  @override
  Future<void> deleteVendor(String email) {
    // TODO: implement deleteVendor
    throw UnimplementedError();
  }

  Future<bool?> getVendorIsActivated(String email) async {
    return await vendorDataSource.getVendorIsActivated(email);
  }

  @override
  Future<void> updateVendor(VendorModel vendorModel) {
    // TODO: implement updateVendor
    throw UnimplementedError();
  }
}
