import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class UserDPprovider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _profilePicUrl;
  String get profilePicUrl => _profilePicUrl ?? '';

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final downloadUrl = await uploadImageToFirebase(imageFile);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'photoUrl': downloadUrl});

      _profilePicUrl = downloadUrl;
      notifyListeners(); // Notify any listeners that profile picture URL has changed
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}');
    final uploadTask = firebaseStorageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Stream<DocumentSnapshot> getUserStream() {
    notifyListeners();
    return FirebaseAuth.instance.authStateChanges().asyncMap((User? user) {
      if (user == null) {
        return Future.value(null);
      }
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .first;
    });
  }
}
