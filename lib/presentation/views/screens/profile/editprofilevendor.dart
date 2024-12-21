import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:zefeffete/data/datasources/account_ds.dart';
import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/data/datasources/vendor_ds.dart';
import 'package:zefeffete/data/datasources/venue_owner_ds.dart';
import 'package:zefeffete/data/datasources/wedding_owner_ds.dart';
import 'package:zefeffete/data/repositories/account_rep_impl.dart';
import 'package:zefeffete/data/repositories/vendor_rep_impl.dart';
import 'package:zefeffete/data/repositories/venue_owner_rep_impl.dart';
import 'package:zefeffete/data/repositories/wedding_owner_rep_impl.dart';
import 'package:zefeffete/domain/usecases/account/account_usecases.dart';
import 'package:zefeffete/domain/usecases/vendors/vendor_usecases.dart';
import 'package:zefeffete/domain/usecases/venue_owner/venue_owner_usecase.dart';
import 'package:zefeffete/domain/usecases/wedding_owner_usecases.dart';
import 'package:zefeffete/presentation/controllers/profile_controller.dart';
import 'package:zefeffete/presentation/controllers/user_account_controller.dart';
import 'package:zefeffete/presentation/controllers/vendor_controller.dart';
import 'package:zefeffete/presentation/controllers/venue_owner.dart';
import 'package:zefeffete/presentation/controllers/wedding_owner_controller.dart';
import 'package:zefeffete/presentation/views/screens/profile/profile.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/categoryDropDown.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/citydropdown.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/genderDropDown.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/priceDropDownMax.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/priceDropDownMin.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/wilayaDropDown.dart';
import 'package:zefeffete/presentation/views/widgets/bottomNavigationBar.dart';

class EditprofileVendor extends StatefulWidget {
  static const String pageroute = '/editprofilevendor';

  const EditprofileVendor({super.key});

  @override
  State<EditprofileVendor> createState() => _EditprofileVendorState();
}

final _formKey = GlobalKey<FormState>(); // Form key for validation
final GlobalKey<WilayadropdownState> _wilayaDropdownKey = GlobalKey();
final GlobalKey<CityDropDownState> _cityDropdownKey = GlobalKey();

final GlobalKey<GenderdropdownState> _genderDropdownKey = GlobalKey();
final GlobalKey<CategorydropdownState> _CategoryDropdownKey = GlobalKey();
final GlobalKey<MaxRangedropdownState> _maxrangeDropdownKey = GlobalKey();
final GlobalKey<MinRangedropdownState> _minrangeDropdownKey = GlobalKey();

bool showVendor = false;
const int maxTextLengthdetails = 3000;
const int maxTextLengthabout = 400;

final TextEditingController _aboutController = TextEditingController();
final TextEditingController _pricingController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();

class _EditprofileVendorState extends State<EditprofileVendor> {
  late Future<String?> currentUserEmail;
  late Future<String?> currentUserRole;
  late Future<String?> currentUsername;
  late Future<String?> activated;
  late String updatedUsername;
  late List<String> selectedImages;
  late ProfileController profileController;
  final Map<double, String> mindisplayMap = {
    0.0: '0.0',
    2500.0: '[0-5000]',
    7500.0: '[5000-10000]',
    12500.0: '[10000-15000]',
    17500.0: '[15000-20000]',
    22500.0: '[20000-25000]',
    27500.0: '[25000-30000]',
  };

