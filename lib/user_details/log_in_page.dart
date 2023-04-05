import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../controller/api_call.dart';
import '../view/homepage.dart';

import 'get_user_data.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final getuser = Provider.of<UserDataProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final authenticationProvider = Provider.of<GoogleSignInProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    void handleLogin(BuildContext context) async {
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('Login successful. User ID: ${userCredential.user!.uid}');
        dataProvider.navigateToHomepage(context);
      } on FirebaseAuthException catch (e) {
        print('Login failed. Error message: ${e.message}');
        final snackBar =
            SnackBar(content: Text(e.message ?? 'Unknown error occurred'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://mebincdn.themebin.com/1664962508289.png'),
                fit: BoxFit.cover),
            // gradient: LinearGradient(
            //   colors: [
            //     Color.fromARGB(255, 255, 255, 255),
            //     Color.fromARGB(255, 255, 255, 255),
            //   ],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: height / 16,
                left: width / 35,
                right: width / 35,
                top: height / 4,
                child: Container(
                  height: height / 1.9,
                  decoration: BoxDecoration(
                    color: Color(0xff121220),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://png.pngtree.com/png-clipart/20220125/original/pngtree-girl-pushing-a-shopping-cart-png-image_7212166.png'),
                          fit: BoxFit.contain),
                    ),
                    height: 320,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'forgot password ?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * .85,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 189, 189, 189),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        handleLogin(context);
                        getuser.getUserData();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xff161b27),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'OR',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.red, Color.fromARGB(255, 181, 49, 39)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          await authenticationProvider.googleLogin();
                          await authenticationProvider.googlecurrentuser();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Failed to sign in with Google: $error'),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.seekpng.com/png/full/788-7887426_google-g-png-google-logo-white-png.png',
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Login with Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New User ? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          dataProvider.navigateToSIgnupFirestore(context);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
