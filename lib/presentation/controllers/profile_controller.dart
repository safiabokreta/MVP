import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart'; // For AlertDialog
import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/data/models/vendor_model.dart';
import 'package:zefeffete/domain/entities/account.dart';
import 'package:zefeffete/presentation/controllers/user_account_controller.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller.dart';
import 'package:zefeffete/presentation/controllers/venue_owner.dart';
import 'package:zefeffete/presentation/controllers/wedding_owner_controller.dart';

class ProfileController {
  final AccountController accountController;
  final VendorController vendorController;
  final WeddingOwnerController weddingOwnerController;
  final VenueOwnerController venueOwnerController;

  ProfileController({
    required this.accountController,
    required this.vendorController,
    required this.weddingOwnerController,
    required this.venueOwnerController,
  });

  Future<void> saveProfileImageLocally(String email, File image) async {
    try {
      await accountController.updateProfileImage(email, image);
      await SharedPreferencesManager().setProfileImage(image.path);
    } catch (e) {}
  }

  Future<String> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      print("User profile updated called");
      if (updatedData.containsKey('username')) {
        print("User profile contains username");
        await accountController.updateUsername(
            updatedData['email'], updatedData['username']);
        await SharedPreferencesManager().setUsername(updatedData['username']);
        print("Username updated ");
      }

      if (updatedData['role'] == 'vendor') {
        bool isActivated = updatedData['activated'] == "Activated";
        print("Activated: ");
        print(isActivated);

        if (isActivated) {
          if (updatedData.containsKey('about')) {
            print(
                "db is activated trying to save about from profile controller");
            await vendorController.updateVendorAbout(
                updatedData['email'], updatedData['about']);
          }
          if (updatedData.containsKey('category')) {
            print(
                "db is activated trying to save category from profile controller");

            await vendorController.updateVendorCategory(
                updatedData['email'], updatedData['category']);
          }
          if (updatedData.containsKey('gender')) {
            print(
                "db is activated trying to save gender from profile controller");

            await vendorController.updateVendorGender(
                updatedData['email'], updatedData['gender']);
          }
          if (updatedData.containsKey('wilaya')) {
            print(
                "db is activated trying to save wilaya from profile controller");

            await vendorController.updateVendorWilaya(
                updatedData['email'], updatedData['wilaya']);
          }
          if (updatedData.containsKey('city')) {
            print(
                "db is activated trying to save city from profile controller");

            await vendorController.updateVendorCity(
                updatedData['email'], updatedData['city']);
          }
          if (updatedData.containsKey('price_max')) {
            print(
                "db is activated trying to save price_max from profile controller");

            double priceMax = updatedData['price_max'] is double
                ? updatedData['price_max']
                : double.tryParse(updatedData['price_max'].toString()) ?? 0.0;

            // Ensure it's a valid double before updating
            await vendorController.updateVendorPriceMax(
                updatedData['email'], priceMax);
          }
          if (updatedData.containsKey('price_min')) {
            print(
                "db is activated trying to save price_min from profile controller");

            double priceMin = updatedData['price_min'] is double
                ? updatedData['price_min']
                : double.tryParse(updatedData['price_min'].toString()) ?? 0.0;

            // Ensure it's a valid double before updating
            await vendorController.updateVendorPriceMin(
                updatedData['email'], priceMin);
          }

          if (updatedData.containsKey('pricing_details')) {
            print(
                "db is activated trying to save pricing_details from profile controller");

            await vendorController.updateVendorPricingDetails(
                updatedData['email'], updatedData['pricing_details']);
          }
          if (updatedData.containsKey('images')) {
            final email = updatedData['email'];
            final List<String> updatedImages =
                List<String>.from(updatedData['images']);
            await vendorController.updateVendorImages(email, updatedImages);
          }
          if (updatedData.containsKey('tobedeleted')) {
            final email = updatedData['email'];
            final List<String> deletedimages =
                List<String>.from(updatedData['tobedeleted']);
            await vendorController.deleteVendorimage(email, deletedimages);
          }
          return "Success";
        } else if (isActivated == false && updatedData['showVendor'] == true) {
          print("Profile: Attempt at saving into vendor from not activated");

          if (updatedData['activated'] != "Activated") {
            isActivated = true;
          }
          VendorModel vendorModel = VendorModel(
            email: updatedData['email'],
            city: updatedData['city'],
            wilaya: updatedData['wilaya'],
            gender: updatedData['gender'],
            about: updatedData['about'],
            category: updatedData['category'],
            priceMin: updatedData['price_min'] is double
                ? updatedData['price_min']
                : double.tryParse(updatedData['price_min'].toString()) ?? 0.0,
            priceMax: updatedData['price_max'] is double
                ? updatedData['price_max']
                : double.tryParse(updatedData['price_max'].toString()) ?? 0.0,
            pricingDetails: updatedData['pricing_details'],
            activated: isActivated ?? true,
          );
          print("Profile: Attempt at saving into vendor");
          await vendorController.activateVendor(
              updatedData['email'], vendorModel.toEntity());
          print("Attempting to save the pictures");

          final email = updatedData['email'];
          final List<String> updatedImages =
              List<String>.from(updatedData['images']);
          await vendorController.updateVendorImages(email, updatedImages);
          print("Profile: Attempt at saving into vendor successful");
          await SharedPreferencesManager().setActivated("Activated");
          return "Success";
        } else if (updatedData['showVendor'] == false) {
          return "Success";
        }
      }

