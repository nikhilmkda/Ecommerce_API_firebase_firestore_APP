import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GoogleSignInProvider extends ChangeNotifier {
  bool isGoogleSignIn = false;

  bool get googleSignInbool => isGoogleSignIn;

  void setGoogleSignIn(bool value) {
    isGoogleSignIn = value;
    notifyListeners();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final GoogleSignInAccount? user = await googleSignIn.signIn();
      if (user == null) return;
      isGoogleSignIn = true;
      final GoogleSignInAuthentication googleAuth = await user.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);

      _user = user;

      // Check if the user document exists in Firestore, if not, create one.
      final userDocument =
          await firestore.collection('users').doc(authResult.user!.uid).get();
      if (!userDocument.exists) {
        await firestore.collection('users').doc(authResult.user!.uid).set({
          'fullName': authResult.user!.displayName,
          'email': authResult.user!.email,
          // Add any other user data you want to store in Firestore.
        });
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    googleSignIn.signOut();

    isGoogleSignIn = false;
    _user = null;
    notifyListeners();
  }
}
