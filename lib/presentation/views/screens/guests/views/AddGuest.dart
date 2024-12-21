import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/data/models/guest_model.dart';
import 'package:zefeffete/cubits/guests_cubit.dart';
import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';

class AddGuest extends StatefulWidget {
  const AddGuest({super.key});

  @override
  _AddGuestState createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String gender = "Male";
  String side = "G";
  int numWomen = 0;
  int numMen = 0;
  int numKids = 0;

  bool isNameValid = true;

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
          "Add a new guest",
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
            onPressed: _addNewGuest,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
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
                        const SizedBox(height: 4),
                        Visibility(
                          visible: !isNameValid,
                          child: const Text(
                            "Name cannot be empty",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
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
                        const SizedBox(height: 4),
                        Visibility(
                          visible: !isNameValid,
                          child: const SizedBox(height: 16),
                        ),
                      ],
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
            borderRadius: BorderRadius.zero,
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

  void _addNewGuest() async {
    final weddingOwnerEmail = await SharedPreferencesManager().getEmail();
    if (nameController.text.trim().isEmpty) {
      setState(() {
        isNameValid = false;
      });
      return;
    }
    setState(() {
      isNameValid = true;
    });

    if (weddingOwnerEmail != null) {
      final concatenatedName =
          '${nameController.text.trim()} ${lastNameController.text.trim()}';

      final newGuest = GuestModel(
        weddingOwnerEmail: weddingOwnerEmail,
        name: concatenatedName,
        gender: gender,
        side: side,
        numWomen: numWomen,
        numMen: numMen,
        numKids: numKids,
      );

      BlocProvider.of<GuestCubit>(context).addGuest(newGuest.toMap());
      Navigator.pop(context);
    }
  }
}
