import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/controller/authPage.dart';
import 'package:flutter_application_e_commerse_app_with_api/view/sign_up.dart';
import 'package:http/http.dart' as http;

import 'cart_page.dart';

import '../view/homepage.dart';
import '../view/log_in_page.dart';
import '../model_class/model_class.dart';

class DataProvider extends ChangeNotifier {
  int itemCount = 1;

  List<Product> _productsofproduct = [];
  bool _isLoading = false;
  @override
  notifyListeners();

  List<Product> get productsofproduct => _productsofproduct;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _productsofproduct = List<Product>.from(
          jsonData["products"].map((x) => Product.fromJson(x)));
      _isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void navigateToCart(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Cart_page()));
  }

  void navigateToHomepage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void navigateToSIgnupFirestore(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  void navigateToAuthpage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }
}
