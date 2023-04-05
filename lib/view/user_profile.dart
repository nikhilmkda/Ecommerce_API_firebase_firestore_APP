import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../user_details/get_user_data.dart';

class FormControllerProvider with ChangeNotifier {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Getter methods for the controllers
  TextEditingController get usernameController => _usernameController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get addressController => _addressController;
  TextEditingController get ageController => _ageController;

  // Helper method to clear all form field controllers
  void clearFormFields() {
    _usernameController.clear();
    _phoneNumberController.clear();
    _addressController.clear();
    _ageController.clear();

    notifyListeners();
  }
}

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DocumentSnapshot _userProfile;

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

            Provider.of<FormControllerProvider>(context, listen: false)
                .usernameController
                .text = _userProfile['fullName'];
            Provider.of<FormControllerProvider>(context, listen: false)
                .phoneNumberController
                .text = _userProfile['phone_number'];
            Provider.of<FormControllerProvider>(context, listen: false)
                .addressController
                .text = _userProfile['address'];
            Provider.of<FormControllerProvider>(context, listen: false)
                .ageController
                .text = _userProfile['age'].toString();
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Profile',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: NetworkImage(
          //         'https://mebincdn.themebin.com/1664962508289.png'),
          //     fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 35, 106),
              Color.fromARGB(255, 6, 3, 46),
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
                  child: Container(
                    child: CircleAvatar(
                      radius: 120,
                      backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/21/21104.png',
                      ),
                    ),
                    height: height * 0.28,
                  ),
                ),
                SizedBox(
                  height: height / 10,
                ),
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    controller: Provider.of<FormControllerProvider>(context)
                        .usernameController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
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
                  ),
                ),
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    controller: Provider.of<FormControllerProvider>(context)
                        .phoneNumberController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
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
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    controller: Provider.of<FormControllerProvider>(context)
                        .addressController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
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
                SizedBox(
                  height: height * 0.08,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: Provider.of<FormControllerProvider>(context)
                        .ageController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
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
                SizedBox(height: 16.0),
                Container(
                  width: MediaQuery.of(context).size.width * .93,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
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
                          'fullName': Provider.of<FormControllerProvider>(
                                  context,
                                  listen: false)
                              .usernameController
                              .text,
                          'phone_number': Provider.of<FormControllerProvider>(
                                  context,
                                  listen: false)
                              .phoneNumberController
                              .text,
                          'address': Provider.of<FormControllerProvider>(
                                  context,
                                  listen: false)
                              .addressController
                              .text,
                          'age': int.parse(Provider.of<FormControllerProvider>(
                                  context,
                                  listen: false)
                              .ageController
                              .text),
                        });
                        // Display a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('User profile updated successfully')),
                        );
                      } catch (e) {
                        print('Error updating user profile: $e');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error updating user profile: $e'),
                        ));
                      }
                    },
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Color(0xff161b27),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
