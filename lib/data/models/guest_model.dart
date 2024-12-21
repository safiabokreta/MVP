import 'package:zefeffete/domain/entities/guest.dart';

class GuestModel extends Guest {
  GuestModel({
    String? weddingOwnerEmail,
    String? name,
    String? gender,
    String? side,
    int numWomen = 0,
    int numMen = 0,
    int numKids = 0,
    int? guestId, // Optional since it's auto-incremented
  }) : super(
          guestId: guestId ?? 0,
          weddingOwnerEmail: weddingOwnerEmail ?? '',
          name: name,
          gender: gender,
          side: side,
          numWomen: numWomen,
          numMen: numMen,
          numKids: numKids,
        );

  // Convert Model to Entity
  Guest toEntity() {
    return Guest(
      guestId: guestId,
      weddingOwnerEmail: weddingOwnerEmail,
      name: name,
      gender: gender,
      side: side,
      numWomen: numWomen,
      numMen: numMen,
      numKids: numKids,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'wedding_owner_email': weddingOwnerEmail,
      'name': name,
      'gender': gender,
      'side': side,
      'num_women': numWomen,
      'num_men': numMen,
      'num_kids': numKids,
    };
    if (guestId != null) {
      map['guest_id'] = guestId; // Include only if ID is present
    }
    return map;
  }

  static GuestModel fromMap(Map<String, dynamic> map) {
    return GuestModel(
      guestId: map['guest_id'],
      weddingOwnerEmail: map['wedding_owner_email'],
      name: map['name'],
      gender: map['gender'],
      side: map['side'],
      numWomen: map['num_women'],
      numMen: map['num_men'],
      numKids: map['num_kids'],
    );
  }
}
