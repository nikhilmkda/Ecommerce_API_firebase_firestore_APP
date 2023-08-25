import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordSigninProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