      return "Update failed";
    } catch (e) {
      print("Error saving profile from controller: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      print("Get user profile called ");

      // Retrieve user details from SharedPreferences
      String? email = await SharedPreferencesManager().getEmail();
      String? role = await SharedPreferencesManager().getRole();
      String? username = await SharedPreferencesManager().getUsername();

      if (email == null || role == null || username == null) {
        throw Exception('Missing required information (email, role, username)');
      }

      // Retrieve the account details
      Account account =
          await accountController.getUserByEmail(email) as Account;
      print(
          "Get user profile called on account of ${account.email}: ${account.username}");

      // Role-specific profile fetching
      if (role == 'wedding_owner') {
        var weddingOwner =
            await weddingOwnerController.getWeddingOwnerByEmail(email);
        return {
          'username': username,
          'email': email,
          'role': role,
          'profilePicture': account.profilePicture,
          'wedding_date': weddingOwner?.weddingDate ?? 'Unknown Date',
        };
      } else if (role == 'venue_owner') {
        var venueOwner = await venueOwnerController.getVenueOwnerByEmail(email);
        return {
          'username': username,
          'email': email,
          'role': role,
          'profilePicture': account.profilePicture,
          'phone_number': venueOwner?.phoneNumber ?? '',
        };
      } else if (role == 'vendor') {
        print("Role is Vendor: ${account.email}: ${account.username}");

        // Fetch vendor details
        var vendor = await vendorController.getVendorByEmail(email);

        // Fetch images and wait for the result
        List<String> images = await vendorController.fetchImages(account.email);

        return {
          'username': username,
          'email': email,
          'role': role,
          'profilePicture': account.profilePicture,
          'phone_number': vendor?.phoneNumber ?? '',
          'wilaya': vendor?.wilaya ?? 'wilaya',
          'city': vendor?.city ?? 'city',
          'price_min': vendor?.priceMin ?? 0.0,
          'price_max': vendor?.priceMax ?? 0.0,
          'pricing_details': vendor?.pricingDetails ?? '',
          'category': vendor?.category ?? 'category',
          'gender': vendor?.gender ?? 'gender',
          'about': vendor?.about ?? '',
          'activated': vendor?.activated ?? false,
          'images': images ?? [],
        };
      } else {
        throw Exception('Unknown role: $role');
      }
    } catch (e) {
      print('Error fetching user profile: ${e.toString()}');
      throw Exception('Error fetching user profile: ${e.toString()}');
    }
  }
}
