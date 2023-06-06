import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/get_user_data.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/google_sign_in.dart';
import 'package:flutter_application_e_commerse_app_with_api/view/user_profile.dart';
import 'package:provider/provider.dart';

import '../controller/api_call.dart';
import '../controller/user_profile_provider.dart';

class DrawerScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String profilePIC;

  DrawerScreen(
      @required this.fullName, @required this.email, @required this.profilePIC);

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final userData = Provider.of<Userdetailsprovider>(context);
    final authenticationProvider = Provider.of<GoogleSignInProvider>(context);
    final getuser = Provider.of<UserDataProvider>(context);

    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user!.uid;

    return Drawer(
      backgroundColor: Colors.black38,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img4.goodfon.com/wallpaper/nbig/f/c6/material-design-hd-wallpaper-linii-background-color.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              fullName,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(profilePIC),
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                print('$uid');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(userId: uid)));
              }),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Colors.white,
            ),
            title: Text(
              'Help',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Navigate to help page
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => authenticationProvider
                .logout()
                .then((value) => userData.clearFormFields())
                .then((value) => dataProvider.navigateToLoginPage(context)),
          ),
        ],
      ),
    );
  }
}
