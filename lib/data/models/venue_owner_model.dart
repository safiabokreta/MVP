import 'package:zefeffete/domain/entities/venueOwner.dart';

class VenueOwnerModel extends VenueOwner {
  VenueOwnerModel({
    required super.email,
    super.gender,
    super.phoneNumber,
  });

  // Convert Model to Entity
  VenueOwner toEntity() {
    return VenueOwner(
      email: email,
      gender: gender,
      phoneNumber: phoneNumber,
    );
  }

  // Convert to Map for storing in database
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'gender': gender,
      'phone_number': phoneNumber,
    };
  }

  // Convert from Map (for retrieving from database)
  static VenueOwnerModel fromMap(Map<String, dynamic> map) {
    return VenueOwnerModel(
      email: map['email'],
      gender: map['gender'],
      phoneNumber: map['phone_number'],
    );
  }
}
