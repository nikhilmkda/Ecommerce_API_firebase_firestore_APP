import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/controller/authPage.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../controller/api_call.dart';
import '../user_details/get_user_data.dart';
import '../user_details/passwordSignin.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordUser = Provider.of<PasswordSigninProvider>(context);
    final getuser = Provider.of<UserDataProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final authenticationProvider = Provider.of<GoogleSignInProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/free-vector/empty-street-with-transport-highway-cartoon-illustration_1441-3972.jpg'),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: height / 16,
                left: width / 35,
                right: width / 35,
                top: height / 4,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: height / 1.9,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        // color: Color(0xff121220),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //         image: NetworkImage(
              //             'https://assets.stickpng.com/images/61f7cd6e67553f0004c53e73.png'),
              //         fit: BoxFit.contain),
              //   ),
              //   height: 120,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/37615/mother-daughter-shopping-clipart-md.png'),
                            fit: BoxFit.contain),
                      ),
                      height: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: passwordUser.emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: passwordUser.passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.only(right: 30),
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
                  const SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * .85,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
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
                        try {
                          final passwordUser =
                              Provider.of<PasswordSigninProvider>(context,
                                  listen: false);
                          passwordUser.handlePasswordLogin(context);
                          getuser.getUserData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthPage()),
                          );
                        } catch (e) {
                          print('Error occurred: $e');
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xff161b27),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'OR',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Colors.red, Color.fromARGB(255, 181, 49, 39)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Builder(builder: (context) {
                      return MaterialButton(
                        onPressed: () async {
                          try {
                            await authenticationProvider.googleLogin().then(
                                (value) =>
                                    dataProvider.navigateToAuthpage(context));
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to sign in with Google: $error'),
                              ),
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://www.seekpng.com/png/full/788-7887426_google-g-png-google-logo-white-png.png',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Login with Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New User ? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          dataProvider.navigateToSIgnupFirestore(context);
                        },
                        child: const Text(
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
