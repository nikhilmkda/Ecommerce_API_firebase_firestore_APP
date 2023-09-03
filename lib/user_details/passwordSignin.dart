import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordSigninProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  

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

  void handlePasswordLogin(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print('Login successful. User ID: ${userCredential.user!.uid}');

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('Login failed. Error message: ${e.message}');
      final snackBar =
          SnackBar(content: Text(e.message ?? 'Unknown error occurred'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      notifyListeners();
    }
  }

  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
