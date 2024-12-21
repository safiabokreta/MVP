import 'package:zefeffete/data/datasources/venue_owner_ds.dart';
import 'package:zefeffete/data/models/venue_owner_model.dart';
import 'package:zefeffete/domain/repositories/venue_owner_rep.dart';

class VenueOwnerRepositoryImpl implements VenueOwnerRepository {
  final VenueOwnerDataSource venueOwnerDataSource;

  // Constructor now accepts a data source
  VenueOwnerRepositoryImpl(this.venueOwnerDataSource); 
  
  @override
  Future<void> insertVenueOwner(VenueOwnerModel VenueOwnerModel) async {
    print("venue owner Repository: Adding venue_owner data...");
        await venueOwnerDataSource.insertVenueOwner(VenueOwnerModel);
  }


  @override
  Future<VenueOwnerModel?> getVenueOwnerByEmail(String email) async {
    return  await venueOwnerDataSource.getVenueOwnerByEmail(email);
  }

  @override
  Future<void> updateGender(String email, String gender) async {
      await venueOwnerDataSource.updateGender(email, gender);
    }
  @override
  Future<void> deleteVenueOwner(String email) async {
    // Placeholder for logic to delete a venue owner from the database by email
  }
}
