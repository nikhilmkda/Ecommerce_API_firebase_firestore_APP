import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_e_commerse_app_with_api/view/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final User? userG = FirebaseAuth.instance.currentUser;
final String uid = userG!.uid;

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googlecurrentuser() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final userData = await userDoc.get();
    if (!userData.exists) {
      await userDoc.set({
        'fullName': _user!.displayName,
        'email': _user!.email,
        'phone_number': '',
        'address': '',
        'age': ''
      });
    }
  }

  Future googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      _user = googleUser;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future logout() async {
    await _auth.signOut();
    _googleSignIn.signOut();

    _user = null;
    notifyListeners();
  }
}
