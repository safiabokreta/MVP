import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class UnlikeVendorUseCase {
  final VendorRepository vendorRepository;

  UnlikeVendorUseCase(this.vendorRepository);

  Future<void> call(String vendorEmail) async {
    await vendorRepository.unlikeVendor(vendorEmail);
  }
}
