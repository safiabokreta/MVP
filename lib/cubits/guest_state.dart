// guest_state.dart
import 'package:zefeffete/data/models/guest_model.dart';

// Define an abstract base class for all guest-related states
abstract class GuestState {}

// Initial state: when the GuestCubit is first created
class GuestInitial extends GuestState {}

// State when data is being fetched (for example, when making an API call)
class GuestLoading extends GuestState {}

// State when the guests are successfully loaded from the data source
class GuestLoaded extends GuestState {
  final List<GuestModel> guests;

  GuestLoaded(this.guests);  // Pass the loaded guests list
}

// State when there is an error during the data loading or guest addition
class GuestError extends GuestState {
  final String errorMessage;

  GuestError(this.errorMessage);  // Pass the error message
}

// State when a guest is successfully added
class GuestAddedSuccess extends GuestState {}

// State when a guest is successfully updated
class GuestUpdatedSuccess extends GuestState {
  final GuestModel updatedGuest;

  GuestUpdatedSuccess(this.updatedGuest);
}

// State when a guest is successfully deleted
class GuestDeletedSuccess extends GuestState {
  final int deletedGuestId;

  GuestDeletedSuccess(this.deletedGuestId);
}