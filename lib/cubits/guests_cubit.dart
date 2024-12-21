import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/data/datasources/guest_ds.dart';
import 'package:zefeffete/data/models/guest_model.dart';
import 'guest_state.dart';

class GuestCubit extends Cubit<GuestState> {
  GuestCubit() : super(GuestInitial());

  // Load guests based on wedding owner's email
  Future<void> loadGuests(String email) async {
    try {
      emit(GuestLoading());
      final guestsMaps = await GuestDataSource.getGuestsByWeddingOwner(email);
      final guests = guestsMaps.map((guestMap) => GuestModel.fromMap(guestMap)).toList();
      emit(GuestLoaded(guests));
    } catch (e) {
      emit(GuestError('Failed to load guests: $e'));
    }
  }

  // Add a new guest
  Future<void> addGuest(Map<String, dynamic> guestData) async {
    try {
      await GuestDataSource.addGuest(guestData);
      emit(GuestAddedSuccess());
    } catch (e) {
      emit(GuestError('Failed to add guest: $e'));
    }
  }

  // Update an existing guest
  Future<void> updateGuest(GuestModel updatedGuest) async {
    try {
      await GuestDataSource.updateGuest(updatedGuest.guestId, updatedGuest.toMap());
      emit(GuestUpdatedSuccess(updatedGuest));
      await loadGuests(updatedGuest.weddingOwnerEmail ?? "");
    } catch (error) {
      emit(GuestError('Failed to update guest: $error'));
    }
  }

  // Delete a guest
  Future<void> deleteGuest(int guestId, String weddingOwnerEmail) async {
    try {
      await GuestDataSource.deleteGuest(guestId);
      emit(GuestDeletedSuccess(guestId));
      await loadGuests(weddingOwnerEmail);
    } catch (error) {
      emit(GuestError('Failed to delete guest: $error'));
    }
  }
}

// guest_model.dart
// No changes needed
