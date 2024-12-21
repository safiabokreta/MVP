import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class IsVendorLikedUseCase {
  final VendorRepository vendorRepository;

  IsVendorLikedUseCase(this.vendorRepository);

  Future<bool> call(String vendorEmail) async {
    return await vendorRepository.isVendorLiked(vendorEmail);
  }
}
