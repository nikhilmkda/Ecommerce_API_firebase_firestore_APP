import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   
              

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String fullName, String photoUrl) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'fullName': fullName, 'email': email, 'photoUrl': photoUrl});
    } catch (e) {
      print('Failed to create user with email and password: $e');
      // Display error message
    }
  }

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

  Stream<Map<String, dynamic>> getUserData() async* {
    final User? user = _auth.currentUser;
    if (user != null) {
      yield* _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;

          fullName = data['fullName'];
          email = data['email'];
          photoUrl = data['photoUrl'];

          notifyListeners();

          return data;
        } else {
          throw StateError('User data does not exist');
        }
      });
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
}
