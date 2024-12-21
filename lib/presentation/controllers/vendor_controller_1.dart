import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/domain/usecases/vendors/get_photographers_use_case.dart';
import 'package:zefeffete/domain/usecases/vendors/like_vendor_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/unlike_vendor_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/is_vendor_liked_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/get_vendor_by_email_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/get_filtered_vendors_usecase.dart';

class VendorController {
  final GetPhotographersUseCase getPhotographersUseCase;
  final LikeVendorUseCase likeVendorUseCase;
  final UnlikeVendorUseCase unlikeVendorUseCase;
  final IsVendorLikedUseCase isVendorLikedUseCase;
  final GetVendorByEmailUseCase getVendorByEmailUseCase;
  final GetFilteredVendorsUseCase getFilteredVendorsUseCase;

  VendorController({
    // Optional parameter
    required this.getPhotographersUseCase,
    required this.likeVendorUseCase,
    required this.unlikeVendorUseCase,
    required this.isVendorLikedUseCase,
    required this.getVendorByEmailUseCase,
    required this.getFilteredVendorsUseCase,
  });

  Future<List<Vendor>> getPhotographers() async {
    return await getPhotographersUseCase();
  }

  Future<void> likeVendor(String vendorEmail) async {
    await likeVendorUseCase(vendorEmail);
  }

  Future<void> unlikeVendor(String vendorEmail) async {
    await unlikeVendorUseCase(vendorEmail);
  }

  Future<bool> isVendorLiked(String vendorEmail) async {
    return await isVendorLikedUseCase(vendorEmail);
  }

  Future<Vendor> getVendorByEmail(String email) async {
    return await getVendorByEmailUseCase(email);
  }

  Future<List<Vendor>> getFilteredVendors({
    required String category,
    double? minPrice,
    double? maxPrice,
    String? gender,
    double? rating,
    Map<String, List<String>>? selectedLocations,
  }) async {
    return await getFilteredVendorsUseCase(
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      gender: gender,
      minRating: rating,
      selectedLocations: selectedLocations,
    );
  }
}
