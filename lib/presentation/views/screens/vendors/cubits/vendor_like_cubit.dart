import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/domain/entities/vendor.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller_1.dart';

class VendorLikeState {
  final Map<String, bool> likedVendors;

  VendorLikeState({required this.likedVendors});

  VendorLikeState copyWith({Map<String, bool>? likedVendors}) {
    return VendorLikeState(
      likedVendors: likedVendors ?? this.likedVendors,
    );
  }
}

class VendorLikeCubit extends Cubit<VendorLikeState> {
  final VendorController vendorController;

  VendorLikeCubit({required this.vendorController})
      : super(VendorLikeState(likedVendors: {}));

  Future<void> toggleVendorLike(Vendor vendor) async {
    final isLiked = state.likedVendors[vendor.email] ?? false;

    if (isLiked) {
      await vendorController.unlikeVendor(vendor.email);
    } else {
      await vendorController.likeVendor(vendor.email);
    }

    final updatedLikes = Map<String, bool>.from(state.likedVendors);
    updatedLikes[vendor.email] = !isLiked;

    emit(state.copyWith(likedVendors: updatedLikes));
  }

  Future<void> checkVendorLikedStatus(Vendor vendor) async {
    final isLiked = await vendorController.isVendorLiked(vendor.email);
    final updatedLikes = Map<String, bool>.from(state.likedVendors);
    updatedLikes[vendor.email] = isLiked;

    emit(state.copyWith(likedVendors: updatedLikes));
  }

  bool isVendorLiked(String? email) {
    if (email == null) return false;
    return state.likedVendors[email] ?? false;
  }
}
