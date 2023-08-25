import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Userdetailsprovider with ChangeNotifier {
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

  String? userFace;
  String _profilePictureUrl = '';
  String get profilePictureUrl => _profilePictureUrl;

  Future<void> uploadProfilePicture(userid) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String userId = userid; // ... retrieve the current user's UID;

      final Reference storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(userId + '.jpg');

      await storageRef.putFile(File(pickedFile.path));
      print('Profile picture uploaded');

      await loadProfilePicture(userId);
    } else {
      print('No image selected');
    }
  }

  Future<void> loadProfilePicture(String userId) async {
    try {
      final Reference storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(userId + '.jpg');

      final url = await storageRef.getDownloadURL();
      _profilePictureUrl = url;
      notifyListeners();
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  Future<void> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.request();
    print('Storage Permission Status: $status');
  }

  // dpimageUser(uid) async {
  //   userFace = await pickImage(uid);

  //   notifyListeners();
  // }

  // static Future<String?> pickImage(String userId) async {
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       final file = File(pickedFile.path);
  //       final ref = FirebaseStorage.instance
  //           .ref()
  //           .child('profilePictures/${const Uuid().v4()}');
  //       await ref.putFile(file);

  //       final imageUrl = await ref.getDownloadURL();
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .update({
  //         'photoUrl': imageUrl,
  //       });

  //       return imageUrl;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error picking image: $e');
  //     return null;
  //   }
  // }
}
