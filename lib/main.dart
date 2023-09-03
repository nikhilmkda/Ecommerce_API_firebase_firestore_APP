import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/controller/hive_save.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/get_user_data.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/google_sign_in.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/passwordSignin.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'controller/api_call.dart';

import 'controller/authPage.dart';
import 'controller/userdpprovider.dart';
import 'view/homepage.dart';
import 'view/log_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register the adapter for the int list
  Hive.registerAdapter(IntListAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HiveHelper()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => PasswordSigninProvider()),
        ChangeNotifierProvider(create: (_) => UserDPprovider()),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, title: 'My App', home: AuthPage()),
    );
  }
}
