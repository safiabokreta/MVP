import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/data/models/vendor_model.dart';
import 'package:zefeffete/data/models/venue_owner_model.dart';
import 'package:zefeffete/domain/entities/account.dart';
import 'package:zefeffete/presentation/controllers/user_account_controller.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller.dart';
import 'package:zefeffete/presentation/controllers/venue_owner.dart';
import 'package:zefeffete/presentation/controllers/wedding_owner_controller.dart';

import '../../data/models/wedding_owner_model.dart';

class SignupController {
  final AccountController accountcontroller;
  final WeddingOwnerController weddingOwnerController;
  final VenueOwnerController venueOwnerController;
  final VendorController vendorController;

  SignupController({
    required this.accountcontroller,
    required this.weddingOwnerController,
    required this.venueOwnerController,
    required this.vendorController,
  });
  Future<String> signup({
    required String email,
    required String password,
    required String username,
    String? profilePicture,
    String? theme,
    required String role,
  }) async {
    try {
      final account = Account(
        email: email,
        password: password,
        username: username,
        profilePicture: profilePicture,
        theme: theme,
        role: role,
      );
      await accountcontroller.addUser(account);
      try {
        if (role == 'wedding_owner') {
          final weddingOwnerModel = WeddingOwnerModel(
            email: email,
            weddingDate: null,
          );
          await weddingOwnerController.addWeddingOwner(weddingOwnerModel);
        } else if (role == 'venue_owner') {
          final venueOwnerModel = VenueOwnerModel(
            email: email,
            gender: null,
            phoneNumber: null,
          );
          await venueOwnerController.addVenueOwner(venueOwnerModel);
        } else if (role == 'vendor') {
          final vendorModel = VendorModel(
            email: email,
            phoneNumber: null,
            city: null,
            wilaya: null,
            gender: null,
            about: null,
            category: 'category',
            priceMin: 0.0,
            priceMax: 0.0,
            pricingDetails: '',
          );
          await vendorController.addVendor(vendorModel);
        } else {
          print("Error: Unknown role: $role");
        }
        await SharedPreferencesManager().setLoginStatus(
          true,
          email,
          role,
          username,
        );
        await SharedPreferencesManager().setActivated("NotActivated");
      } catch (e) {
        print("Error in usecase: ${e.toString()}");
        throw Exception("Registration failed: ${e.toString()}");
      }
      return "Signup successful";
    } catch (e) {
      return "Signup failed: ${e.toString()}";
    }
  }
}
