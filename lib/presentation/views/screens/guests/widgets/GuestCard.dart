import 'package:flutter/material.dart';
import 'package:zefeffete/presentation/views/screens/guests/views/EditGuest.dart'; // Import your editing page
import 'package:zefeffete/data/models/guest_model.dart'; // Ensure this import is added to use GuestModel
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zefeffete/cubits/guests_cubit.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';


class GuestCard extends StatefulWidget {
  final String guestName;
  final String gender; // "male" or "female"
  final String letter; // "B" or "G"
  final int wCount, mCount, kCount;
  final int guestId; // Add this to identify the guest
  final String weddingOwnerEmail;
  final String side;

  const GuestCard({
    super.key,
    required this.guestName,
    required this.gender,
    required this.letter,
    required this.wCount,
    required this.mCount,
    required this.kCount,
    required this.guestId,
    required this.weddingOwnerEmail,
    required this.side,
  });

  @override
  _GuestCardState createState() => _GuestCardState();
}

class _GuestCardState extends State<GuestCard> {
  bool isFocused =
      false; // Track whether the card is focused for delete options

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isFocused = true; // Show delete options on long press
        });
      },
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditGuest(
              guest: GuestModel(
                guestId: widget.guestId,
                weddingOwnerEmail: widget.weddingOwnerEmail,
                name:
                    widget.guestName.isNotEmpty ? widget.guestName : 'Unknown',
                gender: widget.gender.isNotEmpty ? widget.gender : 'Unknown',
                side: widget.side.isNotEmpty ? widget.side : 'Unknown',
                numWomen: widget.wCount >= 0 ? widget.wCount : 0,
                numMen: widget.mCount >= 0 ? widget.mCount : 0,
                numKids: widget.kCount >= 0 ? widget.kCount : 0,
              ),
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: 304,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.gender == "Male" ? Icons.male : Icons.female,
                            size: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.guestName.isNotEmpty
                                ? widget.guestName
                                : 'Unknown',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        widget.letter.isNotEmpty ? widget.letter : 'N/A',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Bottom Section with W, M, K values
                Row(
                  children: [
                    _buildInfoBox(widget.wCount.toString(), "W"),
                    _verticalDivider(),
                    _buildInfoBox(widget.mCount.toString(), "M"),
                    _verticalDivider(),
                    _buildInfoBox(widget.kCount.toString(), "K"),
                  ],
                ),
              ],
            ),
          ),
          if (isFocused)
            if (isFocused)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16), // Match the card's radius
                  child: Container(
                    color:
                        Colors.black54.withOpacity(0.8), // Overlay background
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Call deleteGuest method in the cubit
                              BlocProvider.of<GuestCubit>(context).deleteGuest(
                                  widget.guestId, widget.weddingOwnerEmail);

                              setState(() {
                                isFocused = false; // Reset focus after deletion
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary2 ,
                            ),
                            child: const Text("Delete"),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isFocused = false; // Reset focus on cancel
                              });
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(
              value.isNotEmpty ? value : '0',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.black,
    );
  }
}
