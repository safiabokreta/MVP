import 'package:flutter/material.dart';
import 'package:zefeffete/domain/usecases/vendors/get_filtered_vendors_usecase.dart';
import '../../../widgets/AppSearchBar.dart';
import '../widgets/VendorCard.dart';
import 'ProfileScreen.dart';
import 'FilterPage.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller_1.dart';
import 'package:zefeffete/data/datasources/vendor_ds.dart';
import 'package:zefeffete/data/repositories/vendor_rep_impl.dart';
import 'package:zefeffete/domain/usecases/vendors/get_photographers_use_case.dart';
import 'package:zefeffete/domain/usecases/vendors/unlike_vendor_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/like_vendor_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/is_vendor_liked_usecase.dart';
import 'package:zefeffete/domain/usecases/vendors/get_vendor_by_email_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/presentation/views/screens/vendors/cubits/photographers_list_cubit.dart';
import 'package:zefeffete/presentation/views/screens/vendors/cubits/vendor_like_cubit.dart';

class PhotographersPage extends StatelessWidget {
  final bool useCustomFilter;
  final double? minPrice;
  final double? maxPrice;
  final String? gender;
  final String? rating;
  final Map<String, List<String>>? locations;

  const PhotographersPage({
    super.key,
    this.useCustomFilter = false,
    this.minPrice,
    this.maxPrice,
    this.gender,
    this.rating,
    this.locations,
  });

  @override
  Widget build(BuildContext context) {
    // Dependencies setup
    final vendorDataSource = VendorDataSource();
    final vendorRepository = VendorRepositoryImpl(vendorDataSource);
    final vendorController = VendorController(
      getFilteredVendorsUseCase:
          GetFilteredVendorsUseCase(vendorRepository: vendorRepository),
      getVendorByEmailUseCase:
          GetVendorByEmailUseCase(vendorRepository: vendorRepository),
      getPhotographersUseCase: GetPhotographersUseCase(vendorRepository),
      likeVendorUseCase: LikeVendorUseCase(vendorRepository),
      unlikeVendorUseCase: UnlikeVendorUseCase(vendorRepository),
      isVendorLikedUseCase: IsVendorLikedUseCase(vendorRepository),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              PhotographersListCubit(vendorController: vendorController)
                ..fetchPhotographers(
                  useCustomFilter: useCustomFilter,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  gender: gender,
                  rating: rating != null ? double.tryParse(rating!) : null,
                  locations: locations,
                ),
        ),
        BlocProvider(
          create: (_) => VendorLikeCubit(vendorController: vendorController),
        ),
      ],
      child: _PhotographersPageContent(vendorController: vendorController),
    );
  }
}

class _PhotographersPageContent extends StatelessWidget {
  final VendorController vendorController;

  const _PhotographersPageContent({required this.vendorController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 20),
            child: Center(
              child: Stack(
                children: [
                  const AppSearchBar(),
                  Positioned(
                    right: 28.0,
                    top: 0.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.primary4,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FilterPage(
                              category: "photographers",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PhotographersListCubit, PhotographersListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.errorMessage != null) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                } else if (state.photographers == null ||
                    state.photographers!.isEmpty) {
                  return const Center(child: Text("No photographers found."));
                }

                final photographers = state.photographers!;

                return ListView.builder(
                  itemCount: photographers.length,
                  itemBuilder: (context, index) {
                    final photographer = photographers[index];

                    return VendorCard(
                      name: photographer.username ?? "Unknown username",
                      phone: photographer.phoneNumber ?? "Unknown phone",
                      location: photographer.city ?? "Unknown city",
                      imageUrl: photographer.profilePicture ??
                          "assets/images/default_user.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              vendorEmail: photographer.email,
                              vendorController: vendorController,
                            ),
                          ),
                        );
                      },
                      isLiked: context
                          .read<VendorLikeCubit>()
                          .isVendorLiked(photographer.email),
                      onLike: () {
                        context
                            .read<VendorLikeCubit>()
                            .toggleVendorLike(photographer);
                      },
                      onUnlike: () {
                        context
                            .read<VendorLikeCubit>()
                            .toggleVendorLike(photographer);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
