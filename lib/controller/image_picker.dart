// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

// import 'package:flutter/material.dart';


// class ProfilePage extends StatefulWidget {
//   final String userId;

//   ProfilePage(this.userId);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String? _imageUrl;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Page'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: CircleAvatar(
//               radius: 80,
//               backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
//               child: IconButton(
//                 icon: Icon(Icons.camera_alt),
//                 onPressed: () async {
//                   final imageUrl = await PswdImagePicker.pickImage(widget.userId);
//                   setState(() {
//                     _imageUrl = imageUrl;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// String? userFace;

// dpimageUser(uid)async{
// userFace=await PswdImagePicker.pickImage(uid);
// }

// class PswdImagePicker {
//   static Future<String?> pickImage(String userId) async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final file = File(pickedFile.path);
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('profilePictures/${const Uuid().v4()}');
//       await ref.putFile(file);

//       // Get the download URL of the uploaded image
//       final imageUrl = await ref.getDownloadURL();

//       // Save the download URL to Firestore under the user's document
//       await FirebaseFirestore.instance.collection('users').doc(userId).update({
//         'profilePicture': imageUrl,
//       });

//       return imageUrl;
//     } else {
//       return null;
//     }
//   }
// }
