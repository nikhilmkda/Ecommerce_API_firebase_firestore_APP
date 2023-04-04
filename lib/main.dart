import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/hive_save.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/get_user_data.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/google_sign_in.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/user_profile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'api_call.dart';

import 'homepage.dart';
import 'user_details/log_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register the adapter for the int list
  Hive.registerAdapter(IntListAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HiveHelper()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider<FormControllerProvider>(
          create: (context) => FormControllerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return MyHomePage();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
