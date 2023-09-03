import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UserDataProvider extends ChangeNotifier {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? fullName;
  String? email;
  String? photoUrl;

  String _profilePictureUrl = '';

  String get profilePictureUrl => _profilePictureUrl;

  Future<void> pswdUserprofilePictureGet(String userId) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    _profilePictureUrl = userData['photoUrl'];
    notifyListeners();
  }

  Stream<Map<String, dynamic>> getUserDetailspswd() async* {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;

          fullName = data['fullName'];
          email = data['email'];
          photoUrl = data['photoUrl'];

          notifyListeners();

          yield data;
        } else {
          throw StateError('User data does not exist');
        }
      } catch (error) {
        throw StateError('Error fetching user data: $error');
      }
    } else {
      throw StateError('User is not authenticated');
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<Map<String, dynamic>> getUserDetailsgoogle() async* {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth != null) {
      final String name = googleUser!.displayName ?? 'No name';
      final String email = googleUser.email;
      final String photoUrl = googleUser.photoUrl ?? '';

      yield {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      };
    } else {
      throw StateError('Failed to sign in with Google');
    }
  }

  Future<void> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.request();
    print('Storage Permission Status: $status');
  }
}
