import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class GetPhotographersUseCase {
  final VendorRepository vendorRepository;

  GetPhotographersUseCase(this.vendorRepository);

  Future<List<Vendor>> call() async {
    return await vendorRepository.getVendorsByCategory("photographer");
  }
}
