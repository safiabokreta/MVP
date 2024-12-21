import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller_1.dart';

class PhotographersListState {
  final List<Vendor>? photographers;
  final String? errorMessage;
  final bool isLoading;

  PhotographersListState({
    this.photographers,
    this.errorMessage,
    this.isLoading = false,
  });
}

class PhotographersListCubit extends Cubit<PhotographersListState> {
  final VendorController vendorController;

  PhotographersListCubit({required this.vendorController})
      : super(PhotographersListState(isLoading: true));

  void fetchPhotographers({
    required bool useCustomFilter,
    double? minPrice,
    double? maxPrice,
    String? gender,
    double? rating,
    Map<String, List<String>>? locations,
  }) async {
    emit(PhotographersListState(isLoading: true));

    try {
      List<Vendor> photographers;
      if (useCustomFilter) {
        photographers = await vendorController.getFilteredVendors(
          category: "photographer",
          minPrice: minPrice,
          maxPrice: maxPrice,
          gender: gender,
          rating: rating,
          selectedLocations: locations,
        );
      } else {
        photographers = await vendorController.getPhotographers();
      }
      emit(PhotographersListState(photographers: photographers));
    } catch (error) {
      emit(PhotographersListState(errorMessage: error.toString()));
    }
  }
}