  final Map<String, double> minvalueMap = {
    '0.0': 0.0,
    '[0-5000]': 2500.0,
    '[5000-10000]': 7500.0,
    '[10000-15000]': 12500.0,
    '[15000-20000]': 17500.0,
    '[20000-25000]': 22500.0,
    '[25000-30000]': 27500.0,
  };
  final Map<String, double> maxvalueMap = {
    '0.0': 0.0,
    '[0-5000]': 5000.0,
    '[5000-10000]': 10000.0,
    '[10000-15000]': 15000.0,
    '[15000-20000]': 20000.0,
    '[20000-25000]': 25000.0,
    '[25000-30000]': 30000.0,
    '[ > 30000]': 35000.0,
  };
  AlertDialog buildCustomAlertDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      backgroundColor: const Color.fromARGB(
          255, 253, 222, 248), // Light pink background color
      title: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          title, // Use the dynamic title
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9E0456), // Dark magenta color
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          message, // Use the dynamic message
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54, // Neutral color for readability
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFFEB769D), // Vibrant pink color for cancel
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Perform action on confirmation here
            Navigator.of(context).pop(); // Close the dialog
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF9E0456), // Dark magenta color for the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded button
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12), // Comfortable button padding
          ),
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.white, // White text for contrast
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    currentUserEmail = SharedPreferencesManager().getEmail();
    currentUserRole = SharedPreferencesManager().getRole();
    currentUsername = SharedPreferencesManager().getUsername();
    activated = SharedPreferencesManager().getActivated();
    selectedImages = [];
    profileController = ProfileController(
      accountController: AccountController(
        AccountUserCases(AccountRepositoryImpl(AccountDataSource())),
      ),
      vendorController: VendorController(
        VendorUseCases(VendorRepositoryImpl(VendorDataSource())),
      ),
      weddingOwnerController: WeddingOwnerController(
        WeddingOwnerUseCases(
            WeddingOwnerRepositoryImpl(WeddingOwnerDataSource())),
      ),
      venueOwnerController: VenueOwnerController(
        VenueOwnerUseCases(VenueOwnerRepositoryImpl(VenueOwnerDataSource())),
      ),
    );
  }

