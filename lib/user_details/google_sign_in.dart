import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;
final String uid = currentUser!.uid;

class GoogleSignInProvider extends ChangeNotifier {
  bool isGoogleSignIn = false;

    bool get googleSignInbool => isGoogleSignIn;

  void setGoogleSignIn(bool value) {
    isGoogleSignIn = value;
    notifyListeners();
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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

      await auth.signInWithCredential(credential);

      _user = user;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future logout() async {
    // await auth.signOut();
    await FirebaseAuth.instance.signOut();
    googleSignIn.signOut();

    isGoogleSignIn = false;
    _user = null;
    notifyListeners();
  }
}
