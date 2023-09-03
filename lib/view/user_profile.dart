import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controller/userdpprovider.dart';
import '../user_details/get_user_data.dart';
import '../user_details/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DocumentSnapshot _userProfile;
  bool isGoogleSignIn = false;
  @override
  void initState() {
    super.initState();

    // Fetch the user profile document from Firestore
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          setState(() {
            _userProfile = documentSnapshot;

            Provider.of<UserDataProvider>(context, listen: false)
                .usernameController
                .text = _userProfile['fullName'] ?? '';
            Provider.of<UserDataProvider>(context, listen: false)
                .phoneNumberController
                .text = _userProfile['phone_number'] ?? '';
            Provider.of<UserDataProvider>(context, listen: false)
                .addressController
                .text = _userProfile['address'] ?? '';
            Provider.of<UserDataProvider>(context, listen: false)
                .ageController
                .text = _userProfile['age']?.toString() ?? '';
          });
        }
      });
    } catch (e) {
      print('Error fetching user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching user profile: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final getuser = Provider.of<UserDataProvider>(context);
    final userDetails = Provider.of<UserDPprovider>(context);
    final googleUser = Provider.of<GoogleSignInProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Profile',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 78, 78),
                Color.fromARGB(255, 34, 32, 27),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        height: height,
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //     image: NetworkImage(
          //         'https://mebincdn.themebin.com/1664962508289.png'),
          //     fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 34, 32, 27),
              Color.fromARGB(255, 34, 32, 27),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 25,
                ),
                Center(
                  child: SizedBox(
                    height: height * 0.28,
                    child: Stack(
                      children: [
                        Consumer<UserDataProvider>(
                          builder: (context, userDataProvider, child) {
                            final authUser = FirebaseAuth.instance.currentUser;
                            if (authUser != null) {
                              if (authUser.providerData.any((provider) =>
                                  provider.providerId == 'google.com')) {
                                return StreamBuilder<Map<String, dynamic>>(
                                  stream:
                                      userDataProvider.getUserDetailsgoogle(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data!;
                                      final photoUrl =
                                          data['photoUrl'] as String;

                                      return CircleAvatar(
                                        radius: 120,
                                        backgroundImage: NetworkImage(photoUrl),
                                      );
                                    } else {
                                      return const CircleAvatar(
                                        radius: 120,
                                        backgroundImage: NetworkImage(
                                            'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png'),
                                      );
                                    }
                                  },
                                );
                              } else if (authUser.providerData.any((provider) =>
                                  provider.providerId == 'password')) {
                                // User signed in with email/password
                                return StreamBuilder<Map<String, dynamic>>(
                                  stream: userDataProvider.getUserDetailspswd(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data!;
                                      final photoUrl =
                                          data['photoUrl'] as String;

                                      return CircleAvatar(
                                          radius: 120,
                                          backgroundImage:
                                              NetworkImage(photoUrl));
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                              }
                            }
                            // User not signed in
                            return const SizedBox.shrink();
                          },
                        ),
                        Positioned(
                          bottom: 25.0,
                          right: 0.0,
                          child: Visibility(
                            visible:
                                !isGoogleSignIn, // Hide the IconButton when isGoogleSignIn is true
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white70,
                                size: 40,
                              ),
                              onPressed: () {
                                getuser.requestStoragePermission();
                                userDetails.getImage();
                                // userDetails.dpimageUser(widget.userId);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 15,
                ),
                SizedBox(
                  height: height * 0.08,
                  child: Consumer<UserDataProvider>(
                    builder: (context, userProvider, child) {
                      final TextEditingController usernameController =
                          userProvider.usernameController;
                      final authUser = FirebaseAuth.instance.currentUser;

                      if (authUser != null) {
                        isGoogleSignIn = authUser.providerData.any(
                            (provider) => provider.providerId == 'google.com');
                      }

                      return TextFormField(
                        controller: usernameController,
                        // enabled:
                        //     !isGoogleSignIn, // Disable editing if signed in via Google
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Colors.white60,
                          ),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: Provider.of<UserDataProvider>(context)
                        .phoneNumberController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                        color: Colors.white60,
                      ),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    controller: Provider.of<UserDataProvider>(context)
                        .addressController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(
                        color: Colors.white60,
                      ),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller:
                        Provider.of<UserDataProvider>(context).ageController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(
                        color: Colors.white60,
                      ),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 2.0,
                        ),
                        gapPadding: 4,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      suffixStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: MediaQuery.of(context).size.width * .93,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 189, 189, 189),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        // Update the user profile in Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .update({
                          'fullName': Provider.of<UserDataProvider>(context,
                                  listen: false)
                              .usernameController
                              .text,
                          'phone_number': Provider.of<UserDataProvider>(context,
                                  listen: false)
                              .phoneNumberController
                              .text,
                          'address': Provider.of<UserDataProvider>(context,
                                  listen: false)
                              .addressController
                              .text,
                          'age': int.parse(Provider.of<UserDataProvider>(
                                  context,
                                  listen: false)
                              .ageController
                              .text),
                        });
                        // Display a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content:
                                  Text('User profile updated successfully')),
                        );
                      } catch (e) {
                        print('Error updating user profile: $e');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error updating user profile'),
                        ));
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Color(0xff161b27),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
