import 'package:flutter_bloc/flutter_bloc.dart';  // <-- Add this import
import 'package:zefeffete/cubits/guests_cubit.dart';
import 'package:zefeffete/data/models/guest_model.dart';
import 'package:zefeffete/presentation/views/screens/guests/widgets/GuestCard.dart';
import 'package:flutter/material.dart';
import 'AddGuest.dart';
import 'package:zefeffete/presentation/views/widgets/bottomNavigationBar.dart';
import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/cubits/guest_state.dart';

class GuestsPageContent extends StatefulWidget {
  const GuestsPageContent({super.key});

  @override
  _GuestsPageContentState createState() => _GuestsPageContentState();
}

class _GuestsPageContentState extends State<GuestsPageContent> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Fetch the email when the page is loaded and trigger loading guests
    SharedPreferencesManager().getEmail().then((email) {
      if (email != null) {
        BlocProvider.of<GuestCubit>(context).loadGuests(email);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.white,
        title: const Center(child: Text("Guests List")),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromARGB(117, 83, 83, 82),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Color.fromARGB(117, 83, 83, 82),
                      ),
                      hintText: "Search by name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<GuestCubit, GuestState>(  // The BlocBuilder is here
                  builder: (context, state) {
                    if (state is GuestLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GuestLoaded) {
                      final guests = state.guests
                          .where((guest) =>
                              guest.name?.toLowerCase().contains(searchQuery) ?? false)
                          .toList();
                      if (guests.isEmpty) {
                        return const Center(
                          child: Text("No guests match your search."),
                        );
                      }
                      return ListView.builder(
                        itemCount: guests.length,
                        itemBuilder: (context, index) {
                          final guest = guests[index];
                          return Column(
                            children: [
                              GuestCard(
                                guestName: guest.name ?? 'Unknown',
                                gender: guest.gender ?? 'Unknown',
                                letter: guest.side == 'G' ? 'G' : 'B',
                                wCount: guest.numWomen,
                                mCount: guest.numMen,
                                kCount: guest.numKids,
                                guestId: guest.guestId ?? 0, // Ensure guestId is passed
                                weddingOwnerEmail: guest.weddingOwnerEmail, // Pass the weddingOwnerEmail
                                side: guest.side ?? 'Unknown', // Pass the side
                              ),
                              const SizedBox(height: 30),
                            ],
                          );
                        },
                      );
                    } else if (state is GuestError) {
                      return Center(child: Text(state.errorMessage));
                    } else if (state is GuestAddedSuccess) {
                      return FutureBuilder<String?>(  // FutureBuilder for GuestAddedSuccess
                        future: SharedPreferencesManager().getEmail(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              final email = snapshot.data;
                              BlocProvider.of<GuestCubit>(context).loadGuests(email!);
                              return const Center(child: Text('Guest Added! Refreshing list...'));
                            } else {
                              return const Center(child: Text('Error: Could not load email.'));
                            }
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      );
                    }
                    return const Center(child: Text('No guests available.'));
                  },
                ),
              ),
            ],
          ),
          // Positioned Button for adding a guest
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddGuest()),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC5789E),
                ),
                child: Center(
                  child: Transform.scale(
                    scale: 1.8, // Adjusted scale to fit the button size
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        currentRoute: '/guestsList',
      ),
    );
  }
}
