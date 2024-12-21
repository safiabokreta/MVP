import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/data/models/guest_model.dart';
import 'package:zefeffete/cubits/guests_cubit.dart';
import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';

class EditGuest extends StatefulWidget {
  final GuestModel guest;

  const EditGuest({super.key, required this.guest});

  @override
  _EditGuestState createState() => _EditGuestState();
}

class _EditGuestState extends State<EditGuest> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late String gender;
  late String side;
  late int numWomen;
  late int numMen;
  late int numKids;

  @override
  void initState() {
    super.initState();

    // Split the existing name into first name and last name
    final fullName = widget.guest.name!.split(' ');
    nameController = TextEditingController(text: fullName.isNotEmpty ? fullName[0] : '');
    lastNameController = TextEditingController(text: fullName.length > 1 ? fullName[1] : '');

    gender = widget.guest.gender ?? "Male";
    side = widget.guest.side ?? "G";
    numWomen = widget.guest.numWomen;
    numMen = widget.guest.numMen;
    numKids = widget.guest.numKids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary2,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDECEF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Guest",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {
              _updateGuest();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Name and Surname Input Fields
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: "Surname",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Gender and Side Selection
              Row(
                children: [
                  _buildToggleButton("Male", gender == "Male", () {
                    setState(() {
                      gender = "Male";
                    });
                  }),
                  _buildToggleButton("Female", gender == "Female", () {
                    setState(() {
                      gender = "Female";
                    });
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildToggleButton("Groom's side", side == "G", () {
                    setState(() {
                      side = "G";
                    });
                  }),
                  _buildToggleButton("Bride's side", side == "B", () {
                    setState(() {
                      side = "B";
                    });
                  }),
                ],
              ),
              const SizedBox(height: 40),

              const Text(
                "Companions:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),

              // Dropdowns for Number of Women, Men, and Kids
              _buildDropdown("Number of women", numWomen, (value) {
                setState(() {
                  numWomen = value!;
                });
              }),
              const SizedBox(height: 32),
              _buildDropdown("Number of men", numMen, (value) {
                setState(() {
                  numMen = value!;
                });
              }),
              const SizedBox(height: 32),
              _buildDropdown("Number of kids", numKids, (value) {
                setState(() {
                  numKids = value!;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
      String label, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary2 : Colors.white,
          side: const BorderSide(color: Color.fromARGB(255, 151, 142, 142)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              bottomLeft: Radius.circular(7),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color.fromARGB(255, 151, 142, 142),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, int currentValue, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: currentValue,
      items: List.generate(11, (index) {
        return DropdownMenuItem(
          value: index,
          child: Text(index.toString()),
        );
      }),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }

  void _updateGuest() async {
    final weddingOwnerEmail = await SharedPreferencesManager().getEmail();
    if (weddingOwnerEmail != null) {
      final concatenatedName =
          '${nameController.text} ${lastNameController.text}';

      final updatedGuest = GuestModel(
        guestId: widget.guest.guestId,
        weddingOwnerEmail: weddingOwnerEmail,
        name: concatenatedName, // Save concatenated name and surname
        gender: gender,
        side: side,
        numWomen: numWomen,
        numMen: numMen,
        numKids: numKids,
      );

      // Use Cubit to update the guest
      BlocProvider.of<GuestCubit>(context).updateGuest(updatedGuest);
    }
  }
}
