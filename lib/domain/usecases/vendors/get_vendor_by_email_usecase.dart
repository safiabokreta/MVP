import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class GetVendorByEmailUseCase {
  final VendorRepository vendorRepository;

  GetVendorByEmailUseCase({required this.vendorRepository});

  Future<Vendor> call(String email) async {
    return await vendorRepository.getVendorDetailsByEmail(email);
  }
}