//comment
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: profileController.getUserProfile(),
        builder: (context, profilesnapshot) {
          if (profilesnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (profilesnapshot.hasError) {
            return Center(child: Text('Error: ${profilesnapshot.error}'));
          } else if (profilesnapshot.hasData) {
            var userData = profilesnapshot.data;
            String email = userData?['email'];
            String username = userData?['username'];
            String role = userData?['role'];
            String activation =
                userData != null && userData['activated'] == true
                    ? "Activated"
                    : "NotActivated";
            final userDataImages = userData?['images'] ?? [];
            selectedImages.addAll(userDataImages);
            List<String> combinedImages = List<String>.from(
                Set<String>.from(selectedImages + userDataImages));
            List<String> todelete = [];
            final Map<String, dynamic> changes = {};

            void onImageSelected(List<XFile> pickedImages) {
              setState(() {
                // Add the new images to the list
                selectedImages.addAll(pickedImages.map((e) => e.path));
              });
            }

            return SizedBox.expand(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey, // Assign form key
                    child: Column(
                      children: [
                        // Full name field with validation
                        const SizedBox(height: 10),

                        // Nickname field with validation
                        TextField(
                          controller:
                              _usernameController, // Assign controller here
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 181, 88, 139),
                                width: 2.0,
                              ),
                            ),
                            labelText: userData?['username'],
                            labelStyle: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 103, 102, 103),
                            ),
                            hintText: userData?[
                                'username'], // You can show a hint here
                            hintStyle: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(92, 255, 207, 247),
                          ),
                        ),

                        const SizedBox(height: 5),
                        TextFormField(
                          initialValue:
                              userData?['phone_number']?.isEmpty ?? true
                                  ? 'Update phone number in security'
                                  : userData?['phone_number'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 181, 88, 139),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Phone Number',
                            labelStyle: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 103, 102, 103),
                            ),
                            hintText: userData?['phone_number']?.isEmpty ?? true
                                ? 'Update phone number in security'
                                : userData?['phone_number'],
                            hintStyle: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(92, 255, 207, 247),
                          ),
                          enabled: false, // Disable editing
                        ),
                        const SizedBox(height: 5),

                        Visibility(
                          visible: role == 'vendor',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Add myself as Vendor"),
                              Switch(
                                value: showVendor,
                                activeColor:
                                    const Color.fromARGB(255, 158, 4, 86),
                                onChanged: (value) {
                                  setState(() {
                                    showVendor = value;
                                    print('Vendor toggled: $showVendor');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showVendor,
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              TextField(
                                controller: _aboutController,
                                maxLength: maxTextLengthabout,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: userData?['about'],
                                  hintText: "Write something about yourself...",
                                  filled: true,
                                  fillColor: const Color.fromARGB(
                                      92, 255, 207, 247), // Background color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 181, 88,
                                          139), // Border color when focused
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Categorydropdown(
                                      key: _CategoryDropdownKey,
                                      selectedCategory: '',
                                      initialSelection: userData?['category'],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Genderdropdown(
                                      key: _genderDropdownKey,
                                      selectedGender: '',
                                      initialSelection: userData?['gender'],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Wilayadropdown(
                                      key:
                                          _wilayaDropdownKey, // Pass the key here
                                      selectedWilaya: '',
                                      initialSelection: userData?['wilaya'] ??
                                          'wilaya', // Example of passing initial selection
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: CityDropDown(
                                      key:
                                          _cityDropdownKey, // Pass the key here
                                      selectedCity: '',
                                      initialSelectioncity: userData?['city'] ??
                                          'city', // Example of passing initial selection
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: MinRangedropdown(
                                      key: _minrangeDropdownKey,
                                      selectedRange: '',
                                      initialSelection: minvalueMap.entries
                                          .firstWhere(
                                              (entry) =>
                                                  entry.value ==
                                                  userData!['price_min'],
                                              orElse: () =>
                                                  const MapEntry('0.0', 0.0))
                                          .key,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: MaxRangedropdown(
                                      key: _maxrangeDropdownKey,
                                      selectedRange: '',
                                      initialSelection: maxvalueMap.entries
                                          .firstWhere(
                                              (entry) =>
                                                  entry.value ==
                                                  userData!['price_max'],
                                              orElse: () =>
                                                  const MapEntry('0.0', 0.0))
                                          .key, // Get the key corresponding to the numeric value
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () async {
                                  final pickedImages =
                                      await ImagePicker().pickMultiImage();
                                  print(
                                      "Fetched profile picture: ${userData?['profilePicture']}");
                                  print(
                                      "Fetched images: ${userData?['images']}");
                                  print(
                                      "pickedImages: ${pickedImages.map((e) => e.path).toList()}");

                                  setState(() {
                                    if (pickedImages != null) {
                                      onImageSelected(
                                          pickedImages); // Call the function to update the images list
                                      print(
                                          "Images added to selectedImages: ${selectedImages}");
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            92, 255, 207, 247),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 181, 88, 139),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: Color.fromARGB(
                                                255, 181, 88, 139),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'Include 1 or more pictures',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 103, 102, 103),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Manage Images:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Wrap(
                                            spacing: 8, // Space between images
                                            runSpacing: 8, // Space between rows
                                            children:
                                                combinedImages.map((imageUrl) {
                                              final index = combinedImages
                                                  .indexOf(imageUrl);

                                              return Stack(
                                                children: [
                                                  // Display the Image
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: imageUrl.startsWith(
                                                            'http') // Check if it's a URL
                                                        ? Image.network(
                                                            imageUrl,
                                                            height: 100,
                                                            width: 100,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
                                                            File(
                                                                imageUrl), // Display image from file path
                                                            height: 100,
                                                            width: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  // Delete Button
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (combinedImages
                                                                  .length ==
                                                              1) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return buildCustomAlertDialog(
                                                                    context,
                                                                    "Error",
                                                                    "You must have at least one picture to stay a vendor");
                                                              },
                                                            );
                                                            return;
                                                          }
                                                          // If image is from selectedImages, remove it from there
                                                          if (selectedImages
                                                              .contains(
                                                                  imageUrl)) {
                                                            selectedImages
                                                                .remove(
                                                                    imageUrl);
                                                          } else if (userDataImages
                                                              .contains(
                                                                  imageUrl)) {
                                                            // If image is from userDataImages, add it to 'tobedeleted'
                                                            if (!changes
                                                                .containsKey(
                                                                    'tobedeleted')) {
                                                              changes['tobedeleted'] =
                                                                  [];
                                                            }
                                                            changes['tobedeleted']
                                                                .add(imageUrl);
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              119,
                                                              114,
                                                              116),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _pricingController,
                                maxLength: maxTextLengthdetails,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: userData?['pricing_details'],
                                  hintText:
                                      "Write your pricing details here...",
                                  filled: true,
                                  fillColor: const Color.fromARGB(
                                      92, 255, 207, 247), // Background color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 181, 88,
                                          139), // Border color when focused
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            print("started form validation: ");

                            if (_formKey.currentState?.validate() ?? false) {
                              print("started form validation: ");

                              _formKey.currentState?.save();
                              print("success form validation: ");

                              final selectedWilayaFromDropdown =
                                  _wilayaDropdownKey.currentState
                                          ?.getSelectedWilaya() ??
                                      (userData?['wilaya'] ?? 'wilaya');
                              final selectedCityFromDropdown = _cityDropdownKey
                                      .currentState
                                      ?.getSelectedCity() ??
                                  (userData?['city'] ?? 'city');
                              final selectedGender = _genderDropdownKey
                                      .currentState
                                      ?.getSelectedGender() ??
                                  (userData?['gender'] ?? 'gender');
                              final selectedCategory = _CategoryDropdownKey
                                      .currentState
                                      ?.getSelectedCategory() ??
                                  (userData?['category'] ?? 'category');
                              final selectedPriceMin = (_minrangeDropdownKey
                                      .currentState
                                      ?.getSelectedRangeAsReal() ??
                                  (userData?['price_min'] ?? 0.0));
                              final selectedPriceMax = (_maxrangeDropdownKey
                                      .currentState
                                      ?.getSelectedRangeAsReal() ??
                                  (userData?['price_max'] ?? 0.0));
                              print('Selected price min: $selectedPriceMin');
                              print('Selected price max: $selectedPriceMax');

                              if (selectedPriceMin < 0.0 ||
                                  selectedPriceMax < 0.0 ||
                                  selectedPriceMin > selectedPriceMax) {
                                print(
                                    "Invalid price values: min_price and max_price must be >= 0.0 and min_price < max_price");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return buildCustomAlertDialog(
                                        context,
                                        "Error",
                                        "Invalid price values: price min must be less than max price and both must not be null");
                                  },
                                );
                                return;
                              }
                              // Print the images list right before submission

                              // Check if images list has changed

                              final updatedUserData = {
                                'email': email.isNotEmpty == true
                                    ? email
                                    : '', // Ensure 'email' is not null
                                'username': _usernameController.text.isNotEmpty
                                    ? _usernameController.text
                                    : (userData?['username'] ?? 'username'),
                                'about': _aboutController.text.isNotEmpty
                                    ? _aboutController.text
                                    : (userData?['about'] ?? ''),
                                'gender': selectedGender,
                                'category': selectedCategory,
                                'wilaya': selectedWilayaFromDropdown,
                                'city': selectedCityFromDropdown,
                                'price_min': selectedPriceMin,
                                'price_max': selectedPriceMax,
                                'pricing_details':
                                    _pricingController.text.isNotEmpty
                                        ? _pricingController.text
                                        : (userData?['pricing_details'] ?? ''),
                                'showVendor': showVendor ?? false,
                                'profilePicture': userData?['profilePicture'],
                              };

                              print("updatedUserData: ");
                              print(updatedUserData);

                              final userUsername =
                                  userData?['username'] ?? 'username';

                              if (showVendor == false) {
                                if (updatedUserData['username'] !=
                                    userUsername) {
                                  changes['username'] =
                                      updatedUserData['username'];
                                  print(
                                      "changes usernames: ${changes['username']}");
                                }
                              }
                              if (showVendor == true &&
                                  activation != "Activated") {
                                bool isInvalid =
                                    updatedUserData['pricing_details'] == '' ||
                                        updatedUserData['pricing_details'] ==
                                            '' ||
                                        updatedUserData['wilaya'] == '' ||
                                        updatedUserData['wilaya'] == 'wilaya' ||
                                        updatedUserData['city'] == '' ||
                                        updatedUserData['city'] == 'city' ||
                                        updatedUserData['price_min'] == '' ||
                                        updatedUserData['price_min'] == 0.0 ||
                                        updatedUserData['price_max'] == '' ||
                                        updatedUserData['price_max'] == 0.0 ||
                                        updatedUserData['gender'] == '' ||
                                        updatedUserData['gender'] == 'gender' ||
                                        updatedUserData['category'] == '' ||
                                        updatedUserData['category'] ==
                                            'category' ||
                                        updatedUserData['about'] == '' ||
                                        updatedUserData['about'] == '';
                                if (userData?['profilePicture'] == null) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildCustomAlertDialog(
                                          context,
                                          "Error",
                                          "Please select a profile picture first.");
                                    },
                                  );
                                  _formKey.currentState
                                      ?.reset(); // Optionally reset the form

                                  return;
                                }
                                if (isInvalid) {
                                  print(
                                      'Please fill all the information required to add yourself as a vendor');
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildCustomAlertDialog(
                                          context,
                                          "Error",
                                          "Please fill all the information required to add yourself as a vendor");
                                    },
                                  );
                                  return;
                                } else if (selectedImages.isEmpty) {
                                  print(
                                      "selectedImages before submit: $selectedImages");

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildCustomAlertDialog(
                                          context,
                                          "Error",
                                          "Please select at least one image.");
                                    },
                                  );
                                  return;
                                }
                              }

                              print("after not activated check ");

                              print(updatedUserData['username']);
                              print(userData?['username']);

                              // Only check changes if showVendor is false
                              if (showVendor == true) {
                                print("Show vendor is true ");

                                if (updatedUserData['username'] !=
                                    userUsername) {
                                  changes['username'] =
                                      updatedUserData['username'];
                                }
                                if (userData?['profilePicture'] == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildCustomAlertDialog(
                                          context,
                                          "Error",
                                          "Please select a profile picture first.");
                                    },
                                  );
                                  return;
                                }
                                print("here creating original images ");

                                // Fetch the images from DB or use default if null

                                print(
                                    "Original images from DB: $userDataImages");

                                // Check if images are updated
                                // Initialize an empty list to store images that are in selectedImages but not in originalImages
                                List<String> updatedImages = [];

                                // Iterate through the selected images and add them if they are not already in the original images
                                for (String image in selectedImages) {
                                  updatedImages.add(image);
                                }

                                // If there are any new images in selectedImages that are not in originalImages, update the 'images' field
                                if (updatedImages.isNotEmpty) {
                                  changes['images'] = updatedImages;
                                }

                                print("Updated images: ${changes['images']}");

                                // If images are empty and there were originally images in DB
                                if (selectedImages.isEmpty &&
                                    userDataImages.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildCustomAlertDialog(
                                          context,
                                          "Error",
                                          "Please select at least one image.");
                                    },
                                  );
                                  return;
                                }

                                if (updatedUserData['about'] !=
                                    userData?['about']) {
                                  changes['about'] = updatedUserData['about'];
                                }
                                if (updatedUserData['pricing_details'] !=
                                    userData?['pricing_details']) {
                                  changes['pricing_details'] =
                                      updatedUserData['pricing_details'];
                                }
                                if (updatedUserData['gender'] !=
                                    userData?['gender']) {
                                  changes['gender'] = updatedUserData['gender'];
                                }
                                if (updatedUserData['category'] !=
                                    userData?['category']) {
                                  changes['category'] =
                                      updatedUserData['category'];
                                }
                                if (updatedUserData['wilaya'] !=
                                    userData?['wilaya']) {
                                  changes['wilaya'] = updatedUserData['wilaya'];
                                }
                                if (updatedUserData['city'] !=
                                    userData?['city']) {
                                  changes['city'] = updatedUserData['city'];
                                }
                                if (updatedUserData['price_min'] !=
                                        userData?['price_min'] &&
                                    updatedUserData['price_min'] != 0.0) {
                                  changes['price_min'] =
                                      updatedUserData['price_min'];
                                }

                                if (updatedUserData['price_max'] !=
                                        userData?['price_max'] &&
                                    updatedUserData['price_max'] != 0.0) {
                                  changes['price_max'] =
                                      updatedUserData['price_max'];
                                }
                              }

                              print("changes: ");
                              print(changes);

                              print("changes: ");
                              print(changes);

                              // Only make the request if there are changes
                              if (changes.isNotEmpty) {
                                try {
                                  changes['email'] = email ?? '';
                                  changes['role'] = role ?? '';
                                  changes['activated'] = activation ?? '';
                                  changes['showVendor'] = showVendor ?? false;

                                  print("changes: ");
                                  print(changes);
                                  String result = await profileController
                                      .updateUserProfile(changes);
                                  await profileController.getUserProfile();

                                  if (result != "Success") {
                                    print(result);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return buildCustomAlertDialog(
                                            context, "Error", result);
                                      },
                                    );
                                  } else if (!changes.isNotEmpty) {
                                    print("No changes");
                                    selectedImages.clear();

                                    Navigator.pop(context);
                                  } else {
                                    print("Changes done");
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return buildCustomAlertDialog(
                                            context,
                                            "Success",
                                            "You profile has been updated successfully");
                                      },
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()),
                                    );
                                  }
                                } catch (e) {
                                  print("Error saving profile from button: $e");
                                }
                              } else {
                                Navigator.pop(context);
                                print("No changes detected.");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 235, 118, 157),
                            minimumSize: const Size(300, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Role data is not available.'));
          }
        },
      ),
    );
  }
}
