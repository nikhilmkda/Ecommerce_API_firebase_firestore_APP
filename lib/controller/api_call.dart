import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/view/save_to_firestore_sign_up.dart';
import 'package:http/http.dart' as http;

import '../view/cart_page.dart';

import '../view/homepage.dart';
import '../view/log_in_page.dart';
import '../model_class.dart';

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
        context, MaterialPageRoute(builder: (context) => Cart_page()));
  }

  void navigateToHomepage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  // void navigateToSIgnUp(BuildContext context) {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => SignUpPage()));
  // }

  void navigateToSIgnupFirestore(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }
}
