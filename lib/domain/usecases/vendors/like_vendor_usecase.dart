import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class LikeVendorUseCase {
  final VendorRepository vendorRepository;

  LikeVendorUseCase(this.vendorRepository);

  Future<void> call(String vendorEmail) async {
    await vendorRepository.likeVendor(vendorEmail);
  }
}
