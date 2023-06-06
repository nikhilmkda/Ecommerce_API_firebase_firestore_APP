import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'image_picker.dart';
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

  dpimageUser(uid) async {
    userFace = await pickImage(uid);
    notifyListeners();
  }

  static Future<String?> pickImage(String userId) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('profilePictures/${const Uuid().v4()}');
      await ref.putFile(file);

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Save the download URL to Firestore under the user's document
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'photoUrl': imageUrl,
      });

      return imageUrl;
    } else {
      return null;
    }
  }
}
