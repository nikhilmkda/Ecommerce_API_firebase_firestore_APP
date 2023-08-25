import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/homepage.dart';
import '../view/log_in_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const MyHomePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
