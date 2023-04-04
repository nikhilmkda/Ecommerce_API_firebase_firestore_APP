import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PswdImagePicker {
static Future<String?> pickImage(String userId) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final ref = FirebaseStorage.instance.ref().child('profilePictures/${const Uuid().v4()}');
    await ref.putFile(file);

    // Get the download URL of the uploaded image
    final imageUrl = await ref.getDownloadURL();

    // Save the download URL to Firestore under the user's document
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profilePicture': imageUrl,
    });

    return imageUrl;
  } else {
    return null;
  }
}

}
