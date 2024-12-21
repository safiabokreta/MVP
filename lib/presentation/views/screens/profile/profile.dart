import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zefeffete/data/datasources/account_ds.dart';
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
import 'package:zefeffete/presentation/views/screens/auth/login.dart';
import 'package:zefeffete/presentation/views/screens/auth/privacypolicy.dart';
import 'package:zefeffete/presentation/views/screens/profile/editprofile.dart';
import 'package:zefeffete/presentation/views/screens/profile/editprofilevendor.dart';
import 'package:zefeffete/presentation/views/screens/profile/editprofilevenueOwner.dart';
import 'package:zefeffete/presentation/views/screens/profile/security.dart';
import 'package:zefeffete/presentation/views/screens/profile/widgets/profilepainter.dart';
import 'package:zefeffete/presentation/views/widgets/bottomNavigationBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  static const String pageroute = '/profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<String?> currentUserEmail;
  late Future<String?> currentUserRole;
  late ProfileController profileController;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  AlertDialog _buildCustomAlertDialog(
      BuildContext context, String email, File? pickedFile) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      backgroundColor: const Color.fromARGB(
          255, 253, 222, 248), // Light pink background color
      title: const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Text(
          'Are you sure you want to change your profile image?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9E0456), // Dark magenta color
          ),
        ),
      ),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          'This will update your current profile picture. Please confirm if you want to proceed.',
          style: TextStyle(
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
            if (pickedFile != null) {
              setState(() {
                _image = File(pickedFile.path);
              });
            }
            profileController.saveProfileImageLocally(email, _image!);
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
          child: Text(
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

  Future<void> _pickImage(String email) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildCustomAlertDialog(context, email, File(pickedFile!.path));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(
      accountController: AccountController(
          AccountUserCases(AccountRepositoryImpl(AccountDataSource()))),
      vendorController: VendorController(VendorUseCases(VendorRepositoryImpl(
          VendorDataSource()))), // pass actual VendorController
      weddingOwnerController: WeddingOwnerController(WeddingOwnerUseCases(
          WeddingOwnerRepositoryImpl(
              WeddingOwnerDataSource()))), // pass actual WeddingOwnerController
      venueOwnerController: VenueOwnerController(VenueOwnerUseCases(
          VenueOwnerRepositoryImpl(
              VenueOwnerDataSource()))), // pass actual VenueOwnerController
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: profileController.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: BottomNavBar(currentRoute: '/profile'),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var userData = snapshot.data!;
          return Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      painter: MyPainter(),
                      size: Size(MediaQuery.of(context).size.width,
                          200), // Adjust arc height here
                    ),
                  ),
                  DefaultTextStyle(
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: 100),
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: _image != null
                                            ? FileImage(_image!)
                                            : (userData['profilePicture'] !=
                                                    null
                                                ? FileImage(File(userData[
                                                    'profilePicture']!))
                                                : FileImage(File(
                                                    'assets/images/profilepic.png'))),
                                      ),
                                      SingleChildScrollView(
                                          child: Column(
                                        children: [
                                          Text(
                                            userData['username'] ??
                                                'no username',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                userData['email'] ??
                                                    'No email address',
                                              ),
                                              Visibility(
                                                visible: userData['role'] !=
                                                    'wedding_owner',
                                                child: Text(
                                                  '| ${userData['phonenumber'] ?? '+213 ...'}',
                                                ),
                                              )
                                            ],
                                          ),
                                          SingleChildScrollView(
                                            child: Visibility(
                                              visible: userData['role'] !=
                                                  'wedding_owner',
                                              child: Text(
                                                ' ${userData['about'] ?? 'Write something about yourself'}',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                  Positioned(
                                    top: 145,
                                    right: 80,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _pickImage(userData['email']),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 245, 245, 245),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Card(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16, top: 16),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (userData['role'] ==
                                                      "vendor") {
                                                    Navigator.pushNamed(
                                                        context,
                                                        EditprofileVendor
                                                            .pageroute);
                                                  } else if (userData['role'] ==
                                                      "wedding_owner") {
                                                    Navigator.pushNamed(context,
                                                        Editprofile.pageroute);
                                                  } else if (userData['role'] ==
                                                      "venue_owner") {
                                                    //Navigator.pushNamed(context, EditprofileVenueOwner.pageroute);
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0), // Rounded corners
                                                          ),
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  253,
                                                                  222,
                                                                  248), // Light pink background color
                                                          title: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        16.0),
                                                            child: Text(
                                                              'You do not have a role',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xFF9E0456), // Dark magenta color
                                                              ),
                                                            ),
                                                          ),
                                                          content:
                                                              const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10.0),
                                                            child: Text(
                                                              'Please make sure you sign up or login if you want to proceed.',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black54, // Neutral color for readability
                                                              ),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xFF9E0456), // Dark magenta color for the button
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30), // Rounded button
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      24,
                                                                  vertical: 12,
                                                                ), // Comfortable button padding
                                                              ),
                                                              child: const Text(
                                                                'Okay',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white, // White text for contrast
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    return;
                                                  }
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize
                                                        .max, // This ensures the Row takes up full width
                                                    children: [
                                                      Icon(Icons.perm_identity),
                                                      Text(
                                                          '  Edit profile information'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16, top: 16),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      Security.pageroute);
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Icon(Icons
                                                          .security_outlined),
                                                      Text('  Security'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 16,
                                                  bottom: 16),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigate to theme settings page
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Icon(Icons
                                                          .collections_outlined),
                                                      Text('  Theme'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                        child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16, top: 16),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigate to help & support page
                                              },
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(Icons
                                                        .help_center_outlined),
                                                    Text('  Help & Support'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16, top: 16),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigate to contact us page
                                              },
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(Icons
                                                        .messenger_outline),
                                                    Text('  Contact us'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 16,
                                                bottom: 16),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    PrivacyPolicyScreen
                                                        .pageroute);
                                              },
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(Icons.lock_outline),
                                                    Text('  Privacy Policy'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    const SizedBox(height: 10),
                                    SingleChildScrollView(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, Login.pageroute);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 235, 118, 157),
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Log out',
                                          style: GoogleFonts.roboto(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      )),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavBar(currentRoute: '/profile'),
          );
        } else {
          return const Center(child: Text('No profile data found.'));
        }
      },
    );
  }
}
