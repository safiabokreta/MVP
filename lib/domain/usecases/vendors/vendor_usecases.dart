import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/domain/repositories/vendor_rep.dart';

class VendorUseCases {
  final VendorRepository _repository;

  VendorUseCases(this._repository);

  Future<void> insertVendor(Vendor vendor) async {
    // Transform entity to model and pass to repository
    await _repository.insertVendor(vendor.toModel());
  }

  Future<void> activateVendor(String email, Vendor vendor) async {
       try {
      print("Account Usecase: Inserting account into repo...");
         await _repository.activateVendor(email, vendor.toModel());
      print("Account UseCase: Account inserted successfully.");
   
    } catch (e) {
      print("Error in usecase: ${e.toString()}");
      throw Exception("Registration failed: ${e.toString()}");
    }
    // Coordinate with use case to add a vendor

  }

  Future<Vendor?> getVendorByEmail(String email) async {
    // Fetch model from repository, transform to entity, and return
    final model = await _repository.getVendorByEmail(email);
    return model?.toEntity();
  }

  Future<void> deleteVendor(String email) async {
    // Call repository to delete
    await _repository.deleteVendor(email);
  }

  Future<void> saveimage(String vendorEmail, String imageUrl) async {
    
      await _repository.saveImage(vendorEmail, imageUrl);
    
  }
   Future<List<String>> fetchImages(String vendorEmail) async {
      try {
       
        return await _repository.fetchImages(vendorEmail);
        
      } catch (e) {
        print("Error saving images: $e");
      }
      return [];
    }
    Future<void> deleteImage(String vendorEmail, String image) async {
      
    
          await _repository.removeImages(vendorEmail ,image); 
       
    }
   Future<void> updateVendorAbout(String email, String about) async {
    await _repository.updateVendorAbout(email, about);
  }

  Future<void> updateVendorCategory(String email, String category) async {
    await _repository.updateVendorCategory(email, category);
  }
    Future<void> updateVendorGender(String email, String gender) async {
    await _repository.updateVendorGender(email, gender);
  }

  Future<void> updateVendorWilaya(String email, String wilaya) async {
    await _repository.updateVendorWilaya(email, wilaya);
  }  
  Future<void> updateVendorCity(String email, String city) async {
    await _repository.updateVendorCity(email, city);
  }

  Future<void> updateVendorPriceMax(String email, double price) async {
    await _repository.updateVendorPriceMax(email, price);
  } 
  Future<void> updateVendorPriceMin(String email, double price) async {
    await _repository.updateVendorPriceMin(email, price);
  }  
  Future<void> updateVendorPricingDetails(String email, String pricedetail) async {
    await _repository.updateVendorPricingDetails(email, pricedetail);
  }
  @override
  Future<bool?> getVendorIsActivated(String email) async {
    return await _repository.getVendorIsActivated(email);
}
Future<bool> setVendorIsActivated(String email, bool isActivated) async {
    return await _repository.setVendorIsActivated(email, isActivated);
}
}
