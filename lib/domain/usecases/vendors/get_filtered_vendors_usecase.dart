import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class GetFilteredVendorsUseCase {
  final VendorRepository vendorRepository;

  GetFilteredVendorsUseCase({required this.vendorRepository});

  Future<List<Vendor>> call({
    required String category,
    double? minPrice,
    double? maxPrice,
    String? gender,
    double? minRating,
    Map<String, List<String>>? selectedLocations,
  }) async {
    return await vendorRepository.getFilteredVendors(
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      gender: gender,
      minRating: minRating,
      selectedLocations: selectedLocations,
    );
  }
}
